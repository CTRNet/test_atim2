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
REPLACE INTO i18n (id, en, fr) VALUES
("Prostate", "Prostate", "Prostate"),
("sardo surgery config", "SARDO: Surgery configuration", "SARDO: Configuration des chirurgies"),
("unilateral", "Unilateral", "Unilatéral"),
("with reconstruction", "With reconstruction", "Avec reconstruction"),
("bilateral", "Bilateral", "Bilatéral"),
("simple", "Simple", "Simple"),
("radical", "Radical", "Radical"),
("turp", "TURP", "TURP"),
("laparoscopie", "Laparoscopy", "Laparoscopie"),
("ouverte", "Open", "Ouverte"),
("robotique", "Robotic", "Robotique"),
("blocks number", "blocks number", "# de blocs"),
("right ovary", "Right ovary", "Ovaire droit"),
("left ovary", "Left ovary", "Ovaire gauche"),
("epiploon", "Epiploon", "Épiploon"),
("location(site)", "Location", "Lieu"),
("report number", "Report number", "Numéro du rapport"),
("residual disease", "Residual disease", "Maladie résiduelle"),
("medication", "Medication", "Médication"),
("N/S", "N/S","N/S"),
("not evaluable", "Not evaluable", "Non évaluable"),
("suspect", "Suspect", "Suspect"),
("hormonotherapy", "Hormonotherapy", "Hormonothérapie"),
("is neoadjuvant", "Is neoadjuvant", "Est néo-adjuvant"),
("year of menopause", "Year of menopause", "Année de la ménopause"),
("cause", "Cause", "Cause"),
("aborta", "Aborta", "Aborta"),
('help_survival_time',
 "Survival time is the difference between date of death and diagnosis date. If date of death is not available, it's the difference between last contact date and diagnosis date. In both cases, both dates accuracy need to be exact.",
 "Le temps de survie est la différence entre la date du décès et la date du diagnostic. Si la date du décès n'est pas disponible, la différence entre la date du dernier contact et la date du diagnostic est utilisée. Dans les deux cas, la précision des deux dates dois être exacte."),
("survival time year(s)", "Survival time year(s)", "Temps de survie année(s)"),
("and day(s)", "and day(s)", "et jour(s)"),
("invalid primary disease code", "Invalid primary disease code", "Code de maladie primaire invalide"),
("figo stage", "Figo stage", "Stade figo"),
("icd10 - topo", "Icd10 - Topo", "Icd10 - Topo"),
("site", "Site", "Site"),
("ca125", "CA125", "CA125"),
("cigarettes per day", "Cigarettes per day", "Cigarettes par jour"),
("started on", "Started on", "Commencé le"),
("stopped on", "Stopped on", "Arrêté le"),
("detailed", "Detailed", "Détaillé"),
("post(mail)", "Post", "Poste"),
("post(after)", "Post", "Post");

ALTER TABLE structure_value_domains_permissible_values
 MODIFY COLUMN structure_value_domain_id INT NOT NULL;

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
RENAME TABLE qc_nd_ed_ca125_revs TO qc_nd_ed_ca125s_revs;
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
('general', 'lifestyle', 'smoking', 1, 'ed_all_lifestyle_smoking', 'ed_all_lifestyle_smokings', 0, 'lifestyle|all|smoking');

ALTER TABLE ed_all_lifestyle_smokings
 ADD COLUMN qc_nd_started_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_started_on_accuracy CHAR(1) DEFAULT 'c',
 ADD COLUMN qc_nd_stopped_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_stopped_on_accuracy CHAR(1) DEFAULT 'c',
 ADD COLUMN qc_nd_cigs_a_day SMALLINT UNSIGNED DEFAULT NULL;
