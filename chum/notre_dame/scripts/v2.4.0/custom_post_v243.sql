INSERT INTO coding_icd_o_3_morphology (id, en_description, fr_description, translated, source) VALUES
("85242", "Carcinome lobulaire infiltrant avec autres types de carcinomes", "", 0, "SARDO"),
("84601", "Cystadénome séreux papillaire à la limite de la malignité", "", 0, "SARDO"),
("83842", "Adénocarcinome de type endocervical", "", 0, "SARDO"),
("85432", "Maladie de Paget et carcinome intracanalaire du sein", "", 0, "SARDO"),
("82461", "Tumeur neuroendocrinienne", "", 0, "SARDO"),
("84802", "Adénocarcinome colloïde in situ", "", 0, "SARDO"),
("84412", "Cystadénocarcinome séreux", "", 0, "SARDO"),
("84723", "Cystadénome mucineux à la limite de la malignité", "", 0, "SARDO"),
("85073", "Carcinome canalaire infiltrant micropapillaire", "", 0, "SARDO");

UPDATE coding_icd_o_3_morphology SET fr_description=en_description WHERE source="SARDO";


ALTER TABLE ad_tubes
  ADD COLUMN `chum_purification_method` varchar(100) DEFAULT NULL AFTER tmp_storage_method;
ALTER TABLE ad_tubes_revs
  ADD COLUMN `chum_purification_method` varchar(100) DEFAULT NULL AFTER tmp_storage_method;

INSERT INTO structures(`alias`) VALUES ('chum_rna_tube');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'chum_purification_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_rna_purification_method') , '0', '', '', '', 'purification method', ''); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chum_rna_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='chum_purification_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_rna_purification_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='purification method' AND `language_tag`=''), '1', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

UPDATE aliquot_controls SET form_alias = CONCAT(form_alias, ',chum_rna_tube') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna');

SET @purified_rna_ctrl_id = (SELECT id FROM sample_controls WHERE sample_type = 'purified rna');
SET @purified_rna_alq_ctrl_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @purified_rna_ctrl_id);

SELECT COUNT(*) AS 'Nbr of old purified rna tubes before deletion' FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id;
SELECT COUNT(*) AS 'Nbr of old purified rnas after before ' FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id;

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE derivative_sample_control_id = @purified_rna_ctrl_id;
UPDATE aliquot_controls SET flag_active=false WHERE sample_control_id = @purified_rna_ctrl_id;
UPDATE realiquoting_controls SET flag_active=false WHERE parent_aliquot_control_id = @purified_rna_alq_ctrl_id;

DELETE FROM order_items WHERE deleted = '1' AND aliquot_master_id  IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);
DELETE FROM order_items_revs WHERE aliquot_master_id  IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);

DELETE FROM ad_tubes WHERE deleted = '1' AND aliquot_master_id  IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);
DELETE FROM ad_tubes_revs WHERE aliquot_master_id  IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);

DELETE FROM quality_ctrls WHERE deleted = '1' AND aliquot_master_id  IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);
DELETE FROM quality_ctrls_revs WHERE aliquot_master_id  IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);

DELETE FROM realiquotings WHERE deleted = '1' AND parent_aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);
DELETE FROM realiquotings WHERE deleted = '1' AND child_aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);
DELETE FROM realiquotings_revs WHERE parent_aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);
DELETE FROM realiquotings_revs WHERE child_aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id);

DELETE FROM aliquot_masters WHERE deleted = '1' AND aliquot_control_id = @purified_rna_alq_ctrl_id;
DELETE FROM aliquot_masters_revs WHERE aliquot_control_id = @purified_rna_alq_ctrl_id;

DELETE FROM derivative_details WHERE deleted = '1' AND sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id);
DELETE FROM derivative_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id);

DELETE FROM sd_der_purified_rnas WHERE deleted = '1' AND sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id);
DELETE FROM sd_der_purified_rnas_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id);

DELETE FROM source_aliquots WHERE deleted = '1' AND sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id);
DELETE FROM source_aliquots_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id);

DELETE FROM sample_masters WHERE deleted = '1' AND sample_control_id = @purified_rna_ctrl_id;
DELETE FROM sample_masters_revs WHERE sample_control_id = @purified_rna_ctrl_id;

SELECT COUNT(*) AS 'Nbr of old purified rna tubes after deletion' FROM aliquot_masters WHERE aliquot_control_id = @purified_rna_alq_ctrl_id;
SELECT COUNT(*) AS 'Nbr of old purified rnas after deletion' FROM sample_masters WHERE sample_control_id = @purified_rna_ctrl_id;

SET @purified_rna_ctrl_id = (SELECT id FROM sample_controls WHERE sample_type = 'purified rna');
SET @purified_rna_alq_ctrl_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @purified_rna_ctrl_id);

