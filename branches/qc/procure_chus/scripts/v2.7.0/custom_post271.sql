-- -----------------------------------------------------------------------------------------------------------------------------------
-- Collection Protocol
-- -----------------------------------------------------------------------------------------------------------------------------------

 UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
 WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
 AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

 UPDATE structure_formats SET `language_heading`='collection' 
 WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
 AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

 UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
 WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
 AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

 UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
 WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
 AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Missing i18n
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('no data','No Data','Aucune donnée');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- New Template
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE template_nodes SET parent_id = null WHERE template_id IN (SELECT id FROM templates WHERE name IN ('Urine', 'Blood/Sang', 'Tissue/Tissu'));
DELETE FROM template_nodes WHERE template_id IN (SELECT id FROM templates WHERE name IN ('Urine', 'Blood/Sang', 'Tissue/Tissu'));
UPDATE templates SET `owner` = 'all', `visibility` = 'all' WHERE name IN ('Urine', 'Blood/Sang', 'Tissue/Tissu');

SET @sample_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');

-- Tissue/Tissu

SET @MAX_ID = (SELECT IFNULL(MAX(id), 0) FROM template_nodes);
SET @template_id = (SELECT id FROM templates WHERE name = 'Tissue/Tissu');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 1), NULL, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'tissue'), 1, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 2),(@MAX_ID + 1), @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'tissue' AND aliquot_type = 'block'), 1, '{\"AliquotDetail\":{\"block_type\":\"frozen\"}}');

-- Tissue/Tissu