ALTER TABLE ed_all_lifestyle_smokings_revs
 ADD COLUMN qc_nd_started_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_started_on_accuracy CHAR(1) DEFAULT 'c',
 ADD COLUMN qc_nd_stopped_on DATE DEFAULT NULL,
 ADD COLUMN qc_nd_stopped_on_accuracy CHAR(1) DEFAULT 'c',
 ADD COLUMN qc_nd_cigs_a_day SMALLINT UNSIGNED DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'qc_nd_started_on', 'date',  NULL , '0', '', '', '', 'started on', ''), 
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'qc_nd_stopped_on', 'date',  NULL , '0', '', '', '', 'stopped on', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='qc_nd_started_on' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='started on' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='qc_nd_stopped_on' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stopped on' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='years_quit_smoking' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'qc_nd_cigs_a_day', 'integer_positive',  NULL , '0', '', '', '', 'cigarettes per day', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='qc_nd_cigs_a_day' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cigarettes per day' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("post", "post(after)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="menopause_status"), (SELECT id FROM structure_permissible_values WHERE value="post" AND language_alias="post(after)"), "3", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="post" AND spv.language_alias="post";
DELETE FROM structure_permissible_values WHERE value="post" AND language_alias="post";

UPDATE structure_fields SET  `language_label`='year of menopause' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='qc_nd_year_menopause' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='location(site)' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_residual_disease", "", "", NULL);
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_residual_disease')  WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_nd_residual_disease' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE protocol_masters SET name='Chimiothérapie SAI' WHERE id=24;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_chemo_type", "", "", NULL);
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_chemo_type')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='qc_nd_type' AND `type`='input' AND structure_value_domain  IS NULL ;

SET foreign_key_checks = 0;
TRUNCATE diagnosis_masters;
TRUNCATE dxd_primaries;
TRUNCATE dxd_secondaries;
TRUNCATE dxd_remissions;
TRUNCATE dxd_progressions;
TRUNCATE dxd_recurrences;
TRUNCATE qc_nd_dxd_primary_sardos;
TRUNCATE qc_nd_dx_progression_sardos;
TRUNCATE diagnosis_masters_revs;
TRUNCATE dxd_primaries_revs;
TRUNCATE dxd_secondaries_revs;
TRUNCATE dxd_remissions_revs;
TRUNCATE dxd_progressions_revs;
TRUNCATE dxd_recurrences_revs;
TRUNCATE qc_nd_dxd_primary_sardos_revs;
TRUNCATE qc_nd_dx_progression_sardos_revs;
DELETE d, e FROM qc_nd_ed_all_procure_lifestyles AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_smintestines AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_perihilarbileducts AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_pancreasexos AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_pancreasendos AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_intrahepbileducts AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_hepatocellular_carcinomas AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_gallbladders AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_distalexbileducts AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_colon_biopsies AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_ampullas AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_cap_report_colon_rectum_resections AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_all_comorbidities AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_biopsy AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_cytology AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_ca125s AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_pathologies AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_observations AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_patho_prostates AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM qc_nd_ed_aps_prostates AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE d, e FROM ed_all_lifestyle_smokings AS d INNER JOIN event_masters AS e ON e.id=d.event_master_id WHERE e.created_by=12;
DELETE FROM event_masters_revs WHERE id NOT IN(SELECT id FROM event_masters);
DELETE FROM qc_nd_ed_all_procure_lifestyles_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_all_procure_lifestyles);
DELETE FROM ed_cap_report_smintestines_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_smintestines);
DELETE FROM ed_cap_report_perihilarbileducts_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_perihilarbileducts);
DELETE FROM ed_cap_report_pancreasexos_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_pancreasexos);
DELETE FROM ed_cap_report_pancreasendos_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_pancreasendos);
DELETE FROM ed_cap_report_intrahepbileducts_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_intrahepbileducts);
DELETE FROM ed_cap_report_hepatocellular_carcinomas_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_hepatocellular_carcinomas);
DELETE FROM ed_cap_report_gallbladders_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_gallbladders);
DELETE FROM ed_cap_report_distalexbileducts_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_distalexbileducts);
DELETE FROM ed_cap_report_colon_biopsies_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_colon_biopsies);
DELETE FROM ed_cap_report_ampullas_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_ampullas);
DELETE FROM ed_cap_report_colon_rectum_resections_revs WHERE id NOT IN(SELECT id FROM ed_cap_report_colon_rectum_resections);
DELETE FROM ed_all_comorbidities_revs WHERE id NOT IN(SELECT id FROM ed_all_comorbidities);
DELETE FROM qc_nd_ed_biopsy_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_biopsy);
DELETE FROM qc_nd_ed_cytology_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_cytology);
DELETE FROM qc_nd_ed_ca125s_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_ca125s);
DELETE FROM qc_nd_ed_pathologies_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_pathologies);
DELETE FROM qc_nd_ed_observations_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_observations);
DELETE FROM qc_nd_ed_patho_prostates_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_patho_prostates);
DELETE FROM qc_nd_ed_aps_prostates_revs WHERE id NOT IN(SELECT id FROM qc_nd_ed_aps_prostates);
DELETE FROM ed_all_lifestyle_smokings_revs WHERE id NOT IN(SELECT id FROM ed_all_lifestyle_smokings);
TRUNCATE treatment_masters;
TRUNCATE txd_chemos;
TRUNCATE txd_radiations;
TRUNCATE txd_surgeries;
TRUNCATE txd_surgeries;
TRUNCATE qc_nd_txd_hormonotherapies;
TRUNCATE qc_nd_txd_medications;
TRUNCATE family_histories;
TRUNCATE treatment_masters_revs;
TRUNCATE txd_chemos_revs;
TRUNCATE txd_radiations_revs;
TRUNCATE txd_surgeries_revs;
TRUNCATE txd_surgeries_revs;
TRUNCATE qc_nd_txd_hormonotherapies_revs;
TRUNCATE qc_nd_txd_medications_revs;
TRUNCATE family_histories_revs;
DELETE FROM reproductive_histories WHERE created_by=12;
DELETE FROM reproductive_histories_revs WHERE id NOT IN(SELECT id FROM reproductive_histories);
SET foreign_key_checks = 1;

ALTER TABLE qc_nd_txd_hormonotherapies
 DROP COLUMN is_neoadjuvant;