DELETE FROM parent_to_derivative_sample_controls WHERE derivative_sample_control_id = @purified_rna_ctrl_id;
DELETE FROM realiquoting_controls WHERE parent_aliquot_control_id = @purified_rna_alq_ctrl_id;
DELETE FROM aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'purified rna');
DELETE FROM sample_controls WHERE sample_type = 'purified rna';

-- ran on 2012-03-14
INSERT INTO datamart_adhoc (title, description, plugin, model, form_alias_for_search, form_alias_for_results, form_links_for_results, sql_query_for_results, function_for_results, flag_use_control_for_results, created_by, modified_by) VALUES
('samples with aliquot counts', 'samples with aliquot counts description', 'inventorymanagement', 'ViewSample', 'view_sample_joined_to_collection', 'view_sample_joined_to_collection,qc_nd_sample_aliquot_count', 'detail=>/inventorymanagement/sample_masters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%/', '', 'sampleListWithAliquotCount', 1, 1, 1);

SET @last_datamart_adhoc = LAST_INSERT_ID();

INSERT INTO datamart_adhoc_permissions (group_id, datamart_adhoc_id) VALUES
(1, @last_datamart_adhoc),
(4, @last_datamart_adhoc); 

INSERT INTO structures(`alias`) VALUES ('qc_nd_sample_aliquot_count');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'avail', 'integer',  NULL , '0', '', '', '', 'in stock and available aliquots', ''), 
('', '0', '', 'not_avail', 'integer',  NULL , '0', '', '', '', 'in stock and unavailable aliquots', ''), 
('', '0', '', 'not_stock', 'integer',  NULL , '0', '', '', '', 'not in stock aliquots', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sample_aliquot_count'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='avail' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='in stock and available aliquots' AND `language_tag`=''), '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sample_aliquot_count'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='not_avail' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='in stock and unavailable aliquots' AND `language_tag`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sample_aliquot_count'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='not_stock' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='not in stock aliquots' AND `language_tag`=''), '0', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO i18n (id, en, fr) VALUES
("results truncated to %d", "Results truncated to %d.", "Résultats tronqués à %d."),
("samples with aliquot counts", "Samples with aliquot counts", "Échantillons avec les comptes d'aliquots"),
("samples with aliquot counts description",
 "Uses the sample search form. For each sample, indicates how many aliquots are either \"in stock and available\", \"in stock but not available\" and \"not in stock\".",
 "Utilise le formulaire de recherche des échantillons. Pour chaque échantillon, indique combien d'aliquots sont \"en stock et disponibles\", \"en stock et non disponibles\" et \"pas en stock\"."),
("in stock and available aliquots", "In stock and available aliquots", "Aliquots en stock et disponibles"),
("in stock and unavailable aliquots", "In stock and unavailable aliquots", "Aliquots en stock et non disponibles"),
("not in stock aliquots", "Not in stock aliquots", "Aliquots pas en stock");
-- end of ran on 2012-03-14


-- ---------------------------------------------------------------------------------------
-- Section below executed on server 2012-03-28
-- ---------------------------------------------------------------------------------------

ALTER TABLE order_lines
   MODIFY `sample_aliquot_precision` varchar(100) DEFAULT NULL;
ALTER TABLE order_lines_revs
   MODIFY `sample_aliquot_precision` varchar(100) DEFAULT NULL;

SET @tissue_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'tube' AND flag_active = '1' AND sample_control_id = (SELECT ID FROM sample_controls WHERE sample_type = 'tissue'));
SET @tissue_block_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'block' AND flag_active = '1' AND sample_control_id = (SELECT ID FROM sample_controls WHERE sample_type = 'tissue'));
SELECT @tissue_tube_aliquot_control_id as 1, @tissue_block_aliquot_control_id as 2;
INSERT INTO realiquoting_controls (	parent_aliquot_control_id, child_aliquot_control_id, flag_active ) VALUES (@tissue_block_aliquot_control_id, @tissue_tube_aliquot_control_id, '1');

UPDATE ad_tubes SET tmp_storage_solution='DMSO + serum' WHERE tmp_storage_solution='DMSO + Serum'; 
UPDATE ad_tubes_revs SET tmp_storage_solution='DMSO + serum' WHERE tmp_storage_solution='DMSO + Serum';

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tissue_storage_solution"), (SELECT id FROM structure_permissible_values WHERE value="DMSO + serum" AND language_alias="DMSO + serum"), "3", "1");
-- --------------

-- 2012-03-29
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-46' AND `plugin`='Clinicalannotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `language_label`='date/start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_start_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
-- end 2012-03-29