SET @MAX_ID = (SELECT MAX(id) FROM template_nodes);
SET @template_id = (SELECT id FROM templates WHERE name = 'Urine');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 1), NULL, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'urine'), 1, '{\"SampleDetail\":{\"urine_aspect\":\"clear\",\"procure_hematuria\":\"n\",\"procure_collected_via_catheter\":\"n\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 2), (@MAX_ID + 1), @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'centrifuged urine'), 1, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 3), (@MAX_ID + 2), @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'centrifuged urine' AND aliquot_type = 'tube'), 4, '{\"AliquotMaster\":{\"initial_volume\":\"5\"}}');

-- Blood/Sang

SET @MAX_ID = (SELECT IFNULL(MAX(id), 0) FROM template_nodes);
SET @template_id = (SELECT id FROM templates WHERE name = 'Blood/Sang');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 1), NULL, 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'blood'), 1, '{\"SampleDetail\":{\"blood_type\":\"serum\",\"procure_collection_site\":\"clinic\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 2), (@MAX_ID + 1), 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'serum'), 1, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 3), (@MAX_ID + 2), 2, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'serum' AND aliquot_type = 'tube'), 2, '{\"AliquotMaster\":{\"initial_volume\":\"1.8\"},\"AliquotDetail\":{\"hemolysis_signs\":\"n\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 4), NULL, 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'blood'), 1, '{\"SampleDetail\":{\"blood_type\":\"paxgene\",\"procure_collection_site\":\"clinic\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 5), (@MAX_ID + 4), 2, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube'), 1, '{\"AliquotMaster\":{\"initial_volume\":\"9\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 6), NULL, 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'blood'), 1, '{\"SampleDetail\":{\"blood_type\":\"k2-EDTA\",\"procure_collection_site\":\"clinic\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 7), (@MAX_ID + 6), 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'plasma'), 1, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 8), (@MAX_ID + 7), 2, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'plasma' AND aliquot_type = 'tube'), 5, '{\"AliquotMaster\":{\"initial_volume\":\"1.8\"},\"AliquotDetail\":{\"hemolysis_signs\":\"n\"}}');
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 9), (@MAX_ID + 6), 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'buffy coat'), 1, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 10), (@MAX_ID + 9), 2, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube'), 2, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 11), (@MAX_ID + 6), 2, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'pbmc'), 1, NULL);
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`, `default_values`) 
VALUES
((@MAX_ID + 13), (@MAX_ID + 11), 2, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube'), 3, '{\"AliquotMaster\":{\"initial_volume\":\"1\"}}');

-- template_init_structure

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='specimen', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_serum_creation_datetime', 'datetime',  NULL , '0', '', '', '', 'serum creation date if applicable', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_creation_datetime_defintion' AND `language_label`='creation date' AND `language_tag`=''), '2', '400', 'derivative', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_serum_creation_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='serum creation date if applicable' AND `language_tag`=''), '2', '401', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_initial_storage_datetime_defintion' AND `language_label`='initial storage date' AND `language_tag`=''), '3', '500', 'aliquot', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_blood_collection_sites')  AND `flag_confidential`='0'), '1', '310', '', '0', '1', 'blood collection was done (if applicable)', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_date_at_minus_80' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date at -80' AND `language_tag`=''), '3', '501', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES
('serum creation date if applicable', 'Serum : Creation Date', 'Sérum : Date création');
INSERT INTO i18n (id,en,fr) 
(SELECT 'blood collection was done (if applicable)', CONCAT(en, " (If Applicable)"), CONCAT(fr, " (si applicable)") FROM i18n WHERE id = 'blood collection was done');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='600', `language_heading`='others (if applicable)' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_serum_creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='601', `flag_override_label`='1', `language_label`='pbmc date at -80' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_date_at_minus_80' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
(SELECT 'pbmc date at -80', CONCAT('PBMC : ', en), CONCAT('PBMC : ', fr) FROM i18n WHERE id = 'date at -80');
INSERT INTO i18n (id,en,fr) 
VALUES
('others (if applicable)', 'Others (If Applicable)', 'Autres (Si applicable)');

REPLACE INTO i18n (id,en,fr)
VALUES 
('blood collection was done (if applicable)', "Blood : Collection was done", "Sang : Le prélèvement a été effectué");
UPDATE structure_formats SET `display_column`='2', `display_order`='602' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_blood_collection_sites') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7336' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 20180817
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='3', `display_order`='602' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_blood_collection_sites') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7339' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Anonymize local database fields 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- study_summaries
-- ---------------

ALTER TABLE `study_summaries`
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chum` `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chus` `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chuq` `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_cusm` `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps1' WHERE field = 'procure_site_ethics_committee_convenience_chum';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps4' WHERE field = 'procure_site_ethics_committee_convenience_chus';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps2' WHERE field = 'procure_site_ethics_committee_convenience_chuq';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps3' WHERE field = 'procure_site_ethics_committee_convenience_cusm';
UPDATE structure_fields SET language_label = '' WHERE field = '';
UPDATE structure_fields SET language_label = 'committee_convenience_ps1' WHERE field = 'procure_site_ethics_committee_convenience_ps1';
UPDATE structure_fields SET language_label = 'committee_convenience_ps4' WHERE field = 'procure_site_ethics_committee_convenience_ps4';
UPDATE structure_fields SET language_label = 'committee_convenience_ps2' WHERE field = 'procure_site_ethics_committee_convenience_ps2';
UPDATE structure_fields SET language_label = 'committee_convenience_ps3' WHERE field = 'procure_site_ethics_committee_convenience_ps3';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('committee_convenience_ps1', 'CHUM', 'CHUM'),
('committee_convenience_ps2', 'CHUQ', 'CHUQ'),
('committee_convenience_ps3', 'CUSM', 'MUHC'),
('committee_convenience_ps4', 'CHUS', 'CHUS');

-- procure_cd_sigantures & consent_controls
-- ----------------------------------------
-- Uncomment line that could not be applied on local installation

-- Linked to PS1 fields

UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_cd_data', 'ps1_cd_data') WHERE detail_form_alias LIKE '%qc_nd_cd_data%';
UPDATE structures SET alias = 'ps1_cd_data' WHERE  alias = 'qc_nd_cd_data';
UPDATE structure_value_domains SET domain_name = 'ps1_stop_followup' WHERE domain_name = 'qc_nd_stop_followup';

-- ALTER TABLE procure_cd_sigantures
--   CHANGE COLUMN `qc_nd_biological_material_use` `ps1_biological_material_use` varchar(50) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_use_of_urine` `ps1_use_of_urine` varchar(50) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_use_of_blood` `ps1_use_of_blood` varchar(50) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_research_other_disease` `ps1_research_other_disease` varchar(50) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_urine_blood_use_for_followup` `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_stop_followup` `ps1_stop_followup` varchar(10) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_stop_followup_date` `ps1_stop_followup_date` date DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_allow_questionnaire` `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_stop_questionnaire` `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_stop_questionnaire_date` `ps1_stop_questionnaire_date` date DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_contact_for_additional_data` `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_inform_significant_discovery` `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
--   CHANGE COLUMN `qc_nd_inform_discovery_on_other_disease` `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL;
ALTER TABLE procure_cd_sigantures
  ADD COLUMN `ps1_biological_material_use` varchar(50) DEFAULT NULL,
  ADD COLUMN `ps1_use_of_urine` varchar(50) DEFAULT NULL,
  ADD COLUMN `ps1_use_of_blood` varchar(50) DEFAULT NULL,
  ADD COLUMN `ps1_research_other_disease` varchar(50) DEFAULT NULL,
  ADD COLUMN `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN `ps1_stop_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN `ps1_stop_followup_date` date DEFAULT NULL,
  ADD COLUMN `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN `ps1_stop_questionnaire_date` date DEFAULT NULL,
  ADD COLUMN `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
  ADD COLUMN `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
  ADD COLUMN `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL; 
