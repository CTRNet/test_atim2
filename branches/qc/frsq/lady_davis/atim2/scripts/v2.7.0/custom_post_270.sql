
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Database Validation & Clean-up
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE coding_icd_o_3_morphology_custom MODIFY id int(11) NOT NULL AUTO_INCREMENT;
DROP table id_linking;
UPDATE consent_masters_revs SET consent_type = '' WHERE consent_type IS NULL;
ALTER TABLE consent_masters_revs MODIFY consent_type varchar(50) NOT NULL DEFAULT '';
DROP TABLE announcements_revs;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Databrowser
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- ViewAliquot TmaBlock
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
-- OrderItem TmaSlide
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
-- TmaSlide NonTmaBlockStorage
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
-- TmaSlide TmaBlock
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
-- TmaSlide StudySummary
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
-- TmaBlock NonTmaBlockStorage
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');

-- ViewAliquot StudySummary
-- UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
SELECT 'Do we want remove link ViewAliquot StudySummary? Some records exist.' AS '### WARNING ##';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Batch Actions & Report
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- TmaBlock create tma slide
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaBlock' AND label = 'create tma slide';
-- TmaSlide edit
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'edit';
-- Participant create participant message (applied to all)
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'create participant message (applied to all)';
-- TmaSlide add tma slide use
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add tma slide use';
-- TmaSlide add to order
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Use only one field tumor_site
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_lady_dxd_others CHANGE `tumor_site` `qc_lady_tumor_site` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE qc_lady_dxd_others_revs CHANGE `tumor_site` `qc_lady_tumor_site` varchar(100) NOT NULL DEFAULT '';
SET @structure_field_id_to_delete = (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_dxd_others' AND `field`='tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site') AND `flag_confidential`='0');
SET @structure_field_id_to_keep = (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='qc_lady_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site'));
UPDATE structure_formats SET structure_field_id =  @structure_field_id_to_keep WHERE structure_field_id = @structure_field_id_to_delete;
DELETE FROM structure_fields WHERE id = @structure_field_id_to_delete;
UPDATE structure_fields SET tablename = '' WHERE id = @structure_field_id_to_keep;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Participant Chronology
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- P. Identifiers

UPDATE structure_fields 
SET sortable = '1' 
WHERE id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'PMT', 'input',  NULL , '0', 'size=20', '', '', 'PMT', ''), 
('Datamart', '0', '', 'pdx', 'input',  NULL , '0', 'size=20', '', '', 'pdx', ''), 
('Datamart', '0', '', 'sequenom', 'input',  NULL , '0', 'size=20', '', '', 'sequenom', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='PMT' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='PMT' AND `language_tag`=''), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='pdx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='pdx' AND `language_tag`=''), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='sequenom' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='sequenom' ), '0', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- view_aliquot_joined_to_sample_and_collection update
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_order`='25' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temp_unit' 
AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='misc_identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- PBMC to Buffy Coat
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
('pbmc', 'PBMC', 'PBMC');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(208, 219, 209, 210);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(65);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(70);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(29);

UPDATE aliquot_controls SET detail_form_alias = 'qc_lady_ad_der_pbmc' WHERE id = 65;
UPDATE structures SET alias = 'qc_lady_ad_der_buffy_coat' WHERE alias = 'qc_lady_ad_der_pbmc';
UPDATE aliquot_controls SET detail_form_alias = 'qc_lady_ad_der_buffy_coat' WHERE detail_form_alias = 'qc_lady_ad_der_pbmc';

INSERT INTO sd_der_buffy_coats (sample_master_id) (SELECT sample_master_id FROM sd_der_pbmcs);
DELETE FROM sd_der_pbmcs;
INSERT INTO sd_der_buffy_coats_revs (sample_master_id, version_created) (SELECT sample_master_id, version_created FROM sd_der_pbmcs_revs);
DELETE FROM sd_der_pbmcs_revs;

UPDATE sample_masters 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
UPDATE sample_masters_revs 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');

UPDATE aliquot_masters 
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE aliquot_masters_revs
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE sample_masters SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'pbmc';
UPDATE sample_masters_revs SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'pbmc';

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(4);

UPDATE template_nodes
SET control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample')
AND control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');

UPDATE template_nodes
SET control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot')
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- TMA Block
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 1 WHERE storage_type = 'TMA-blc 29X21';
UPDATE structure_permissible_values_customs 
SET `en` = 'TMA-block', `fr` = 'TMA-bloc', `use_as_input` = '1'
WHERE `structure_permissible_values_customs`.`id` = '283';

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
UPDATE`structure_permissible_values_customs` 
SET `en` = 'TMA-block', `fr` = 'TMA-bloc'
WHERE control_id = @control_id
AND value = 'TMA-blc 29X21';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Templates	
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE templates SET created_by = 1 WHERE created_by = 0 OR created_by IS NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '' WHERE version_number = '2.7.0';