ALTER TABLE qc_nd_txd_hormonotherapies_revs
 DROP COLUMN is_neoadjuvant;

 
 DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_txd_hormonotherapies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_hormonotherapies' AND `field`='is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_hormonotherapies' AND `field`='is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_hormonotherapies' AND `field`='is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_hormonotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0'), '1', '3', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_hormonotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

ALTER TABLE txd_chemos
 DROP COLUMN qc_nd_is_neoadjuvant,
 DROP COLUMN qc_nd_pre_chir;
ALTER TABLE txd_chemos_revs
 DROP COLUMN qc_nd_is_neoadjuvant,
 DROP COLUMN qc_nd_pre_chir;

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_pre_chir' AND `language_label`='pre surgery' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_pre_chir' AND `language_label`='pre surgery' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_pre_chir' AND `language_label`='pre surgery' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') ,  `language_label`='location(site)' WHERE model='EventDetail' AND tablename='qc_nd_ed_biopsy' AND field='location' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location');

UPDATE structure_value_domains SET domain_name='qc_nd_result' WHERE domain_name='qc_nd_cytology_result';

ALTER TABLE qc_nd_ed_biopsy
 ADD COLUMN result VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE qc_nd_ed_biopsy_revs
 ADD COLUMN result VARCHAR(50) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_common');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', '', 'no_patho', 'input',  NULL , '0', '', '', '', 'no patho', ''), 
('Clinicalannotation', 'TreatmentDetail', '', 'location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') , '0', '', '', '', 'location(site)', ''), 
('Clinicalannotation', 'TreatmentDetail', '', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_result') , '0', '', '', '', 'result', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_common'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='no_patho' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='no patho' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_common'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='location(site)' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_common'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_biopsy') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='no_patho' AND `language_label`='no patho' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_biopsy') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='location' AND `language_label`='location(site)' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='no_patho' AND `language_label`='no patho' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='location' AND `language_label`='location(site)' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='no_patho' AND `language_label`='no patho' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='location' AND `language_label`='location(site)' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_cytology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_cytology' AND `field`='result' AND `language_label`='result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_result') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_cytology' AND `field`='result' AND `language_label`='result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_result') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_cytology' AND `field`='result' AND `language_label`='result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_result') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE event_controls SET form_alias='eventmasters,qc_nd_ed_cytology,qc_nd_ed_common' WHERE id=29;
UPDATE event_controls SET form_alias='eventmasters,qc_nd_ed_biopsy,qc_nd_ed_common' WHERE id=28;
 
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_is_neoadjuvant' AND `language_label`='is neoadjuvant' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-46' AND `plugin`='Clinicalannotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `language_label`='date/start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_start_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

ALTER TABLE family_histories
 DROP COLUMN qc_nd_sardo_type,
 DROP COLUMN last_sardo_import_date,
 CHANGE sardo_diagnosis_id qc_nd_sardo_diagnosis_id VARCHAR(20) NOT NULL DEFAULT '';
ALTER TABLE family_histories_revs
 DROP COLUMN qc_nd_sardo_type,
 DROP COLUMN last_sardo_import_date,
 CHANGE sardo_diagnosis_id qc_nd_sardo_diagnosis_id VARCHAR(20) NOT NULL DEFAULT '';

ALTER TABLE dxd_progressions
 ADD COLUMN qc_nd_initial CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE dxd_progressions_revs
 ADD COLUMN qc_nd_initial CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE qc_nd_ed_cytology
 ADD COLUMN no_patho VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN site VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE qc_nd_ed_cytology_revs
 ADD COLUMN no_patho VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN site VARCHAR(50) NOT NULL DEFAULT '';
 
ALTER TABLE dxd_progressions
 CHANGE COLUMN qc_nd_sites qc_nd_site VARCHAR(100);
ALTER TABLE dxd_progressions_revs
 CHANGE COLUMN qc_nd_sites qc_nd_site VARCHAR(100);
 
INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('ovary', 'lab', 'pathology', 1, 'eventmasters,qc_nd_ed_ovary_pathologies', 'qc_nd_ed_ovary_pathologies', 0, 'lab|ovary|pathology');

CREATE TABLE qc_nd_ed_ovary_pathologies(
 id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 blocks_number VARCHAR(50) NOT NULL DEFAULT '',
 ovary_right TEXT,
 ovary_left TEXT,
 epiploon VARCHAR(50) NOT NULL DEFAULT '',
 other VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT false
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_ovary_pathologies_revs(
 id INT NOT NULL,
 event_master_id INT NOT NULL,
 blocks_number VARCHAR(50) NOT NULL DEFAULT '',
 ovary_right TEXT,
 ovary_left TEXT,
 epiploon VARCHAR(50) NOT NULL DEFAULT '',
 other VARCHAR(50) NOT NULL DEFAULT '',
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='relation' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='relation') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='family_domain' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='domain') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');


INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_ovary_pathologies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_ovary_pathologies', 'blocks_number', 'input',  NULL , '0', '', '', '', 'blocks number', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_ovary_pathologies', 'ovary_right', 'input',  NULL , '0', '', '', '', 'right ovary', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_ovary_pathologies', 'ovary_left', 'input',  NULL , '0', '', '', '', 'left ovary', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_ovary_pathologies', 'epiploon', 'input',  NULL , '0', '', '', '', 'epiploon', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_ovary_pathologies', 'other', 'input',  NULL , '0', '', '', '', 'other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ovary_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ovary_pathologies' AND `field`='blocks_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blocks number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ovary_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ovary_pathologies' AND `field`='ovary_right' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='right ovary' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ovary_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ovary_pathologies' AND `field`='ovary_left' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='left ovary' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ovary_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ovary_pathologies' AND `field`='epiploon' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='epiploon' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ovary_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ovary_pathologies' AND `field`='other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_race", "open", "", NULL);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_race')  WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');

INSERT INTO treatment_controls (tx_method, disease_site, flag_active, detail_tablename, form_alias, extend_tablename, extend_form_alias, display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label) VALUES
('surgery', 'ovary', 1, 'txd_surgeries', 'treatmentmasters,qc_nd_txd_ovary_surgery', NULL, NULL, 0, NULL,NULL, 'ovary|surgery'), 
('surgery', 'prostate', 1, 'txd_surgeries', 'treatmentmasters,qc_nd_txd_prostate_surgery', NULL, NULL, 0, NULL,NULL, 'ovary|prostate'), 
('surgery', 'breast', 1, 'txd_surgeries', 'treatmentmasters,qc_nd_txd_breast_surgery', NULL, NULL, 0, NULL,NULL, 'ovary|breast'); 

ALTER TABLE txd_surgeries
 ADD COLUMN qc_nd_laterality VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN qc_nd_type VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN qc_nd_method VARCHAR(50) NOT NULL DEFAULT ''; 
ALTER TABLE txd_surgeries_revs
 ADD COLUMN qc_nd_laterality VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN qc_nd_type VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN qc_nd_method VARCHAR(50) NOT NULL DEFAULT ''; 

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_ovary_surgery_laterality", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("unilateral", "unilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="unilateral" AND language_alias="unilateral"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_prostate_surgery_type", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("radical", "radical");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_prostate_surgery_type"), (SELECT id FROM structure_permissible_values WHERE value="radical" AND language_alias="radical"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("turp", "turp");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_prostate_surgery_type"), (SELECT id FROM structure_permissible_values WHERE value="turp" AND language_alias="turp"), "1", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_breast_surgery_type", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_type"), (SELECT id FROM structure_permissible_values WHERE value="radical" AND language_alias="radical"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_type"), (SELECT id FROM structure_permissible_values WHERE value="partial" AND language_alias="partial"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("total", "total");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_type"), (SELECT id FROM structure_permissible_values WHERE value="total" AND language_alias="total"), "1", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_breast_surgery_laterality", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("simple", "simple");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="simple" AND language_alias="simple"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_laterality"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_ovary_surgery_method", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("laparoscopie", "laparoscopie");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_method"), (SELECT id FROM structure_permissible_values WHERE value="laparoscopie" AND language_alias="laparoscopie"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("robotique", "robotique");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ovary_surgery_method"), (SELECT id FROM structure_permissible_values WHERE value="robotique" AND language_alias="robotique"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('qc_nd_txd_ovary_surgery');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_laterality') , '0', '', '', '', 'laterality', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_method') , '0', '', '', '', 'method', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_precision', 'input',  NULL , '0', '', '', '', 'precision', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_residual_disease', 'input',  NULL , '0', '', '', '', 'residual disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_ovary_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_ovary_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_ovary_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_ovary_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_residual_disease' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='residual disease' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


INSERT INTO structures(`alias`) VALUES ('qc_nd_txd_prostate_surgery');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_prostate_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_prostate_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_prostate_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_residual_disease' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='residual disease' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_prostate_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_prostate_surgery_method", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_prostate_surgery_method"), (SELECT id FROM structure_permissible_values WHERE value="laparoscopie" AND language_alias="laparoscopie"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_prostate_surgery_method"), (SELECT id FROM structure_permissible_values WHERE value="robotique" AND language_alias="robotique"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ouverte", "ouverte");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_prostate_surgery_method"), (SELECT id FROM structure_permissible_values WHERE value="ouverte" AND language_alias="ouverte"), "1", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_method') , '0', '', '', '', 'method', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_method' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_method') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_txd_prostate_surgery') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_method') AND `flag_confidential`='0');
 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_breast_surgery_method", "open", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("with reconstruction", "with reconstruction");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_breast_surgery_method"), (SELECT id FROM structure_permissible_values WHERE value="with reconstruction" AND language_alias="with reconstruction"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('qc_nd_txd_breast_surgery');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_laterality') , '0', '', '', '', 'laterality', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_type') , '0', '', '', '', 'type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_method') , '0', '', '', '', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_breast_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_breast_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_breast_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_breast_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_breast_surgery'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_residual_disease' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='residual disease' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