UPDATE structure_fields SET field = 'ps1_biological_material_use' WHERE field = 'qc_nd_biological_material_use';
UPDATE structure_fields SET field = 'ps1_use_of_urine' WHERE field = 'qc_nd_use_of_urine';
UPDATE structure_fields SET field = 'ps1_use_of_blood' WHERE field = 'qc_nd_use_of_blood';
UPDATE structure_fields SET field = 'ps1_research_other_disease' WHERE field = 'qc_nd_research_other_disease';
UPDATE structure_fields SET field = 'ps1_urine_blood_use_for_followup' WHERE field = 'qc_nd_urine_blood_use_for_followup';
UPDATE structure_fields SET field = 'ps1_stop_followup' WHERE field = 'qc_nd_stop_followup';
UPDATE structure_fields SET field = 'ps1_stop_followup_date' WHERE field = 'qc_nd_stop_followup_date';
UPDATE structure_fields SET field = 'ps1_allow_questionnaire' WHERE field = 'qc_nd_allow_questionnaire';
UPDATE structure_fields SET field = 'ps1_stop_questionnaire' WHERE field = 'qc_nd_stop_questionnaire';
UPDATE structure_fields SET field = 'ps1_stop_questionnaire_date' WHERE field = 'qc_nd_stop_questionnaire_date';
UPDATE structure_fields SET field = 'ps1_contact_for_additional_data' WHERE field = 'qc_nd_contact_for_additional_data';
UPDATE structure_fields SET field = 'ps1_inform_significant_discovery' WHERE field = 'qc_nd_inform_significant_discovery';
UPDATE structure_fields SET field = 'ps1_inform_discovery_on_other_disease' WHERE field = 'qc_nd_inform_discovery_on_other_disease';

-- Linked to PS2 fields

-- ALTER TABLE procure_cd_sigantures
--   CHANGE COLUMN `procure_chuq_tissue` `ps2_tissue` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_blood` `ps2_blood` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_urine` `ps2_urine` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_followup` `ps2_followup` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_questionnaire` `ps2_questionnaire` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_contact_for_additional_data` `ps2_contact_for_additional_data` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_inform_significant_discovery` `ps2_inform_significant_discovery` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_contact_in_case_of_death` `ps2_contact_in_case_of_death` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_witness` `ps2_witness` char(1) DEFAULT '',
--   CHANGE COLUMN `procure_chuq_complete` `ps2_complete` char(1) DEFAULT '';    
ALTER TABLE procure_cd_sigantures
  ADD COLUMN `ps2_tissue` char(1) DEFAULT '',
  ADD COLUMN `ps2_blood` char(1) DEFAULT '',
  ADD COLUMN `ps2_urine` char(1) DEFAULT '',
  ADD COLUMN `ps2_followup` char(1) DEFAULT '',
  ADD COLUMN `ps2_questionnaire` char(1) DEFAULT '',
  ADD COLUMN `ps2_contact_for_additional_data` char(1) DEFAULT '',
  ADD COLUMN `ps2_inform_significant_discovery` char(1) DEFAULT '',
  ADD COLUMN `ps2_contact_in_case_of_death` char(1) DEFAULT '',
  ADD COLUMN `ps2_witness` char(1) DEFAULT '',
  ADD COLUMN `ps2_complete` char(1) DEFAULT '';   