-- 2012-04-04
DELETE FROM structure_validations WHERE id IN(98, 99);
UPDATE structure_validations SET rule='validateIcd10CaCode', language_message='invalid disease code' WHERE id=97;
INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) VALUES
(2129, 'validateIcd10WhoCode', '', 'invalid disease code');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') ,  `language_label`='type' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='qc_nd_sardo_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='relation' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='relation') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='family_domain' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='domain') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='sardo_diagnosis_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') AND `flag_confidential`='0');

ALTER TABLE reproductive_histories
 ADD COLUMN qc_nd_aborta INT DEFAULT NULL AFTER qc_nd_gravida_para_aborta;
ALTER TABLE reproductive_histories_revs
 ADD COLUMN qc_nd_aborta INT DEFAULT NULL AFTER qc_nd_gravida_para_aborta;
 
UPDATE reproductive_histories SET gravida=SUBSTR(qc_nd_gravida_para_aborta, 2, 2) WHERE qc_nd_gravida_para_aborta!='';
UPDATE reproductive_histories SET para=SUBSTR(qc_nd_gravida_para_aborta, 6, 2) WHERE qc_nd_gravida_para_aborta!='';
UPDATE reproductive_histories SET qc_nd_aborta=SUBSTR(qc_nd_gravida_para_aborta, 10, 2) WHERE qc_nd_gravida_para_aborta!='';
UPDATE reproductive_histories_revs SET gravida=SUBSTR(qc_nd_gravida_para_aborta, 2, 2) WHERE qc_nd_gravida_para_aborta!='';
UPDATE reproductive_histories_revs SET para=SUBSTR(qc_nd_gravida_para_aborta, 6, 2) WHERE qc_nd_gravida_para_aborta!='';
UPDATE reproductive_histories_revs SET qc_nd_aborta=SUBSTR(qc_nd_gravida_para_aborta, 10, 2) WHERE qc_nd_gravida_para_aborta!='';

ALTER TABLE reproductive_histories
 DROP COLUMN qc_nd_gravida_para_aborta;
ALTER TABLE reproductive_histories_revs
 DROP COLUMN qc_nd_gravida_para_aborta;

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('laterality', 1, 50);
UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown('laterality')" WHERE domain_name='laterality';
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='laterality') ,  `language_label`='laterality' WHERE model='DiagnosisDetail' AND tablename='qc_nd_dxd_primary_sardos' AND field='laterality' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted) 
(SELECT 13, laterality, laterality, laterality, 0, 1, NOW(), 1, NOW(), 1, 0 FROM qc_nd_dxd_primary_sardos WHERE laterality != '' GROUP BY laterality);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE participants SET qc_nd_last_contact=IF(qc_nd_last_contact IS NULL, last_visit_date, IF(last_visit_date IS NULL, qc_nd_last_contact, IF(qc_nd_last_contact > last_visit_date, qc_nd_last_contact, last_visit_date))); 
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_visit_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters
 DROP COLUMN survival_time_months;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'survival_time_years', 'integer_positive',  NULL , '0', '', '', 'help_survival_time', 'year(s)', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'survival_time_days', 'integer_positive',  NULL , '0', '', '', '', '', 'day(s)');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_years' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_survival_time' AND `language_label`='year(s)' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_days' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='day(s)'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-101' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `language_label`='survival time months' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_survival time' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='survival time year(s)' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='survival_time_years' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='help_survival_time',  `language_tag`='and day(s)' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='survival_time_days' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;

REPLACE INTO i18n (id, en, fr) VALUES
('help_survival_time',
 "Survival time is the difference between date of death and diagnosis date. If date of death is not available, it's the difference between last contact date and diagnosis date. In both cases, both dates accuracy need to be exact.",
 "Le temps de survie est la différence entre la date du décès et la date du diagnostic. Si la date du décès n'est pas disponible, la différence entre la date du dernier contact et la date du diagnostic est utilisée. Dans les deux cas, la précision des deux dates dois être exacte."),
("survival time year(s)", "Survival time year(s)", "Temps de survie année(s)"),
("and day(s)", "and day(s)", "et jour(s)"),
("invalid primary disease code", "Invalid primary disease code", "Code de maladie primaire invalide"),
("figo stage", "Figo stage", "Stade figo"),
("icd10 - topo", "Icd10 - Topo", "Icd10 - Topo"),
("site", "Site", "Site"),
("ca125", "CA125", "CA125");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'qc_nd_aborta', 'integer_positive',  NULL , '0', '', '', '', 'aborta', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_aborta' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aborta' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `display_order`='21', `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='22', `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_gravida_para_aborta' AND `language_label`='gravida para aborta' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_gravida_para_aborta' AND `language_label`='gravida para aborta' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_gravida_para_aborta' AND `language_label`='gravida para aborta' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE diagnosis_controls SET controls_type='detailed' WHERE id IN(19, 20);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo') ,  `language_label`='figo stage' WHERE model='DiagnosisDetail' AND tablename='qc_nd_dxd_primary_sardos' AND field='figo' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='icd10 - topo' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='site' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_help`='help_memo' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='2', `display_order`='100', `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='101' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='figo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');

UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown('treatment facility')" WHERE domain_name='facility';
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES
('treatment facility', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted) 
(SELECT 14, qc_nd_location, qc_nd_location, qc_nd_location, 0, 1, NOW(), 1, NOW(), 1, 0 FROM txd_surgeries WHERE qc_nd_location != '' GROUP BY qc_nd_location);

UPDATE treatment_masters AS tm
INNER JOIN txd_surgeries AS ts ON tm.id=ts.treatment_master_id
SET tm.facility=ts.qc_nd_location;

ALTER TABLE txd_surgeries DROP COLUMN qc_nd_location;

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_location' AND `language_label`='location' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_location' AND `language_label`='location' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_location' AND `language_label`='location' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown('information source')" WHERE domain_name='information_source';
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES
('information source', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted) VALUES 
(15, 'pathology report', 'Pathology report', 'Rapport de pathologie', 0, 1, NOW(), 1, NOW(), 1, 0),
(15, 'operating protocol', 'Operating protocol', 'Protocole opératoire', 0, 1, NOW(), 1, NOW(), 1, 0),
(15, 'transcription/notes', 'Transcription/Notes', 'Transcription/Notes', 0, 1, NOW(), 1, NOW(), 1, 0);

UPDATE structure_fields SET  `language_label`='report number' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='path_num' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE txd_surgeries SET path_num=qc_nd_no_patho;
ALTER TABLE txd_surgeries DROP COLUMN qc_nd_no_patho;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_no_patho' AND `language_label`='no patho' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_no_patho' AND `language_label`='no patho' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_no_patho' AND `language_label`='no patho' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_dx_nature');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_nature'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0'), '1', '1', '', '1', 'site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_nature') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');

UPDATE event_controls SET disease_site='general' WHERE disease_site='all';
UPDATE treatment_controls SET disease_site='general' WHERE disease_site='all';

RENAME TABLE qc_nd_ed_ca125 TO qc_nd_ed_ca125s;
UPDATE structure_fields SET tablename='qc_nd_ed_ca125s' WHERE tablename='qc_nd_ed_ca125';
UPDATE event_controls SET detail_tablename='qc_nd_ed_ca125s' WHERE id=30;
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_ca125') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ca125s' AND `field`='value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE event_controls SET form_alias='eventmasters,qc_nd_ed_cytology' WHERE id=29;
ALTER TABLE qc_nd_ed_cytology
 ADD COLUMN result VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE qc_nd_ed_cytology_revs
 ADD COLUMN result VARCHAR(50) NOT NULL DEFAULT '';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_cytology_result", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="uncertain" AND language_alias="uncertain"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("not evaluable", "not evaluable");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="not evaluable" AND language_alias="not evaluable"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("suspect", "suspect");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="suspect" AND language_alias="suspect"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="not done" AND language_alias="not done"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_cytology_result"), (SELECT id FROM structure_permissible_values WHERE value="N/S" AND language_alias="N/S"), "1", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_cytology_type", "", "", NULL);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_cytology', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_cytology_result') , '0', '', '', '', 'result', '');
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_cytology');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_cytology', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_cytology_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_cytology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_cytology' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_cytology_result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_cytology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_cytology' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_cytology_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_hormono_type", "", "", NULL);
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_hormono_type')  WHERE model='TreatmentDetail' AND tablename='qc_nd_txd_hormonotherapies' AND field='type' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='date_captured' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE event_controls SET event_type='procure (questionnaire)' WHERE id=11;

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('general', 'lifestyle', 'smoking', 1, 'eventmasters,ed_all_lifestyle_smoking', 'ed_all_lifestyle_smokings', 0, 'lifestyle|all|smoking');

ALTER TABLE ed_all_lifestyle_smokings
 ADD COLUMN qc_nd_started_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_started_on_accuracy CHAR(1) DEFAULT 'c',
 ADD COLUMN qc_nd_stopped_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_stopped_on_accuracy CHAR(1) DEFAULT 'c';
ALTER TABLE ed_all_lifestyle_smokings_revs
 ADD COLUMN qc_nd_started_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_started_on_accuracy CHAR(1) DEFAULT 'c',
 ADD COLUMN qc_nd_stopped_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_stopped_on_accuracy CHAR(1) DEFAULT 'c';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'qc_nd_started_on', 'date',  NULL , '0', '', '', '', 'started on', ''), 
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'qc_nd_stopped_on', 'date',  NULL , '0', '', '', '', 'stopped on', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='qc_nd_started_on' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='started on' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='qc_nd_stopped_on' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stopped on' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='years_quit_smoking' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