SET foreign_key_checks = 0;
TRUNCATE protocol_masters;
TRUNCATE protocol_masters_revs;
TRUNCATE pd_chemos;
TRUNCATE pd_chemos_revs;
TRUNCATE pd_surgeries_revs;
DROP TABLE qc_nd_pd_sardo_radiations;
DROP TABLE qc_nd_pd_sardo_radiations_revs;
DROP TABLE qc_nd_pd_sardo_chemotherapies;
DROP TABLE qc_nd_pd_sardo_chemotherapies_revs;
SET foreign_key_checks = 1;
INSERT INTO treatment_controls (tx_method, disease_site, flag_active, detail_tablename, form_alias, extend_tablename, extend_form_alias, display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label) VALUES
('immunotherapy', 'general', 1, 'qc_nd_txd_immunotherapy', 'treatmentmasters,qc_nd_txd_immunotherapy', NULL, NULL, 0, NULL,NULL, 'general|immunotherapy'),
('unclassified', 'general', 0, 'qc_nd_txd_unclassifieds', 'treatmentmasters', NULL, NULL, 0, NULL,NULL, '');
CREATE TABLE qc_nd_txd_immunotherapy(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 treatment_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY(treatment_master_id) REFERENCES treatment_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_txd_immunotherapy_revs(
 id INT UNSIGNED NOT NULL,
 treatment_master_id INT NOT NULL,
 version_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;
CREATE TABLE qc_nd_txd_unclassifieds(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 treatment_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY(treatment_master_id) REFERENCES treatment_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_txd_unclassifieds_revs(
 id INT UNSIGNED NOT NULL,
 treatment_master_id INT NOT NULL,
 version_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

CREATE TABLE qc_nd_protocol_behaviors(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 protocol_master_id INT NOT NULL,
 protocol_control_id INT NOT NULL,
 UNIQUE KEY(protocol_master_id, protocol_control_id),
 FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters(id),
 FOREIGN KEY (protocol_control_id) REFERENCES protocol_controls(id)
)Engine=InnoDb;

CREATE TABLE qc_nd_proto_hormonotherapies(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 protocol_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY(protocol_master_id) REFERENCES protocol_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_proto_hormonotherapies_revs(
 id INT UNSIGNED NOT NULL,
 protocol_master_id INT NOT NULL,
 version_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;
CREATE TABLE qc_nd_proto_radiotherapies(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 protocol_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY(protocol_master_id) REFERENCES protocol_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_proto_radiotherapies_revs(
 id INT UNSIGNED NOT NULL,
 protocol_master_id INT NOT NULL,
 version_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;
CREATE TABLE qc_nd_proto_mixes(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 protocol_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY(protocol_master_id) REFERENCES protocol_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_proto_mixes_revs(
 id INT UNSIGNED NOT NULL,
 protocol_master_id INT NOT NULL,
 version_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

INSERT INTO protocol_controls (tumour_group, type, detail_tablename, form_alias, extend_tablename, extend_form_alias, created, created_by, modified, modified_by) VALUES
('general', 'hormonotherapy', 'qc_nd_proto_hormonotherapies', 'protocolmasters', NULL, NULL, NOW(), 1, NOW(), 1),
('general', 'radiotherapy', 'qc_nd_proto_radiotherapies', 'protocolmasters', NULL, NULL, NOW(), 1, NOW(), 1),
('general', 'mixed', 'qc_nd_proto_mixes', 'protocolmasters', NULL, NULL, NOW(), 1, NOW(), 1);

CREATE TABLE qc_nd_sardo_tx_conf_surgeries(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(200) NOT NULL UNIQUE,
 site VARCHAR(50) NOT NULL DEFAULT '',
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 m_type VARCHAR(50) NOT NULL DEFAULT '',
 method VARCHAR(50) NOT NULL DEFAULT ''
)Engine=InnoDb;

INSERT INTO qc_nd_sardo_tx_conf_surgeries(name, site, laterality, m_type, method) VALUES
("Colectomie partielle", "Autre", "", "", ""),
("Destruction de tumeur de la vessie", "Autre", "", "", ""),
("Excision de tumeur de la glande hypophysaire", "Autre", "", "", ""),
("Excision de tumeur de la peau", "Autre", "", "", ""),
("Excision de tumeur de l'anus", "Autre", "", "", ""),
("Excision électrochirurgicale à l'anse (LEEP) de tumeur du col utérin", "Autre", "", "", ""),
("Excision simple/partielle profonde (radicale) de la vulve", "Autre", "", "", ""),
("Excision simple/partielle superficielle de la vulve", "Autre", "", "", ""),
("Excision totale de la glande surrénale", "Autre", "", "", ""),
("Excision totale de la vésicule biliaire/Cholécystectomie", "Autre", "", "", ""),
("Exentération pelvienne postérieure", "Autre", "", "", ""),
("Gastrectomie partielle/subtotale + résection en bloc", "Autre", "", "", ""),
("Hémicolectomie droite", "Autre", "", "", ""),
("Hémicolectomie droite élargie + résection en bloc", "Autre", "", "", ""),
("Hystérectomie", "Autre", "", "", ""),
("Hystérectomie radicale  intervention de Wertheim", "Autre", "", "", ""),
("Hystérectomie sans salpingo-ovariectomie", "Autre", "", "", ""),
("Hystérectomie totale sans salpingo-ovariectomie", "Autre", "", "", ""),
("Laparotomie", "Autre", "", "", ""),
("Lobectomie du poumon +  dissection de gg médiastinal", "Autre", "", "", ""),
("Myomectomie", "Autre", "", "", ""),
("Néphrectomie radicale", "Autre", "", "", ""),
("Néphro-urétérectomie", "Autre", "", "", ""),
("Omentectomie partielle", "Autre", "", "", ""),
("Pancréatectomie corporéo-caudale", "Autre", "", "", ""),
("Parotidectomie totale, excision du nerf facial", "Autre", "", "", ""),
("Polypectomie du rectum", "Autre", "", "", ""),
("Résection abdomino-périnéale (APR)", "Autre", "", "", ""),
("Résection antérieure", "Autre", "", "", ""),
("Résection cunéiforme d'un lobe du poumon", "Autre", "", "", ""),
("Résection endo-anale", "Autre", "", "", ""),
("Résection iléo-caecale", "Autre", "", "", ""),
("Résection transurétrale de la vessie", "Autre", "", "", ""),
("Thyroïdectomie totale", "Autre", "", "", ""),
("Biopsie excisionnelle du sein", "Biopsie", "", "", ""),
("Biopsie par conisation du col utérin", "Biopsie", "", "", ""),
("Kystectomie ovarienne unilatérale", "Ovaire", "Unilatérale", "", ""),
("Ovariectomie", "Ovaire", "", "", ""),
("Ovariectomie + omentectomie", "Ovaire", "", "", ""),
("Ovariectomie bilatérale + hystérectomie totale", "Ovaire", "Bilatérale", "", ""),
("Ovariectomie bilatérale + omentectomie", "Ovaire", "Bilatérale", "", ""),
("Ovariectomie bilatérale sans hystérectomie", "Ovaire", "Bilatérale", "", ""),
("Ovariectomie unilatérale", "Ovaire", "Unilatérale", "", ""),
("Ovariectomie unilatérale sans hystérectomie", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie", "Ovaire", "", "", ""),
("Salpingo-ovariectomie bilatérale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + hystérectomie", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + hystérectomie subtotale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + hystérectomie totale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie + hystérectomie", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie + hystérectomie subtotale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie + hystérectomie totale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie partielle", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie partielle + hystérectomie", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie partielle + hystérectomie totale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie partielle sans hystérectomie", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie sans hystérectomie", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie totale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie bilatérale + omentectomie totale + hystérectomie totale", "Ovaire", "Bilatérale", "", ""),
("Salpingo-ovariectomie unilatérale", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale + hystérectomie totale", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale + omentectomie", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale + omentectomie + hystérectomie totale", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale + omentectomie partielle", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale + omentectomie partielle sans hystérectomie", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale + omentectomie totale + hystérectomie totale", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale sans hystérectomie", "Ovaire", "Unilatérale", "", ""),
("Salpingo-ovariectomie unilatérale+omentectomie partielle+hystérectomie totale", "Ovaire", "Unilatérale", "", ""),
("Prostatectomie radicale", "Prostate", "", "Radicale", ""),
("Prostatectomie totale", "Prostate", "", "Radicale", ""),
("Résection transurétrale de la prostate (TURP)", "Prostate", "", "TURP", ""),
("Mastectomie avec préservation cutanée", "Sein", "", "", ""),
("Mastectomie avec préservation cutanée + reconstruction combinée", "Sein", "", "", "avec reconstruction"),
("Mastectomie avec préservation cutanée + reconstruction par implant", "Sein", "", "", "avec reconstruction"),
("Mastectomie avec préservation cutanée + reconstruction par lambeau", "Sein", "", "", "avec reconstruction"),
("Mastectomie avec préservation cutanée + sein opp. non atteint + rec. combinée", "Sein", "", "", "avec reconstruction"),
("Mastectomie avec préservation cutanée + sein opposé non atteint", "Sein", "", "", ""),
("Mastectomie partielle", "Sein", "", "Partielle", ""),
("Mastectomie partielle + résection du mamelon", "Sein", "", "Partielle", ""),
("Mastectomie radicale", "Sein", "", "Radicale", ""),
("Mastectomie radicale élargie", "Sein", "", "Radicale", ""),
("Mastectomie radicale modifiée", "Sein", "", "Radicale", ""),
("Mastectomie radicale modifiée + reconstruction combinée", "Sein", "", "Radicale", "avec reconstruction"),
("Mastectomie radicale modifiée + reconstruction par implant", "Sein", "", "Radicale", "avec reconstruction"),
("Mastectomie radicale modifiée + reconstruction par lambeau", "Sein", "", "Radicale", "avec reconstruction"),
("Mastectomie radicale modifiée + sein opposé non atteint + reconstruction implant", "Sein", "", "Radicale", "avec reconstruction"),
("Mastectomie radicale modifiée + sein opposé non atteint + reconstruction lambeau", "Sein", "", "Radicale", "avec reconstruction"),
("Mastectomie simple/totale", "Sein", "Simple", "Totale", ""),
("Mastectomie simple/totale + reconstruction combinée", "Sein", "Simple", "Totale", "avec reconstruction"),
("Mastectomie simple/totale + reconstruction par implant", "Sein", "Simple", "Totale", "avec reconstruction"),
("Mastectomie simple/totale + reconstruction par lambeau", "Sein", "Simple", "Totale", "avec reconstruction"),
("Mastectomie simple/totale + sein opposé non atteint", "Sein", "Simple", "Totale", ""),
("Mastectomie simple/totale + sein opposé non atteint + reconstruction combinée", "Sein", "Simple", "Totale", "avec reconstruction"),
("Mastectomie sous-cutanée", "Sein", "", "", "");

UPDATE qc_nd_sardo_tx_conf_surgeries SET laterality='simple' WHERE laterality='Simple';
UPDATE qc_nd_sardo_tx_conf_surgeries SET laterality='unilateral' WHERE laterality='Unilatérale';
UPDATE qc_nd_sardo_tx_conf_surgeries SET laterality='bilateral' WHERE laterality='Bilatérale';
UPDATE qc_nd_sardo_tx_conf_surgeries SET m_type='radical' WHERE m_type='Radicale';
UPDATE qc_nd_sardo_tx_conf_surgeries SET m_type='turp' WHERE m_type='TURP';
UPDATE qc_nd_sardo_tx_conf_surgeries SET m_type='partial' WHERE m_type='Partielle';
UPDATE qc_nd_sardo_tx_conf_surgeries SET m_type='total' WHERE m_type='Totale';
UPDATE qc_nd_sardo_tx_conf_surgeries SET method='with reconstruction' WHERE method='avec reconstruction';

ALTER TABLE dxd_progressions
 MODIFY qc_nd_site TEXT; 
ALTER TABLE dxd_progressions_revs
 MODIFY qc_nd_site TEXT; 
 
ALTER TABLE qc_nd_ed_biopsy
 MODIFY `type` VARCHAR(100) NOT NULL DEFAULT '';
ALTER TABLE qc_nd_ed_biopsy_revs
 MODIFY `type` VARCHAR(100) NOT NULL DEFAULT '';
 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_sardo_surg_conf_site", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Autre", "other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_sardo_surg_conf_site"), (SELECT id FROM structure_permissible_values WHERE value="Autre" AND language_alias="other"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ovaire", "ovary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_sardo_surg_conf_site"), (SELECT id FROM structure_permissible_values WHERE value="Ovaire" AND language_alias="ovary"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Prostate", "prostate");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_sardo_surg_conf_site"), (SELECT id FROM structure_permissible_values WHERE value="Prostate" AND language_alias="prostate"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Sein", "breast");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_sardo_surg_conf_site"), (SELECT id FROM structure_permissible_values WHERE value="Sein" AND language_alias="breast"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('qc_nd_sardo_conf_surg_ov');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_laterality') , '0', '', '', '', 'laterality', ''), 
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_method') , '0', '', '', '', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_ov'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_ov'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ovary_surgery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_sardo_conf_surg_prost');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'm_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_type') , '0', '', '', '', 'type', ''), 
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_method') , '0', '', '', '', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_prost'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='m_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_prost'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_prostate_surgery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


INSERT INTO structures(`alias`) VALUES ('qc_nd_sardo_conf_surg_breast');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_laterality') , '0', '', '', '', 'laterality', ''), 
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'm_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_type') , '0', '', '', '', 'type', ''), 
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'method', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_method') , '0', '', '', '', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_breast'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_breast'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='m_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_conf_surg_breast'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='method' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_sardo_surg_conf_name');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'QcNdSardoTxConfSurgeries', 'qc_nd_sardo_tx_conf_surgeries', 'name', 'input',  NULL , '0', '', '', '', 'name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_surg_conf_name'), (SELECT id FROM structure_fields WHERE `model`='QcNdSardoTxConfSurgeries' AND `tablename`='qc_nd_sardo_tx_conf_surgeries' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
 
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_method')  WHERE model='QcNdSardoTxConfSurgeries' AND tablename='qc_nd_sardo_tx_conf_surgeries' AND field='method' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_breast_surgery_method');

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, flag_active) VALUES
('core_CAN_41_qc_nd_1', 'core_CAN_41', 0, 1, 'sardo surgery config', 'sardo surgery config', '/administrate/qc_nd_sardo/index/', 1); 
 
UPDATE menus SET flag_active=true WHERE id IN('proto_CAN_37', 'proto_CAN_82', 'proto_CAN_83');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_sardo_protocol", "open", "", "Protocol.ProtocolControl::getNonMixedProto");

INSERT INTO structures(`alias`) VALUES ('qc_nd_sardo_protocol');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Protocol', 'QcNdProtocolBehavior', 'qc_nd_protocol_behaviors', 'protocol_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protocol') , '0', '', '', '', 'protocol type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_protocol'), (SELECT id FROM structure_fields WHERE `model`='QcNdProtocolBehavior' AND `tablename`='qc_nd_protocol_behaviors' AND `field`='protocol_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protocol')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol type' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_sardo_protocol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QcNdProtocolBehavior' AND `tablename`='qc_nd_protocol_behaviors' AND `field`='protocol_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protocol') AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters
 MODIFY clinical_tstage VARCHAR(10) DEFAULT ''; 
ALTER TABLE diagnosis_masters_revs
 MODIFY clinical_tstage VARCHAR(10) DEFAULT ''; 
 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_pt", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt1", "pT1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt1" AND language_alias="pT1"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt1a", "pT1a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt1a" AND language_alias="pT1a"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt1b", "pT1b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt1b" AND language_alias="pT1b"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt1c", "pT1c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt1c" AND language_alias="pT1c"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt1mi", "pT1mi");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt1mi" AND language_alias="pT1mi"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt2", "pT2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt2" AND language_alias="pT2"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt2a", "pT2a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt2a" AND language_alias="pT2a"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt2b", "pT2b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt2b" AND language_alias="pT2b"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt2c", "pT2c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt2c" AND language_alias="pT2c"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt3", "pT3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt3" AND language_alias="pT3"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt3a", "pT3a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt3a" AND language_alias="pT3a"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt3b", "pT3b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt3b" AND language_alias="pT3b"), "12", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt3c", "pT3c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt3c" AND language_alias="pT3c"), "13", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt4", "pT4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt4" AND language_alias="pT4"), "14", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt4a", "pT4a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt4a" AND language_alias="pT4a"), "15", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt4b", "pT4b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt4b" AND language_alias="pT4b"), "16", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt4c", "pT4c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt4c" AND language_alias="pT4c"), "17", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pt4d", "pT4d");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="pt4d" AND language_alias="pT4d"), "18", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ptis", "pTis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="ptis" AND language_alias="pTis"), "19", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ptis(dcis)", "pTis(DCIS)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="ptis(dcis)" AND language_alias="pTis(DCIS)"), "20", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ptis(lcis)", "pTis(LCIS)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="ptis(lcis)" AND language_alias="pTis(LCIS)"), "21", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ptis(paget)", "pTis(Paget)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="ptis(paget)" AND language_alias="pTis(Paget)"), "22", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_ct", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct1", "cT1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct1" AND language_alias="cT1"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct1a", "cT1a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct1a" AND language_alias="cT1a"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct1b", "cT1b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct1b" AND language_alias="cT1b"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct1c", "cT1c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct1c" AND language_alias="cT1c"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct1mi", "cT1mi");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct1mi" AND language_alias="cT1mi"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct2", "cT2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct2" AND language_alias="cT2"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct2a", "cT2a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct2a" AND language_alias="cT2a"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct2b", "cT2b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct2b" AND language_alias="cT2b"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct2c", "cT2c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct2c" AND language_alias="cT2c"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct3", "cT3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct3" AND language_alias="cT3"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct3a", "cT3a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct3a" AND language_alias="cT3a"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct3b", "cT3b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct3b" AND language_alias="cT3b"), "12", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct3c", "cT3c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct3c" AND language_alias="cT3c"), "13", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct4", "cT4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct4" AND language_alias="cT4"), "14", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct4a", "cT4a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct4a" AND language_alias="cT4a"), "15", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct4b", "cT4b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct4b" AND language_alias="cT4b"), "16", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct4c", "cT4c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct4c" AND language_alias="cT4c"), "17", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ct4d", "cT4d");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ct4d" AND language_alias="cT4d"), "18", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ctis", "cTis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ctis" AND language_alias="cTis"), "19", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ctis(dcis)", "cTis(DCIS)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ctis(dcis)" AND language_alias="cTis(DCIS)"), "20", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ctis(lcis)", "cTis(LCIS)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ctis(lcis)" AND language_alias="cTis(LCIS)"), "21", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ctis(paget)", "cTis(Paget)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ctis(paget)" AND language_alias="cTis(Paget)"), "22", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_pt') , '0', '', '', '', 'pathological stage', 't stage');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_pt') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_pt') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ct') , '0', '', '', '', 'clinical stage', 't stage');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ct')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '1', 'size=4', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '1', 'size=4', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='figo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("ctx", "cTx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_ct"), (SELECT id FROM structure_permissible_values WHERE value="ctx" AND language_alias="cTx"), "23", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ptx", "pTx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_pt"), (SELECT id FROM structure_permissible_values WHERE value="ptx" AND language_alias="pTx"), "23", "1");

-- 2012-05-30

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_ascit_cell_storage_solution"), 
(SELECT id FROM structure_permissible_values WHERE value="DMSO + serum" AND language_alias="DMSO + serum"), "3", "1");