UPDATE structure_fields SET field = 'ps2_tissue' WHERE field = 'procure_chuq_tissue';
UPDATE structure_fields SET field = 'ps2_blood' WHERE field = 'procure_chuq_blood';
UPDATE structure_fields SET field = 'ps2_urine' WHERE field = 'procure_chuq_urine';
UPDATE structure_fields SET field = 'ps2_followup' WHERE field = 'procure_chuq_followup';
UPDATE structure_fields SET field = 'ps2_questionnaire' WHERE field = 'procure_chuq_questionnaire';
UPDATE structure_fields SET field = 'ps2_contact_for_additional_data' WHERE field = 'procure_chuq_contact_for_additional_data';
UPDATE structure_fields SET field = 'ps2_inform_significant_discovery' WHERE field = 'procure_chuq_inform_significant_discovery';
UPDATE structure_fields SET field = 'ps2_contact_in_case_of_death' WHERE field = 'procure_chuq_contact_in_case_of_death';
UPDATE structure_fields SET field = 'ps2_witness' WHERE field = 'procure_chuq_witness';
UPDATE structure_fields SET field = 'ps2_complete' WHERE field = 'procure_chuq_complete';
  
-- Linked to PS4 fields

ALTER TABLE procure_cd_sigantures
  CHANGE COLUMN `procure_chus_contact_for_more_info` `ps4_contact_for_more_info` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_contact_if_scientific_discovery` `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_study_on_other_diseases` `ps4_study_on_other_diseases` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_contact_if_discovery_on_other_diseases` `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_other_contacts_in_case_of_death` `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';
-- ALTER TABLE procure_cd_sigantures
--  ADD COLUMN `ps4_contact_for_more_info` char(1) DEFAULT '',
--  ADD COLUMN `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
--  ADD COLUMN `ps4_study_on_other_diseases` char(1) DEFAULT '',
--  ADD COLUMN `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
--  ADD COLUMN `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';
UPDATE structure_fields SET field = 'ps4_contact_for_more_info' WHERE field = 'procure_chus_contact_for_more_info';
UPDATE structure_fields SET field = 'ps4_contact_if_scientific_discovery' WHERE field = 'procure_chus_contact_if_scientific_discovery';
UPDATE structure_fields SET field = 'ps4_study_on_other_diseases' WHERE field = 'procure_chus_study_on_other_diseases';
UPDATE structure_fields SET field = 'ps4_contact_if_discovery_on_other_diseases' WHERE field = 'procure_chus_contact_if_discovery_on_other_diseases';
UPDATE structure_fields SET field = 'ps4_other_contacts_in_case_of_death' WHERE field = 'procure_chus_other_contacts_in_case_of_death';

UPDATE versions SET branch_build_number = '7347' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7389' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7403' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7411' WHERE version_number = '2.7.1';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_pbmc_storage_datetime', 'datetime',  NULL , '0', '', '', '', '', 'storage');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pbmc_storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='storage'), '3', '601', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_date_at_minus_80', 'date',  NULL , '0', '', '', '', 'pbmc date at -80', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_date_at_minus_80' AND `type`='date' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_date_at_minus_80' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_serum_storage_datetime', 'datetime',  NULL , '0', '', '', '', '', 'storage');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_serum_storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='storage'), '3', '600', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE versions SET branch_build_number = '7415' WHERE version_number = '2.7.1';
