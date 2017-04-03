
SELECT "
SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';" as '### TODO ###: Run following queries';


-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Migrate blood cell sample and aliquot to buffy coat sample and aliquot
-- ---------------------------------------------------------------------------------------------------------------------------------------

SET @blc_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood cell');
SET @bfc_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE derivative_sample_control_id = @blc_control_id;
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE derivative_sample_control_id = @bfc_control_id;
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE parent_sample_control_id = @bfc_control_id AND derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('cell culture', 'dna', 'rna'));

UPDATE aliquot_controls SET flag_active=true WHERE sample_control_id = @bfc_control_id;
UPDATE realiquoting_controls SET flag_active=true WHERE parent_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @bfc_control_id);

ALTER TABLE sd_der_buffy_coats ADD COLUMN `ovcare_ischemia_time_mn` int(6) DEFAULT NULL;
ALTER TABLE sd_der_buffy_coats_revs ADD COLUMN `ovcare_ischemia_time_mn` int(6) DEFAULT NULL;

INSERT INTO sd_der_buffy_coats (sample_master_id, ovcare_ischemia_time_mn) (SELECT sample_master_id, ovcare_ischemia_time_mn FROM sd_der_blood_cells);
DELETE FROM sd_der_blood_cells;
INSERT INTO sd_der_buffy_coats_revs (sample_master_id, ovcare_ischemia_time_mn, version_created) (SELECT sample_master_id, ovcare_ischemia_time_mn, version_created FROM sd_der_blood_cells_revs);
DELETE FROM sd_der_blood_cells_revs;

UPDATE sample_masters 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood cell');
UPDATE sample_masters_revs 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood cell');
UPDATE aliquot_masters 
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood cell' AND aliquot_type = 'tube');
UPDATE aliquot_masters_revs
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood cell' AND aliquot_type = 'tube');
UPDATE sample_masters SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'blood cell';
UPDATE sample_masters_revs SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'blood cell';

REPLACE INTO i18n (id,en,fr)
VALUES
('blood cell', 'Blood Cells', 'Cellules de sang');

UPDATE structure_fields SET  tablename='sd_der_buffy_coats' WHERE model='SampleDetail' AND tablename='sd_der_blood_cells' AND field='ovcare_ischemia_time_mn' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structures SET alias = 'ovcare_sd_der_pbmcs' WHERE alias = 'ovcare_sd_der_blood_cells';
UPDATE sample_controls SET detail_form_alias = 'sd_undetailed_derivatives,derivatives' WHERE sample_type = 'blood cell';
UPDATE sample_controls SET detail_form_alias = CONCAT('ovcare_sd_der_blood_cells,', detail_form_alias) WHERE sample_type = 'buffy coat';

SET @sample_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE template_nodes
SET control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE  datamart_structure_id = @sample_datamart_structure_id 
AND control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood cell');
UPDATE template_nodes
SET control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE  datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood cell' AND aliquot_type = 'tube');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Clean up TreatmentExtend (Including the drug_id clean up)
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_extend_masters Master, ovcare_txe_hormonal_therapies Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, ovcare_txe_hormonal_therapies_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `ovcare_txe_hormonal_therapies` DROP FOREIGN KEY `FK_ovcare_txe_hormonal_therapies_drugs`;
ALTER TABLE ovcare_txe_hormonal_therapies DROP COLUMN drug_id;
ALTER TABLE ovcare_txe_hormonal_therapies_revs DROP COLUMN drug_id;

DELETE FROM  treatment_controls WHERE tx_method = 'procedure - biopsy' AND detail_tablename = 'ovcare_txd_biopsies' AND flag_active = 0;
DELETE FROM treatment_extend_controls WHERE detail_tablename = 'ovcare_txe_biopsies' AND flag_active = 0;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_txe_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='ovcare_txe_biopsies' AND `field`='procedure' AND `language_label`='procedure performed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_biopsy_procedure_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='ovcare_txe_biopsies' AND `field`='procedure' AND `language_label`='procedure performed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_biopsy_procedure_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='ovcare_txe_biopsies' AND `field`='procedure' AND `language_label`='procedure performed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_biopsy_procedure_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_txe_biopsies');
DELETE FROM structures WHERE alias='ovcare_txe_biopsies';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_txd_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='ovcare_txd_biopsies' AND `field`='path_num' AND `language_label`='pathology number' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_path_num' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='1' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='ovcare_txd_biopsies' AND `field`='path_num' AND `language_label`='pathology number' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_path_num' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='1' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='ovcare_txd_biopsies' AND `field`='path_num' AND `language_label`='pathology number' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_path_num' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='1' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_txd_biopsies');
DELETE FROM structures WHERE alias='ovcare_txd_biopsies';

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Order
-- ---------------------------------------------------------------------------------------------------------------------------------------

select 'At least one order line has been created. Please change core variable order_item_to_order_objetcs_link_setting' '### Order Line Error ###' from order_lines LIMIT 0,1;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Activate Participant Message
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages%';
SELECT 'Change users permissions to allow access to participant messages using the administartion tool.' as '### TODO After Migration ###';

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Activate Participant Contact
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Activate Participant Reproductive History
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories%';

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Add identifiers field to add participant form
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'ovcare_personal_health_number_identifier_value', 'input',  NULL , '1', '', '', '', 'personal health number', ''), 
('', '0', '', 'ovcare_bcca_number_identifier_value', 'input',  NULL , '1', '', '', '', 'bcca number', ''), 
('', '0', '', 'ovcare_medical_record_number_identifier_value', 'input',  NULL , '1', '', '', '', 'medical record number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_personal_health_number_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='personal health number' AND `language_tag`=''), '3', '30', 'misc identifiers', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_bcca_number_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcca number' AND `language_tag`=''), '3', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_medical_record_number_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medical record number' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Add study consent
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO consent_controls (controls_type, flag_active, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('study', '1', 'consent_masters_study', 'cd_nationals', 'study');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_consent_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 'notEmpty', '');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Annotation Study inclusion to clean up....
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'ovcare_autocomplete_event_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_autocomplete_event_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '11', '', '0', '1', 'study / project', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_autocomplete_event_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_autocomplete_event_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy'), 'notEmpty', '');
ALTER TABLE event_masters ADD COLUMN ovcare_study_summary_id INT(11) DEFAULT NULL;
ALTER TABLE event_masters_revs ADD COLUMN ovcare_study_summary_id INT(11) DEFAULT NULL;
ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_ovcare_event_masters_study` FOREIGN KEY (`ovcare_study_summary_id`) REFERENCES `study_summaries` (`id`);
UPDATE event_masters EM, ovcare_ed_study_inclusions ED
SET EM.ovcare_study_summary_id = ED.study_summary_id
WHERE EM.id = ED.event_master_id;
UPDATE event_masters_revs EM, ovcare_ed_study_inclusions ED
SET EM.ovcare_study_summary_id = ED.study_summary_id
WHERE EM.id = ED.event_master_id;
ALTER TABLE ovcare_ed_study_inclusions DROP COLUMN study_summary_id;
ALTER TABLE ovcare_ed_study_inclusions_revs DROP COLUMN study_summary_id;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id' AND `language_label`='study / project' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id' AND `language_label`='study / project' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id' AND `language_label`='study / project' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE event_controls SET event_type = 'study inclusion based on filemaker' WHERE event_group = 'study' AND event_type = 'study inclusion';
INSERT IGNORE INTO i18n (id,en, fr) 
VALUES 
('participants (based on file maker application)','Participants (based on FileMaker application)', ''),
('study inclusion based on filemaker','Study Inclusion (based on FileMaker application)', ''),
('no new data supposed to be recorded','No new data supposed to be recorded', '');

SET @id = (SELECT ID
FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `language_label`='study_title' AND `language_tag`='' AND `type`='input' AND `setting`='size=40' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1')
LIMIT 1,1);
DELETE FROM structure_formats WHERE id = @id;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Misc Identifier : Study #
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO misc_identifier_controls (misc_identifier_name,flag_active,flag_link_to_study) VALUES ('study number', '1', '1');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('study number', 'Study #', '');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Copy Collection
-- ---------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
('all (participant, consent, diagnosis and treatment/annotation)','All (Participant, Consent, Diagnosis and Treatment)','Tout (participant, Consentement, Diagnotic, Traitement)');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Collection Template
-- ---------------------------------------------------------------------------------------------------------------------------------------

-- Blood creation

INSERT INTO structures(`alias`) VALUES ('ovcare_blood_template_init_structure');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'ovcare_collected_tube_nbr_blood_edta', 'integer_positive',  NULL , '0', 'size=5', '', '', 'collected tubes nbr', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_blood_edta', 'float_positive',  NULL , '0', 'size=5', '', '', 'collected volume', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_unit_blood_edta', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') , '0', '', '', '', '', ''), 

('InventoryManagement', '0', '', 'ovcare_collected_tube_nbr_blood_serum', 'integer_positive',  NULL , '0', 'size=5', '', '', 'collected tubes nbr', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_blood_serum', 'float_positive',  NULL , '0', 'size=5', '', '', 'collected volume', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_unit_blood_serum', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') , '0', '', '', '', '', ''), 

('InventoryManagement', '0', '', 'ovcare_ischemia_time_mn_plasma_serum', 'integer_positive',  NULL , '0', 'size=5', '', '', 'ischemia time mn (plasma serum)', ''), 
('InventoryManagement', '0', '', 'ovcare_ischemia_time_mn_buffy_coat', 'integer_positive',  NULL , '0', 'size=5', '', '', 'ischemia time mn (buffy coat)', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supplier dept' AND `language_tag`=''), '1', '1', 'blood', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_reception_datetime_defintion' AND `language_label`='reception date' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='time_at_room_temp_mn_help' AND `language_label`='time at room temp (mn)' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_tube_nbr_blood_edta' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected tubes nbr' AND `language_tag`=''), '1', '10', 'edta', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_blood_edta' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_unit_blood_edta' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_tube_nbr_blood_serum' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected tubes nbr' AND `language_tag`=''), '1', '20', 'serum', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_blood_serum' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_unit_blood_serum' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`=''), '1', '50', 'derivatives', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_ischemia_time_mn_plasma_serum' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ischemia time mn (plasma serum)' AND `language_tag`=''), '1', '51', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_ischemia_time_mn_buffy_coat' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ischemia time mn (buffy coat)' AND `language_tag`=''), '1', '51', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET flag_addgrid = '0' WHERE structure_id = (SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure');

REPLACE INTO i18n (id, en, fr)
VALUES 
('edta', 'EDTA', 'EDTA');
INSERT INTO i18n (id, en, fr)
VALUES 
('ischemia time mn (plasma serum)', 'Ischemia Time mn (Plasma & Serum)', ''),
('ischemia time mn (buffy coat)', 'Ischemia Time mn (Buffy Coat)', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'ovcare_storage_datetime_plasma_serum', 'datetime',  NULL , '0', '', '', '', 'storage datetime (plasma serum)', ''), 
('InventoryManagement', '0', '', 'ovcare_storage_datetime_buffy_coat', 'datetime',  NULL , '0', '', '', '', 'storage datetime (buffy coat)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`=''), '1', '8010', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`=''), '1', '8011', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO i18n (id, en, fr)
VALUES 
('storage datetime (plasma serum)', 'Initial Storage Date (Plasma & Serum)', ''),
('storage datetime (buffy coat)', 'Initial Storage Date (Buffy Coat)', '');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_ischemia_time_mn_plasma_serum' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_ischemia_time_mn_buffy_coat' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'ovcare_creation_datetime_buffy_coat', 'datetime',  NULL , '0', '', '', '', 'creation datetime (buffy coat)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_creation_datetime_buffy_coat' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation datetime (buffy coat)' AND `language_tag`=''), '1', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('creation datetime (buffy coat)', 'Creation Datetime (Buffy Coat)', '');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_creation_datetime_buffy_coat' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Tissue creation

INSERT INTO structures(`alias`) VALUES ('ovcare_tissue_template_init_structure');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '1', '200', 'specimen data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_reception_datetime_defintion' AND `language_label`='reception date' AND `language_tag`=''), '1', '300', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='block type' AND `language_tag`=''), '1', '700', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- Add study to tempalte ini forms...

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '800', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '2', '800', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '800', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `language_heading`='aliquot'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('template_init_structure', 'ovcare_blood_template_init_structure', 'ovcare_tissue_template_init_structure')) 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Databrowser, etc...
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_3_name';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_5_name';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaBlock' AND label = 'create tma slide';

DELETE FROM datamart_structure_functions WHERE label = 'create lab id in batch';

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'EventMaster'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), '1', '1', 'study_summary_id');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6xxx' WHERE version_number = '2.6.8';


















-- ***************************************************************************************************************************************
Following sql statements are copied from custom_post_26x.sql script developped based on Yong's requests but never mirgated.
To test and review.
-- ***************************************************************************************************************************************f elements per participant');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Middle Name
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE participants SET middle_name = SUBSTRING(first_name, (LOCATE(' ',first_name) +1)), first_name = SUBSTRING(first_name, 1, (LOCATE(' ',first_name) - 1))
WHERE deleted <> 1 AND first_name REGEXP '^[\\.a-zA-Z0-9\-]+\ [\\.a-zA-Z0-9\-]+$';
UPDATE participants_revs SET middle_name = SUBSTRING(first_name, (LOCATE(' ',first_name) +1)), first_name = SUBSTRING(first_name, 1, (LOCATE(' ',first_name) - 1))
WHERE first_name REGEXP '^[\\.a-zA-Z0-9\-]+\ [\\.a-zA-Z0-9\-]+$';

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Path Review
-- -------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'ovary or endometrium path report', 1, 'ovcare_ed_ovary_endometrium_path_reports', 'ovcare_ed_path_reports', 0, 'ovary or endometrium path report', 0, 0, 1),
(null, '', 'clinical', 'other path report', 1, 'ovcare_ed_other_path_reports', 'ovcare_ed_path_reports', 0, 'other path report', 0, 0, 1);

CREATE TABLE IF NOT EXISTS `ovcare_ed_path_reports` (
  `diagnosis_report`char(1) DEFAULT 'n',
  `path_report_type` varchar(100) DEFAULT NULL,
  `pathologist` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `figo` varchar(10) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,  
  `histopathology` varchar(100) DEFAULT NULL,
  `ovarian_histology` varchar(100) DEFAULT NULL,
  `uterine_histology` varchar(100) DEFAULT NULL,
  `benign_lesions_precursor_presence` varchar(100) DEFAULT NULL,
  `fallopian_tube_lesions` varchar(100) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ovcare_ed_path_reports_revs` (
  `diagnosis_report`char(1) DEFAULT 'n',
  `path_report_type` varchar(100) DEFAULT NULL,
  `pathologist` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `figo` varchar(10) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,  
  `histopathology` varchar(100) DEFAULT NULL,
  `ovarian_histology` varchar(100) DEFAULT NULL,
  `uterine_histology` varchar(100) DEFAULT NULL,
  `benign_lesions_precursor_presence` varchar(100) DEFAULT NULL,
  `fallopian_tube_lesions` varchar(100) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=99 ;
ALTER TABLE `ovcare_ed_path_reports`
  ADD CONSTRAINT `ovcare_ed_path_reports_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
  
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_ovary_endometrium_path_reports');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'path_report_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type') , '0', '', '', '', 'path report type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'pathologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist_reviewed') , '0', '', '', '', 'pathologist', ''),
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') , '0', '', '', '', 'tumor grade', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') , '0', '', '', '', 'figo', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'ovarian_histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') , '0', '', '', '', 'ovarian', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'uterine_histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') , '0', '', '', '', 'uterine', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'histopathology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') , '0', '', '', '', 'general', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'benign_lesions_precursor_presence', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') , '0', '', '', '', 'presence of benign lesions precursor', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'fallopian_tube_lesions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') , '0', '', '', '', 'fallopian tube lesions', ''),
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'diagnosis_report', 'yes_no', NULL , '0', '', '', '', 'diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='path_report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path report type' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist_reviewed')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor grade' AND `language_tag`=''), '2', '25', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '2', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='ovarian_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovarian' AND `language_tag`=''), '2', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='uterine_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uterine' AND `language_tag`=''), '2', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='general' AND `language_tag`=''), '2', '59', 'histopathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='benign_lesions_precursor_presence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence of benign lesions precursor' AND `language_tag`=''), '2', '70', 'lesions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='fallopian_tube_lesions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube lesions' AND `language_tag`=''), '2', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `type`='yes_no' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('ovary or endometrium path report', 'Ovary/Endometrium Path Report', ''),
('other path report', 'Other Path Report', ''),
('path report type','Type', '');

INSERT INTO structures(`alias`) VALUES ('ovcare_ed_other_path_reports');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'tumour_grade', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') , '0', 'size=5', '', 'help_tumour grade', 'tumour grade', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'stage', 'input',  NULL , '0', 'size=5', '', '', 'stage', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'histopathology', 'input',  NULL , '0', 'size=30', '', '', 'histopathology', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='tumour_grade' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade')  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '2', '25', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='stage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='stage' AND `language_tag`=''), '2', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='histopathology' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='histopathology' AND `language_tag`=''), '2', '27', 'histopathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='path_report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path report type' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist_reviewed')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_value_domains SET domain_name = 'ovcare_path_report_type' WHERE domain_name = 'ovcare_path_review_type';
UPDATE structure_value_domains SET domain_name = 'ovcare_pathologist' WHERE domain_name = 'ovcare_pathologist_reviewed';
UPDATE structure_permissible_values_custom_controls SET name = 'Path Report Type', category = 'clinicalannotation - annotation' WHERE name = 'Path Review Type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Path Report Type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('Path Review Type')";
UPDATE structure_permissible_values_custom_controls SET category = 'clinicalannotation - annotation' WHERE name = 'Pathologist';

SET @dx_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'ovary or endometrium tumor');
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type = 'ovary or endometrium path report');

INSERT INTO event_masters (event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, created, created_by, modified, modified_by, deleted)
(SELECT @ev_control_id, participant_id, id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, created, created_by, modified, modified_by, deleted 
FROM diagnosis_masters DiagnosisMaster
INNER JOIN ovcare_dxd_ovaries_endometriums DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE diagnosis_control_id = @dx_control_id
AND ((ovcare_date_reviewed IS NOT NULL AND ovcare_date_reviewed NOT LIKE '')
 OR (ovcare_path_review_type IS NOT NULL AND ovcare_path_review_type NOT LIKE '')
 OR (ovcare_pathologist_reviewed IS NOT NULL AND ovcare_pathologist_reviewed NOT LIKE '')
 OR (tumour_grade IS NOT NULL AND tumour_grade NOT LIKE '')
 OR (figo IS NOT NULL AND figo NOT LIKE '')
 OR (histopathology IS NOT NULL AND histopathology NOT LIKE '')
 OR (ovarian_histology IS NOT NULL AND ovarian_histology NOT LIKE '')
 OR (uterine_histology IS NOT NULL AND uterine_histology NOT LIKE '')
 OR (benign_lesions_precursor_presence IS NOT NULL AND benign_lesions_precursor_presence NOT LIKE '')
 OR (fallopian_tube_lesions IS NOT NULL AND fallopian_tube_lesions NOT LIKE '')));

INSERT INTO ovcare_ed_path_reports (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions
FROM event_masters EventMaster 
INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.id = EventMaster.diagnosis_master_id
INNER JOIN ovcare_dxd_ovaries_endometriums DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE EventMaster.event_control_id = @ev_control_id AND DiagnosisMaster.diagnosis_control_id = @dx_control_id);

CREATE TABLE IF NOT EXISTS `ovcare_tmp_migration` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `ovcare_date_reviewed` date DEFAULT NULL,
  `ovcare_date_reviewed_accuracy` char(1) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_created` datetime NOT NULL,
  `ovcare_path_review_type` varchar(100) DEFAULT NULL,
  `ovcare_pathologist_reviewed` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `figo` varchar(10) DEFAULT NULL,
  `histopathology` varchar(100) DEFAULT NULL,
  `ovarian_histology` varchar(100) DEFAULT NULL,
  `uterine_histology` varchar(100) DEFAULT NULL,
  `benign_lesions_precursor_presence` varchar(100) DEFAULT NULL,
  `fallopian_tube_lesions` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

INSERT INTO ovcare_tmp_migration (
SELECT DISTINCT id, participant_id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, DiagnosisMaster.modified_by, DiagnosisMaster.version_created,
ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions, null
FROM diagnosis_masters_revs DiagnosisMaster
INNER JOIN ovcare_dxd_ovaries_endometriums_revs DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id AND DiagnosisMaster.version_created = DiagnosisDetail.version_created
WHERE DiagnosisMaster.id IN (SELECT diagnosis_master_id FROM event_masters WHERE event_control_id IN (@ev_control_id))
ORDER BY DiagnosisMaster.version_id ASC);

INSERT INTO event_masters_revs (id, event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, modified_by, version_created)
(SELECT EventMaster.id, @ev_control_id, TMP.participant_id, TMP.id, TMP.ovcare_date_reviewed, TMP.ovcare_date_reviewed_accuracy, TMP.modified_by, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id
WHERE EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

INSERT INTO ovcare_ed_path_reports_revs (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions, version_created)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id AND EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

DROP TABLE ovcare_tmp_migration;

SET @dx_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'other');
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type = 'other path report');

INSERT INTO event_masters (event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, created, created_by, modified, modified_by, deleted)
(SELECT @ev_control_id, participant_id, id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, created, created_by, modified, modified_by, deleted 
FROM diagnosis_masters DiagnosisMaster
INNER JOIN ovcare_dxd_others DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE diagnosis_control_id = @dx_control_id
AND ((ovcare_date_reviewed IS NOT NULL AND ovcare_date_reviewed NOT LIKE '')
 OR (ovcare_path_review_type IS NOT NULL AND ovcare_path_review_type NOT LIKE '')
 OR (ovcare_pathologist_reviewed IS NOT NULL AND ovcare_pathologist_reviewed NOT LIKE '')
 OR (tumour_grade IS NOT NULL AND tumour_grade NOT LIKE '')
 OR (stage IS NOT NULL AND stage NOT LIKE '')
 OR (histopathology IS NOT NULL AND histopathology NOT LIKE '')));

INSERT INTO ovcare_ed_path_reports (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, stage, histopathology)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, stage, histopathology
FROM event_masters EventMaster 
INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.id = EventMaster.diagnosis_master_id
INNER JOIN ovcare_dxd_others DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE EventMaster.event_control_id = @ev_control_id AND DiagnosisMaster.diagnosis_control_id = @dx_control_id);

CREATE TABLE IF NOT EXISTS `ovcare_tmp_migration` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `ovcare_date_reviewed` date DEFAULT NULL,
  `ovcare_date_reviewed_accuracy` char(1) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_created` datetime NOT NULL,
  `ovcare_path_review_type` varchar(100) DEFAULT NULL,
  `ovcare_pathologist_reviewed` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,
  `histopathology` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

INSERT INTO ovcare_tmp_migration (
SELECT DISTINCT id, participant_id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, DiagnosisMaster.modified_by, DiagnosisMaster.version_created,
ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, stage, histopathology, null
FROM diagnosis_masters_revs DiagnosisMaster
INNER JOIN ovcare_dxd_others_revs DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id AND DiagnosisMaster.version_created = DiagnosisDetail.version_created
WHERE DiagnosisMaster.id IN (SELECT diagnosis_master_id FROM event_masters WHERE event_control_id IN (@ev_control_id))
ORDER BY DiagnosisMaster.version_id ASC);

INSERT INTO event_masters_revs (id, event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, modified_by, version_created)
(SELECT EventMaster.id, @ev_control_id, TMP.participant_id, TMP.id, TMP.ovcare_date_reviewed, TMP.ovcare_date_reviewed_accuracy, TMP.modified_by, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id
WHERE EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

INSERT INTO ovcare_ed_path_reports_revs (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, stage, histopathology, version_created)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, stage, histopathology, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id AND EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

DROP TABLE ovcare_tmp_migration;

ALTER TABLE ovcare_dxd_others 
  DROP COLUMN stage, 
  DROP COLUMN histopathology;
ALTER TABLE ovcare_dxd_others_revs 
  DROP COLUMN stage, 
  DROP COLUMN histopathology;
ALTER TABLE ovcare_dxd_ovaries_endometriums 
  DROP COLUMN figo, 
  DROP COLUMN ovarian_histology, 
  DROP COLUMN uterine_histology, 
  DROP COLUMN histopathology, 
  DROP COLUMN benign_lesions_precursor_presence, 
  DROP COLUMN fallopian_tube_lesions;
ALTER TABLE ovcare_dxd_ovaries_endometriums_revs 
  DROP COLUMN figo, 
  DROP COLUMN ovarian_histology, 
  DROP COLUMN uterine_histology, 
  DROP COLUMN histopathology, 
  DROP COLUMN benign_lesions_precursor_presence, 
  DROP COLUMN fallopian_tube_lesions;
ALTER TABLE diagnosis_masters 
  DROP COLUMN ovcare_date_reviewed, 
  DROP COLUMN ovcare_date_reviewed_accuracy, 
  DROP COLUMN ovcare_path_review_type, 
  DROP COLUMN ovcare_pathologist_reviewed;
ALTER TABLE diagnosis_masters_revs 
  DROP COLUMN ovcare_date_reviewed, 
  DROP COLUMN ovcare_date_reviewed_accuracy, 
  DROP COLUMN ovcare_path_review_type, 
  DROP COLUMN ovcare_pathologist_reviewed;
UPDATE diagnosis_masters SET tumour_grade = '';
UPDATE diagnosis_masters_revs SET tumour_grade = '';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_path_review_type' AND `language_label`='path review type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_report_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_date_reviewed' AND `language_label`='date reviewed' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_pathologist_reviewed' AND `language_label`='pathologist reviewed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_date_reviewed' AND `language_label`='date reviewed' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_pathologist_reviewed' AND `language_label`='pathologist reviewed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_date_reviewed' AND `language_label`='date reviewed' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_pathologist_reviewed' AND `language_label`='pathologist reviewed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-88' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `language_help`='help_tumour grade' AND `validation_control`='open' AND `value_domain_control`='extend' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='stage' AND `language_label`='stage' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='stage' AND `language_label`='stage' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='stage' AND `language_label`='stage' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumor grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `language_label`='ovarian' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='uterine_histology' AND `language_label`='uterine' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `language_label`='general' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `language_label`='presence of benign lesions precursor' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `language_label`='fallopian tube lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumor grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `language_label`='ovarian' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='uterine_histology' AND `language_label`='uterine' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `language_label`='general' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `language_label`='presence of benign lesions precursor' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `language_label`='fallopian tube lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumor grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `language_label`='ovarian' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='uterine_histology' AND `language_label`='uterine' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `language_label`='general' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `language_label`='presence of benign lesions precursor' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `language_label`='fallopian tube lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('this type of path report can not be linked to this type of diagnosis', 'This type of path report can not be linked to this type of diagnosis!', ''),
('only one report can be flagged as diagnosis report per diagnosis', 'Only one report can be flagged as diagnosis report per diagnosis!', '');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- AliquotInternalUse.study_summary_id update
-- -------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'migration');

-- TFRI COEUR

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'TFRI COEUR');
UPDATE aliquot_internal_uses AliquotInternalUse
SET AliquotInternalUse.study_summary_id = @study_summary_id,
AliquotInternalUse.modified = @modified, 
AliquotInternalUse.modified_by = @modified_by
WHERE AliquotInternalUse.deleted <> 1 
AND (AliquotInternalUse.study_summary_id IS NULL OR AliquotInternalUse.study_summary_id LIKE '')
AND AliquotInternalUse.use_code = 'To Cecile LePage';

INSERT INTO aliquot_internal_uses_revs (id, aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration, duration_unit, used_by, study_summary_id, 
ovcare_tissue_section_thickness, ovcare_tissue_section_numbers, modified_by, version_created)
(SELECT id, aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration, duration_unit, used_by, study_summary_id, 
ovcare_tissue_section_thickness, ovcare_tissue_section_numbers, modified_by, modified FROM aliquot_internal_uses WHERE modified = @modified AND modified_by = @modified_by);


-- -------------------------------------------------------------------------------------------------------------------------------------
-- Tissue Section thickness
-- -------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_internal_uses CHANGE ovcare_tissue_section_thickness ovcare_tissue_section_thickness_um decimal(6,2) DEFAULT NULL;
ALTER TABLE aliquot_internal_uses_revs CHANGE ovcare_tissue_section_thickness ovcare_tissue_section_thickness_um decimal(6,2) DEFAULT NULL;
UPDATE structure_fields SET field = 'ovcare_tissue_section_thickness_um', language_label = 'section thickness (um)' WHERE field = 'ovcare_tissue_section_thickness';
INSERT INTO i18n (id,en,fr) VALUES ('section thickness (um)', 'Section Thickness (um)', '');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Cell Line
-- -------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE sd_der_cell_cultures ADD COLUMN ovcare_cell_line char(1) DEFAULT '';
ALTER TABLE sd_der_cell_cultures_revs ADD COLUMN ovcare_cell_line char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'ovcare_cell_line', 'yes_no',  NULL , '0', '', '', '', 'cell line', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='ovcare_cell_line' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cell line' AND `language_tag`=''), '1', '444', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('cell line', 'Cell Line', '');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_datetime_range_definition') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

INSERT INTO `datamart_reports` (`name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) VALUES
('ovcare cases received - monthly report', 'ovcare cases received description - monthly report', 'ovcare_cases_received_monthly_report', 'ovcare_cases_received_monthly_report_result', 'detail', 'ovcareCasesReceivedMonthlyReport', 1, NULL, 0),
('ovcare cases received - annual report', 'ovcare cases received description - annual report', 'ovcare_cases_received_annual_report', 'ovcare_cases_received_annual_report_result', 'detail', 'ovcareCasesReceivedAnnualReport', 1, NULL, 0);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('ovcare cases received - monthly report', 'OvCaRe - Cases Received Monthly Report', ''),
('ovcare cases received - annual report', 'OvCaRe - Cases Received Annual Report', ''),
('ovcare cases received description - monthly report',
'Count the number of patients (cases) with specimens collected during a specific year. The data will be detailed per month and specimen type. Results can also be split per study.', ''),
('ovcare cases received description - annual report',
'Count the number of patients (cases) with specimens collected during a specific year. The data will be detailed per year and specimen type. Results can also be split per study.', '');

INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_monthly_report');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_year_list", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("2000", "2000"),
("2020", "2020"),
("2019", "2019"),
("2018", "2018"),
("2017", "2017"),
("2016", "2016"),
("2015", "2015"),
("2014", "2014"),
("2013", "2013"),
("2012", "2012"),
("2011", "2011"),
("2010", "2010"),
("2009", "2009"),
("2008", "2008"),
("2007", "2007"),
("2006", "2006"),
("2005", "2005"),
("2004", "2004"),
("2003", "2003"),
("2002", "2002"),
("2001", "2001"),
("2000", "2000"),
("1999", "1999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2020" AND language_alias="2020"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2019" AND language_alias="2019"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2018" AND language_alias="2018"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2017" AND language_alias="2017"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2016" AND language_alias="2016"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2015" AND language_alias="2015"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2014" AND language_alias="2014"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2013" AND language_alias="2013"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2012" AND language_alias="2012"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2011" AND language_alias="2011"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2010" AND language_alias="2010"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2009" AND language_alias="2009"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2008" AND language_alias="2008"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2007" AND language_alias="2007"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2006" AND language_alias="2006"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2005" AND language_alias="2005"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2004" AND language_alias="2004"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2003" AND language_alias="2003"), "18", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2002" AND language_alias="2002"), "19", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2001" AND language_alias="2001"), "20", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2000" AND language_alias="2000"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="1999" AND language_alias="1999"), "22", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Datamart', '0', '', 'year', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_year_list') , '0', '', '', '', 'year', ''),
('Datamart', '0', '', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='year' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_year_list')), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('only one year can be selected','Only one year can be selected'),
('please select the year of this report','Please select the year of this report!', '');
INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_monthly_report_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Datamart', '0', '', 'ovcare_month_1', 'input',  NULL , '0', '', '', '', 'jan', ''),
('Datamart', '0', '', 'ovcare_month_2', 'input',  NULL , '0', '', '', '', 'feb', ''),
('Datamart', '0', '', 'ovcare_month_3', 'input',  NULL , '0', '', '', '', 'mar', ''),
('Datamart', '0', '', 'ovcare_month_4', 'input',  NULL , '0', '', '', '', 'apr', ''),
('Datamart', '0', '', 'ovcare_month_5', 'input',  NULL , '0', '', '', '', 'may', ''),
('Datamart', '0', '', 'ovcare_month_6', 'input',  NULL , '0', '', '', '', 'jun', ''),
('Datamart', '0', '', 'ovcare_month_7', 'input',  NULL , '0', '', '', '', 'jul', ''),
('Datamart', '0', '', 'ovcare_month_8', 'input',  NULL , '0', '', '', '', 'aug', ''),
('Datamart', '0', '', 'ovcare_month_9', 'input',  NULL , '0', '', '', '', 'sep', ''),
('Datamart', '0', '', 'ovcare_month_10', 'input',  NULL , '0', '', '', '', 'oct', ''),
('Datamart', '0', '', 'ovcare_month_11', 'input',  NULL , '0', '', '', '', 'nov', ''),
('Datamart', '0', '', 'ovcare_month_12', 'input',  NULL , '0', '', '', '', 'dec', ''),
('Datamart', '0', '', 'ovcare_total', 'input',  NULL , '0', '', '', '', 'total', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_1'), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_2'), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_3'), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_4'), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_5'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_6'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_7'), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_8'), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_9'), '1', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_10'), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_11'), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_12'), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_total'), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_annual_report');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_annual_report_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Datamart', '0', '', 'ovcare_year_2020', 'input',  NULL , '0', '', '', '', '2020', ''),
('Datamart', '0', '', 'ovcare_year_2019', 'input',  NULL , '0', '', '', '', '2019', ''),
('Datamart', '0', '', 'ovcare_year_2018', 'input',  NULL , '0', '', '', '', '2018', ''),
('Datamart', '0', '', 'ovcare_year_2017', 'input',  NULL , '0', '', '', '', '2017', ''),
('Datamart', '0', '', 'ovcare_year_2016', 'input',  NULL , '0', '', '', '', '2016', ''),
('Datamart', '0', '', 'ovcare_year_2015', 'input',  NULL , '0', '', '', '', '2015', ''),
('Datamart', '0', '', 'ovcare_year_2014', 'input',  NULL , '0', '', '', '', '2014', ''),
('Datamart', '0', '', 'ovcare_year_2013', 'input',  NULL , '0', '', '', '', '2013', ''),
('Datamart', '0', '', 'ovcare_year_2012', 'input',  NULL , '0', '', '', '', '2012', ''),
('Datamart', '0', '', 'ovcare_year_2011', 'input',  NULL , '0', '', '', '', '2011', ''),
('Datamart', '0', '', 'ovcare_year_2010', 'input',  NULL , '0', '', '', '', '2010', ''),
('Datamart', '0', '', 'ovcare_year_2009', 'input',  NULL , '0', '', '', '', '2009', ''),
('Datamart', '0', '', 'ovcare_year_2008', 'input',  NULL , '0', '', '', '', '2008', ''),
('Datamart', '0', '', 'ovcare_year_2007', 'input',  NULL , '0', '', '', '', '2007', ''),
('Datamart', '0', '', 'ovcare_year_2006', 'input',  NULL , '0', '', '', '', '2006', ''),
('Datamart', '0', '', 'ovcare_year_2005', 'input',  NULL , '0', '', '', '', '2005', ''),
('Datamart', '0', '', 'ovcare_year_2004', 'input',  NULL , '0', '', '', '', '2004', ''),
('Datamart', '0', '', 'ovcare_year_2003', 'input',  NULL , '0', '', '', '', '2003', ''),
('Datamart', '0', '', 'ovcare_year_2002', 'input',  NULL , '0', '', '', '', '2002', ''),
('Datamart', '0', '', 'ovcare_year_2001', 'input',  NULL , '0', '', '', '', '2001', ''),
('Datamart', '0', '', 'ovcare_year_2000', 'input',  NULL , '0', '', '', '', '2000', ''),
('Datamart', '0', '', 'ovcare_year_other', 'input',  NULL , '0', '', '', '', 'other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2020'), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2019'), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2018'), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2017'), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2016'), '1', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2015'), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2014'), '1', '16', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2013'), '1', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2012'), '1', '18', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2011'), '1', '19', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2010'), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2009'), '1', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2008'), '1', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2007'), '1', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2006'), '1', '24', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2005'), '1', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2004'), '1', '26', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2003'), '1', '27', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2002'), '1', '28', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2001'), '1', '29', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2000'), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_other'), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_total'), '1', '40', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis Creation In Batch
-- -------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('ovcare_diagnosis_details_file');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FunctionManagement', '', 'ovcare_diagnosis_details_file', 'file',  NULL , '0', '', '', '', 'file', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_diagnosis_details_file'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_diagnosis_details_file' AND `type`='file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='file' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_diagnosis_details_file'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_separator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- diagnosismasters
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '10', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0');
-- dx_primary
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site') AND `flag_confidential`='0');
-- ovcare_dx_ovaries_endometriums
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='censor' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='progression_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_dx_progression_status') AND `flag_confidential`='0');
-- ovcare_ed_ovary_endometrium_path_reports_for_batch_creation
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_ovary_endometrium_path_reports_for_batch_creation');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '3', '-2', 'path report', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '3', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='path_report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_report_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path report type' AND `language_tag`=''), '3', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '3', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor grade' AND `language_tag`=''), '4', '25', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '4', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='ovarian_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovarian' AND `language_tag`=''), '4', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='uterine_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uterine' AND `language_tag`=''), '4', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='general' AND `language_tag`=''), '4', '59', 'histopathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='benign_lesions_precursor_presence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence of benign lesions precursor' AND `language_tag`=''), '4', '70', 'lesions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='fallopian_tube_lesions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube lesions' AND `language_tag`=''), '4', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '3', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='rows=3,cols=30' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FunctionManagement', '', 'ovcare_participant_voa', 'input',  NULL , '0', 'size=5', '', '', 'VOA#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_participant_voa' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='VOA#' AND `language_tag`=''), '0', '-10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_participant_voa' ), 'notEmpty', '');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='path report date' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en)
VALUES
('wrong csv file format - check csv separator or the list of missing fields', 'Wrong csv file format, check CSV separator or the list of missing fields', ''),
('wrong csv file format - check csv separator or the list of unsupported fields','Wrong csv file format - check csv separator or the list of unsupported fields', ''),
('wrong csv file format - check csv separator', 'Wrong csv file format, check CSV separator', ''),
('no file has been selected','No file has been selected', ''),
('created %dx% diagnosis and %pr% path reports','Created %dx% diagnosis and %pr% path reports', ''),
('voa# unknown','VOA# unknown', ''),
('2 voa# are assigned to the same patient','2 VOA# are assigned to the same patient', ''),
('either ovary or endometrium tumor site should be selected', 'Either ovary or endometrium tumor site should be selected.', ''),
('diagnosis creation in batch','Diagnosis Creation in Batch', ''),
('file', 'File', ''),
('skip', 'Skip', ''),
('path report date', 'Path Report Date', ''),
('value [%s] is not value supported', 'Value [%s] is not a value supported', ''),
('create dx in batch', 'Create Diagnosis In Batch', '');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- New Request - 2015-02
-- -------------------------------------------------------------------------------------------------------------------------------------

-- path_report.diagnosis_report yes/no

ALTER TABLE ovcare_ed_path_reports DROP COLUMN diagnosis_report;
ALTER TABLE ovcare_ed_path_reports_revs DROP COLUMN diagnosis_report;
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report');
DELETE FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report';

-- Path review code hidden

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id'), 'notEmpty', '');
UPDATE specimen_review_masters SET notes = CONCAT(review_code, ' ', notes) WHERE notes IS NOT NULL AND review_code IS NOT NULL AND review_code NOT LIKE '';
UPDATE specimen_review_masters SET notes = review_code WHERE notes IS NULL AND review_code IS NOT NULL AND review_code NOT LIKE '';
UPDATE aliquot_review_masters, ovcare_ar_tissue_blocks SET notes = CONCAT(review_code, ' ', notes) WHERE notes IS NOT NULL AND review_code IS NOT NULL AND review_code NOT LIKE '' AND review_code NOT LIKE 'n/a' AND aliquot_review_master_id = id;
UPDATE aliquot_review_masters, ovcare_ar_tissue_blocks SET notes = review_code WHERE notes IS NULL AND review_code IS NOT NULL AND review_code NOT LIKE '' AND review_code NOT LIKE 'n/a' AND aliquot_review_master_id = id;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ar_tissue_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Order Check

select count(*) AS 'Nbr of orders (should be equal to 0 - We remove order line level)' from orders;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;

-- ***************************************************************************************************************************************
-- ../custom_post_267.sql
-- ***************************************************************************************************************************************


-- -------------------------------------------------------------------------------------------------------------------------------------
-- Participant Subject Type
-- -------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants ADD COLUMN ovcare_subject_type VARCHAR(30) DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN ovcare_subject_type VARCHAR(30) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_subject_types", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("cancer/tumour", "cancer/tumour"), ('normal control', 'normal control');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_subject_types"), (SELECT id FROM structure_permissible_values WHERE value="cancer/tumour" AND language_alias="cancer/tumour"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_subject_types"), (SELECT id FROM structure_permissible_values WHERE value="normal control" AND language_alias="normal control"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'ovcare_subject_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_subject_types') , '0', '', '', '', 'subject type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ovcare_subject_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_subject_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='subject type' AND `language_tag`=''), '1', '98', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('cancer/tumour','Cancer/Tumour'),('normal control','Normal Control'),('subject type','Subject Type', '');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- COLLECTION/ALIQUOT STUDY CLEAN-UP
-- -------------------------------------------------------------------------------------------------------------------------------------
-- Rules:
--   A- Add voa#s to 'Annotation>Study' records based on FileMakerPro app
--   B- Create field collection study
--   C- Add TFRI-COEUR study to aliquot record when the aliquot internal use study is equal to TFRI-COEUR 
--          + check at least one aliquot is flagged as TFRI-COEUR when a 'Annotation>Study' of the particiapnt is equal to TFRI-COEUR 
--          + check no aliquot is linked to another study when an aliquot internal use study is equal to TFRI-COEUR 
--   D- Check at least one tissue sample is flagged as 'Cell Culture Collected' when the a 'Annotation>Study' record of the participant
--          equals to 'Cell Culture'
--   E- Check at least one tissue sample is flagged as 'Xenograft Collected' when the a 'Annotation>Study' record of the participant
--          equals to 'Xenograft'
--   F- Set Collection study based on FileMakerPro data
--         1- Set collection study based on FileMakerPro data when only one study (different than 'Cell Culture', 'Xenograft', 'TFRI COEUR')
--            is linked to a collection voa# in FileMakerPro and the link voa# to study exists into ATiM (participant 'Annotation>Study' to 
--            participant collection voa#)
--         2- Set collection study to 'Endometriosis' based on FileMakerPro data when the collection voa# is linked to a study equal to 'Endometriosis' 
-- 			  and no study equal to 'Intratumoural Heterogenity', 'ITH-Ovary' or 'ITH-Endometrium' in FileMakerPro app 
-- 			  and all links between voa# and study exists into ATiM (participant 'Annotation>Study' to participant collection voa#).
--         3- Set collection study to 'Intratumoural Heterogenity' based on FileMakerPro data when the collection voa# is linked to a study equal to 'Intratumoural Heterogenity' 
-- 			  and no study equal to 'Endometriosis', 'ITH-Ovary' or 'ITH-Endometrium' in FileMakerPro app 
-- 			  and all links between voa# and study exists into ATiM (participant 'Annotation>Study' to participant collection voa#).
--         4- Set collection study to 'ITH-Ovary' based on FileMakerPro data when the collection voa# is linked to a study equal to 'ITH-Ovary' 
-- 			  and no study equal to 'Endometriosis' or 'ITH-Endometrium' in FileMakerPro app 
-- 			  and all links between voa# and study exists into ATiM (participant 'Annotation>Study' to participant collection voa#).
--         5- Set collection study to 'ITH-Endometrium' based on FileMakerPro data when the collection voa# is linked to a study equal to 'ITH-Endometrium' 
-- 			  and no study equal to 'Endometriosis' or 'ITH-Ovary' in FileMakerPro app 
-- 			  and all links between voa# and study exists into ATiM (participant 'Annotation>Study' to participant collection voa#).			  
--   G- Set the study of any tissue collections having no study defined by the previous rules (see above) and linked to a participant 
--      having only one tissue collection based on following sub-rules
--         1- Set tissue collection study to the 'Annotation>Study' when only one participant 'Annotation>Study' 
--            (different than 'Cell Culture', 'Xenograft', 'TFRI COEUR') exists in ATiM 
--         2- Set tissue collection study to the 'Annotation>Study' 'Endometriosis' when a participant 'Annotation>Study' is equal to 'Endometriosis' 
-- 			  and no participant 'Annotation>Study' is equal to 'Intratumoural Heterogenity', 'ITH-Ovary' or 'ITH-Endometrium' in ATiM 
--         3- Set tissue collection study to the 'Annotation>Study' 'Intratumoural Heterogenity' when a participant 'Annotation>Study' is equal to 'Intratumoural Heterogenity' 
-- 			  and no participant 'Annotation>Study' is equal to 'Endometriosis', 'ITH-Ovary' or 'ITH-Endometrium' in ATiM 
--         4- Set tissue collection study to the 'Annotation>Study' 'ITH-Ovary' when a participant 'Annotation>Study' is equal to 'ITH-Ovary' 
-- 			  and no participant 'Annotation>Study' is equal to 'Endometriosis' or 'ITH-Endometrium' in ATiM 
--         5- Set tissue collection study to the 'Annotation>Study' 'ITH-Endometrium' when a participant 'Annotation>Study' is equal to 'ITH-Endometrium' 
-- 			  and no participant 'Annotation>Study' is equal to 'Endometriosis' or 'ITH-Ovary' in ATiM
-- -------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'migration');

-- Load VOA number to studies from FileMakerPro app

DROP TABLE IF EXISTS ovcare_tmp_voa_to_study_file_maker_data;
CREATE TABLE ovcare_tmp_voa_to_study_file_maker_data (
  voa varchar(10) DEFAULT NULL,
  study_title varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ovcare_tmp_voa_to_study_file_maker_data` (`voa`, `study_title`) VALUES
('4217', 'fimbrial scraping for culture'),
('3986', 'ith-endometrium'),
('3986', 'intratumoural heterogenity'),
('3988', 'endometriosis'),
('3991', 'ith-ovary'),
('3991', 'intratumoural heterogenity'),
('4301', 'cell culture'),
('4301', 'xenograft'),
('4301', 'ith-ovary'),
('4301', 'intratumoural heterogenity'),
('4304', 'ith-ovary'),
('4304', 'intratumoural heterogenity'),
('4311', 'ith-endometrium'),
('4311', 'intratumoural heterogenity'),
('4309', 'ith-ovary'),
('4309', 'intratumoural heterogenity'),
('4307', 'endometriosis'),
('4312', 'ith-ovary'),
('4402', 'cell culture'),
('4315', 'endometriosis'),
('4322', 'endometriosis'),
('4320', 'ith-endometrium'),
('4320', 'intratumoural heterogenity'),
('4319', 'ith-endometrium'),
('4319', 'intratumoural heterogenity'),
('4318', 'ith-endometrium'),
('4318', 'intratumoural heterogenity'),
('4334', 'ith-endometrium'),
('4334', 'intratumoural heterogenity'),
('4331', 'ith-ovary'),
('4331', 'intratumoural heterogenity'),
('4330', 'ith-ovary'),
('4330', 'intratumoural heterogenity'),
('4329', 'xenograft'),
('4329', 'ith-ovary'),
('4329', 'intratumoural heterogenity'),
('4328', 'ith-ovary'),
('4328', 'intratumoural heterogenity'),
('4342', 'ith-endometrium'),
('4342', 'intratumoural heterogenity'),
('4338', 'ith-ovary'),
('4338', 'intratumoural heterogenity'),
('4337', 'ith-endometrium'),
('4337', 'intratumoural heterogenity'),
('4335', 'ith-endometrium'),
('4335', 'intratumoural heterogenity'),
('4504', 'cell culture'),
('4348', 'ith-endometrium'),
('4348', 'intratumoural heterogenity'),
('4520', 'cell culture'),
('4529', 'cell culture'),
('4352', 'xenograft'),
('4546', 'cell culture'),
('4353', 'xenograft'),
('4353', 'intratumoural heterogenity'),
('4353', 'ith-endometrium'),
('4355', 'xenograft'),
('4580', 'cell culture'),
('4361', 'ith-ovary'),
('4361', 'intratumoural heterogenity'),
('4359', 'intratumoural heterogenity'),
('4359', 'ith-ovary'),
('4358', 'intratumoural heterogenity'),
('4358', 'ith-ovary'),
('4357', 'intratumoural heterogenity'),
('4357', 'ith-ovary'),
('4356', 'ith-ovary'),
('4356', 'intratumoural heterogenity'),
('4362', 'xenograft'),
('4362', 'intratumoural heterogenity'),
('4362', 'ith-ovary'),
('4366', 'ith-endometrium'),
('4366', 'intratumoural heterogenity'),
('4365', 'ith-endometrium'),
('4365', 'intratumoural heterogenity'),
('4364', 'intratumoural heterogenity'),
('4364', 'ith-ovary'),
('4370', 'xenograft'),
('4377', 'ith-endometrium'),
('4377', 'intratumoural heterogenity'),
('4374', 'intratumoural heterogenity'),
('4374', 'ith-ovary'),
('4374', 'xenograft'),
('4373', 'ith-endometrium'),
('4373', 'intratumoural heterogenity'),
('4380', 'intratumoural heterogenity'),
('4380', 'ith-endometrium'),
('4378', 'endometriosis'),
('4389', 'intratumoural heterogenity'),
('4389', 'ith-ovary'),
('4388', 'ith-ovary'),
('4388', 'intratumoural heterogenity'),
('4388', 'xenograft'),
('4386', 'endometriosis'),
('4391', 'intratumoural heterogenity'),
('4391', 'ith-endometrium'),
('4391', 'xenograft'),
('4701', 'intratumoural heterogenity'),
('4701', 'ith-endometrium'),
('4398', 'endometriosis'),
('4397', 'intratumoural heterogenity'),
('4397', 'ith-endometrium'),
('4396', 'endometriosis'),
('4395', 'xenograft'),
('4705', 'endometriosis'),
('4704', 'ith-ovary'),
('4704', 'intratumoural heterogenity'),
('4703', 'intratumoural heterogenity'),
('4703', 'ith-endometrium'),
('4711', 'intratumoural heterogenity'),
('4711', 'ith-endometrium'),
('4723', 'ith-ovary'),
('4723', 'intratumoural heterogenity'),
('4720', 'ith-endometrium'),
('4720', 'intratumoural heterogenity'),
('4719', 'ith-endometrium'),
('4719', 'intratumoural heterogenity'),
('4718', 'intratumoural heterogenity'),
('4718', 'ith-endometrium'),
('4730', 'intratumoural heterogenity'),
('4730', 'ith-ovary'),
('4726', 'intratumoural heterogenity'),
('4726', 'ith-endometrium'),
('4724', 'ith-ovary'),
('4724', 'intratumoural heterogenity'),
('4733', 'xenograft'),
('4732', 'intratumoural heterogenity'),
('4732', 'ith-endometrium'),
('4731', 'intratumoural heterogenity'),
('4731', 'ith-ovary'),
('4737', 'intratumoural heterogenity'),
('4737', 'ith-ovary'),
('4736', 'intratumoural heterogenity'),
('4736', 'ith-endometrium'),
('4734', 'intratumoural heterogenity'),
('4734', 'ith-endometrium'),
('2037', 'intratumoural heterogenity'),
('2037', 'ith-ovary'),
('2652', 'cell culture'),
('2724', 'cell culture'),
('2019', 'cell culture'),
('1267', 'tfri couer'),
('1267', 'xenograft'),
('2318', 'cell culture'),
('2375', 'cell culture'),
('2560', 'cell culture'),
('2913', 'cell culture'),
('3406', 'cell culture'),
('2017', 'tfri couer'),
('4052', 'tfri couer'),
('2008', 'cell culture'),
('2006', 'ovarian cancer diagnosis'),
('2005', 'cell culture'),
('2865', 'pi3k'),
('2888', 'pi3k'),
('2925', 'pi3k'),
('2954', 'pi3k'),
('3127', 'pi3k'),
('3192', 'pi3k'),
('3383', 'pi3k'),
('3561', 'pi3k'),
('3718', 'pi3k'),
('321', 'tfri couer'),
('77', 'tfri couer'),
('77', 'ith-ovary'),
('77', 'intratumoural heterogenity'),
('109', 'tfri couer'),
('109', 'tcga'),
('109', 'ith-ovary'),
('109', 'intratumoural heterogenity'),
('446', 'intratumoural heterogenity'),
('446', 'tfri couer'),
('446', 'ith-ovary'),
('113', 'tfri couer'),
('113', 'ith-ovary'),
('113', 'intratumoural heterogenity'),
('149', 'tfri couer'),
('163', 'tfri couer'),
('163', 'ith-ovary'),
('163', 'intratumoural heterogenity'),
('1514', 'ith-ovary'),
('1514', 'intratumoural heterogenity'),
('3964', 'xenograft'),
('695', 'tfri couer'),
('372', 'tfri couer'),
('372', 'ith-ovary'),
('372', 'intratumoural heterogenity'),
('2944', 'cell culture'),
('376', 'tfri couer'),
('376', 'ith-ovary'),
('376', 'intratumoural heterogenity'),
('1572', 'intratumoural heterogenity'),
('1572', 'ith-ovary'),
('1572', 'tfri couer'),
('427', 'tfri couer'),
('4065', 'tfri couer'),
('461', 'tfri couer'),
('480', 'tcga'),
('480', 'tfri couer'),
('486', 'ith-ovary'),
('486', 'intratumoural heterogenity'),
('488', 'tfri couer'),
('536', 'tcga'),
('536', 'tfri couer'),
('536', 'xenograft'),
('556', 'tcga'),
('556', 'tfri couer'),
('562', 'tcga'),
('562', 'tfri couer'),
('562', 'ith-ovary'),
('562', 'intratumoural heterogenity'),
('1320', 'cell culture'),
('716', 'tfri couer'),
('763', 'tcga'),
('763', 'tfri couer'),
('763', 'ith-ovary'),
('763', 'intratumoural heterogenity'),
('785', 'tfri couer'),
('1557', 'tfri couer'),
('796', 'xenograft'),
('901', 'tfri couer'),
('901', 'ith-ovary'),
('901', 'intratumoural heterogenity'),
('954', 'tfri couer'),
('1407', 'cell culture'),
('975', 'tcga'),
('975', 'xenograft'),
('1048', 'tfri couer'),
('1048', 'ith-ovary'),
('1048', 'xenograft'),
('1048', 'cell culture'),
('1048', 'intratumoural heterogenity'),
('1092', 'tfri couer'),
('1092', 'ith-ovary'),
('1092', 'intratumoural heterogenity'),
('1101', 'tcga'),
('1101', 'tfri couer'),
('1112', 'cell culture'),
('1121', 'fimbrial scraping for culture'),
('1121', 'cell culture'),
('1127', 'cell culture'),
('4069', 'cell culture'),
('1130', 'xenograft'),
('1130', 'cell culture'),
('1130', 'tcga'),
('1130', 'tfri couer'),
('1130', 'ith-ovary'),
('1130', 'intratumoural heterogenity'),
('1934', 'intratumoural heterogenity'),
('1934', 'ith-ovary'),
('1170', 'cell culture'),
('1170', 'ith-ovary'),
('1170', 'intratumoural heterogenity'),
('1180', 'tfri couer'),
('1194', 'precursor to prevention (tics)'),
('1210', 'tfri couer'),
('1210', 'ith-ovary'),
('1210', 'cell culture'),
('1210', 'intratumoural heterogenity'),
('1217', 'cell culture'),
('1217', 'intratumoural heterogenity'),
('1217', 'tfri couer'),
('1217', 'ith-ovary'),
('3399', 'cell culture'),
('1245', 'precursor to prevention (tics)'),
('1305', 'precursor to prevention (tics)'),
('1324', 'tfri couer'),
('1324', 'ith-ovary'),
('1324', 'intratumoural heterogenity'),
('1324', 'precursor to prevention (tics)'),
('1336', 'tfri couer'),
('1367', 'ith-ovary'),
('1367', 'intratumoural heterogenity'),
('1371', 'ith-ovary'),
('1371', 'intratumoural heterogenity'),
('1377', 'precursor to prevention (tics)'),
('1378', 'tfri couer'),
('1387', 'tfri couer'),
('1415', 'precursor to prevention (tics)'),
('1418', 'tcga'),
('1427', 'precursor to prevention (tics)'),
('2900', 'cell culture'),
('1469', 'tfri couer'),
('1478', 'ith-ovary'),
('1478', 'intratumoural heterogenity'),
('1481', 'ith-endometrium'),
('1481', 'intratumoural heterogenity'),
('1487', 'ith-ovary'),
('1487', 'intratumoural heterogenity'),
('1487', 'tfri couer'),
('1584', 'cell culture'),
('1584', 'tfri couer'),
('1587', 'cell culture'),
('1587', 'ith-ovary'),
('1587', 'intratumoural heterogenity'),
('1587', 'tfri couer'),
('1603', 'xenograft'),
('1625', 'intratumoural heterogenity'),
('1625', 'ith-ovary'),
('2036', 'cell culture'),
('1630', 'intratumoural heterogenity'),
('1630', 'cell culture'),
('1630', 'xenograft'),
('1630', 'ith-ovary'),
('1630', 'tfri couer'),
('1672', 'intratumoural heterogenity'),
('1672', 'ith-ovary'),
('4292', 'cell culture'),
('1675', 'intratumoural heterogenity'),
('1675', 'ith-ovary'),
('1675', 'xenograft'),
('1709', 'intratumoural heterogenity'),
('1709', 'ovarian cancer diagnosis'),
('1709', 'ith-ovary'),
('1720', 'ovarian cancer diagnosis'),
('1720', 'xenograft'),
('1720', 'intratumoural heterogenity'),
('1720', 'ith-ovary'),
('1730', 'intratumoural heterogenity'),
('1730', 'ith-ovary'),
('1759', 'tfri couer'),
('1782', 'ovarian cancer diagnosis'),
('1782', 'intratumoural heterogenity'),
('1782', 'ith-ovary'),
('1782', 'tfri couer'),
('1793', 'fimbrial scraping for culture'),
('1793', 'xenograft'),
('1793', 'ith-ovary'),
('1793', 'intratumoural heterogenity'),
('2458', 'intratumoural heterogenity'),
('2458', 'ith-endometrium'),
('3130', 'cell culture'),
('3370', 'cell culture'),
('1858', 'intratumoural heterogenity'),
('1863', 'intratumoural heterogenity'),
('1906', 'cell culture'),
('1909', 'ith-ovary'),
('1909', 'intratumoural heterogenity'),
('1909', 'tfri couer'),
('1920', 'ovarian cancer diagnosis'),
('1920', 'precursor to prevention (tics)'),
('1920', 'intratumoural heterogenity'),
('1920', 'ith-ovary'),
('1931', 'ovarian cancer diagnosis'),
('1931', 'ith-ovary'),
('1931', 'intratumoural heterogenity'),
('1946', 'endometriosis'),
('2833', 'endometriosis'),
('1982', 'tfri couer'),
('1996', 'cell culture'),
('2026', 'tfri couer'),
('2054', 'endometriosis'),
('1802', 'intratumoural heterogenity'),
('1802', 'ith-ovary'),
('1802', 'tfri couer'),
('3946', 'xenograft'),
('2722', 'cell culture'),
('2988', 'cell culture'),
('2138', 'ith-ovary'),
('2138', 'cell culture'),
('2138', 'intratumoural heterogenity'),
('2071', 'precursor to prevention (tics)'),
('2199', 'ith-endometrium'),
('2199', 'intratumoural heterogenity'),
('2217', 'ith-ovary'),
('2217', 'intratumoural heterogenity'),
('2221', 'ith-endometrium'),
('2221', 'intratumoural heterogenity'),
('2225', 'tfri couer'),
('2212', 'ith-endometrium'),
('2212', 'intratumoural heterogenity'),
('2218', 'ith-endometrium'),
('2218', 'intratumoural heterogenity'),
('2237', 'ith-ovary'),
('2237', 'intratumoural heterogenity'),
('2236', 'fimbrial scraping for culture'),
('2224', 'ith-endometrium'),
('2224', 'intratumoural heterogenity'),
('2246', 'cell culture'),
('2246', 'ith-ovary'),
('2246', 'intratumoural heterogenity'),
('2238', 'tfri couer'),
('2251', 'fimbrial scraping for culture'),
('2235', 'ith-endometrium'),
('2235', 'intratumoural heterogenity'),
('2260', 'fimbrial scraping for culture'),
('2268', 'ith-endometrium'),
('2268', 'intratumoural heterogenity'),
('2273', 'intratumoural heterogenity'),
('2273', 'ith-endometrium'),
('2261', 'cell culture'),
('2267', 'intratumoural heterogenity'),
('2267', 'ith-ovary'),
('2266', 'ith-ovary'),
('2266', 'intratumoural heterogenity'),
('2274', 'intratumoural heterogenity'),
('2274', 'ith-endometrium'),
('2280', 'intratumoural heterogenity'),
('2280', 'ith-endometrium'),
('2275', 'intratumoural heterogenity'),
('2275', 'ith-endometrium'),
('2292', 'intratumoural heterogenity'),
('2292', 'ith-endometrium'),
('2283', 'intratumoural heterogenity'),
('2283', 'ith-endometrium'),
('2404', 'intratumoural heterogenity'),
('2404', 'ith-endometrium'),
('2590', 'cell culture'),
('2284', 'intratumoural heterogenity'),
('2284', 'ith-ovary'),
('2409', 'intratumoural heterogenity'),
('2409', 'ith-endometrium'),
('2401', 'intratumoural heterogenity'),
('2401', 'ith-endometrium'),
('2293', 'intratumoural heterogenity'),
('2293', 'ith-ovary'),
('2419', 'intratumoural heterogenity'),
('2419', 'ith-endometrium'),
('2416', 'intratumoural heterogenity'),
('2416', 'ith-endometrium'),
('2406', 'intratumoural heterogenity'),
('2406', 'ith-endometrium'),
('2405', 'intratumoural heterogenity'),
('2405', 'ith-endometrium'),
('2433', 'intratumoural heterogenity'),
('2433', 'ith-endometrium'),
('2422', 'intratumoural heterogenity'),
('2422', 'ith-endometrium'),
('2423', 'intratumoural heterogenity'),
('2423', 'ith-endometrium'),
('2454', 'intratumoural heterogenity'),
('2454', 'ith-endometrium'),
('2453', 'intratumoural heterogenity'),
('2453', 'ith-endometrium'),
('2429', 'intratumoural heterogenity'),
('2429', 'ith-ovary'),
('2426', 'intratumoural heterogenity'),
('2426', 'ith-endometrium'),
('2464', 'intratumoural heterogenity'),
('2464', 'ith-endometrium'),
('2445', 'intratumoural heterogenity'),
('2445', 'cell culture'),
('2445', 'ith-ovary'),
('2445', 'xenograft'),
('3183', 'cell culture'),
('2417', 'intratumoural heterogenity'),
('2417', 'ith-ovary'),
('2441', 'intratumoural heterogenity'),
('2441', 'ith-ovary'),
('2447', 'intratumoural heterogenity'),
('2447', 'ith-endometrium'),
('2484', 'ith-ovary'),
('2484', 'intratumoural heterogenity'),
('2427', 'intratumoural heterogenity'),
('2427', 'ith-ovary'),
('2465', 'cell culture'),
('2466', 'intratumoural heterogenity'),
('2466', 'ith-ovary'),
('2459', 'intratumoural heterogenity'),
('2459', 'ith-endometrium'),
('2472', 'intratumoural heterogenity'),
('2472', 'ith-ovary'),
('2436', 'intratumoural heterogenity'),
('2436', 'cell culture'),
('2436', 'ith-ovary'),
('3019', 'endometriosis'),
('2449', 'intratumoural heterogenity'),
('2449', 'ith-endometrium'),
('2450', 'intratumoural heterogenity'),
('2450', 'cell culture'),
('2450', 'ith-ovary'),
('2477', 'ith-ovary'),
('2477', 'ith-endometrium'),
('2477', 'intratumoural heterogenity'),
('2467', 'intratumoural heterogenity'),
('2467', 'ith-endometrium'),
('2470', 'intratumoural heterogenity'),
('2470', 'ovarian cancer diagnosis'),
('2470', 'ith-endometrium'),
('2486', 'ith-ovary'),
('2486', 'intratumoural heterogenity'),
('2457', 'cell culture'),
('2854', 'pi3k'),
('2866', 'pi3k'),
('2469', 'intratumoural heterogenity'),
('2499', 'intratumoural heterogenity'),
('2499', 'ith-endometrium'),
('2491', 'ith-ovary'),
('2491', 'intratumoural heterogenity'),
('2490', 'ith-endometrium'),
('2490', 'intratumoural heterogenity'),
('2496', 'ith-endometrium'),
('2496', 'intratumoural heterogenity'),
('3002', 'intratumoural heterogenity'),
('3002', 'ith-ovary'),
('2476', 'intratumoural heterogenity'),
('2476', 'ith-endometrium'),
('3022', 'cell culture'),
('3023', 'intratumoural heterogenity'),
('3023', 'ith-endometrium'),
('3017', 'intratumoural heterogenity'),
('3017', 'ith-endometrium'),
('3000', 'intratumoural heterogenity'),
('3000', 'ith-endometrium'),
('3010', 'intratumoural heterogenity'),
('3010', 'ith-ovary'),
('3010', 'cell culture'),
('2485', 'ith-ovary'),
('2485', 'intratumoural heterogenity'),
('2495', 'intratumoural heterogenity'),
('2495', 'ith-endometrium'),
('2494', 'intratumoural heterogenity'),
('2494', 'ith-endometrium'),
('3015', 'intratumoural heterogenity'),
('3015', 'ith-ovary'),
('3021', 'intratumoural heterogenity'),
('3021', 'ith-endometrium'),
('3021', 'fimbrial scraping for culture'),
('2498', 'ith-endometrium'),
('2498', 'intratumoural heterogenity'),
('3006', 'intratumoural heterogenity'),
('3006', 'ith-endometrium'),
('3009', 'intratumoural heterogenity'),
('3009', 'ith-ovary'),
('3009', 'cell culture'),
('3014', 'cell culture'),
('3014', 'fimbrial scraping for culture'),
('3027', 'cell culture'),
('211', 'tfri couer'),
('211', 'ith-ovary'),
('211', 'intratumoural heterogenity'),
('1311', 'ith-ovary'),
('1311', 'intratumoural heterogenity'),
('21', 'ith-ovary'),
('21', 'intratumoural heterogenity'),
('439', 'tfri couer'),
('439', 'ith-ovary'),
('439', 'intratumoural heterogenity'),
('141', 'ith-ovary'),
('141', 'intratumoural heterogenity'),
('2278', 'endometriosis'),
('382', 'tfri couer'),
('382', 'ith-ovary'),
('382', 'intratumoural heterogenity'),
('32', 'ith-ovary'),
('32', 'intratumoural heterogenity'),
('972', 'ith-ovary'),
('972', 'intratumoural heterogenity'),
('1748', 'xenograft'),
('2165', 'ith-ovary'),
('2165', 'intratumoural heterogenity'),
('144', 'ith-ovary'),
('144', 'intratumoural heterogenity'),
('993', 'tfri couer'),
('1031', 'xenograft'),
('910', 'tcga'),
('910', 'tfri couer'),
('56', 'tfri couer'),
('56', 'ith-ovary'),
('56', 'intratumoural heterogenity'),
('2295', 'intratumoural heterogenity'),
('2295', 'ith-endometrium'),
('1438', 'precursor to prevention (tics)'),
('2487', 'endometriosis'),
('322', 'ith-ovary'),
('322', 'intratumoural heterogenity'),
('374', 'tfri couer'),
('212', 'tfri couer'),
('416', 'tfri couer'),
('416', 'ith-ovary'),
('416', 'intratumoural heterogenity'),
('2209', 'endometriosis'),
('1386', 'precursor to prevention (tics)'),
('752', 'tfri couer'),
('752', 'ith-ovary'),
('752', 'intratumoural heterogenity'),
('1275', 'precursor to prevention (tics)'),
('1591', 'intratumoural heterogenity'),
('1591', 'precursor to prevention (tics)'),
('1591', 'ith-ovary'),
('1591', 'xenograft'),
('1591', 'tfri couer'),
('494', 'tfri couer'),
('1385', 'precursor to prevention (tics)'),
('403', 'ith-ovary'),
('403', 'intratumoural heterogenity'),
('2050', 'xenograft'),
('1431', 'precursor to prevention (tics)'),
('379', 'tfri couer'),
('379', 'ith-ovary'),
('379', 'intratumoural heterogenity'),
('323', 'tfri couer'),
('1186', 'tfri couer'),
('1186', 'ith-ovary'),
('1186', 'xenograft'),
('1186', 'intratumoural heterogenity'),
('1814', 'xenograft'),
('343', 'tfri couer'),
('343', 'ith-ovary'),
('343', 'intratumoural heterogenity'),
('1351', 'tfri couer'),
('1351', 'ith-ovary'),
('1351', 'intratumoural heterogenity'),
('161', 'tfri couer'),
('161', 'ith-ovary'),
('161', 'intratumoural heterogenity'),
('1873', 'precursor to prevention (tics)'),
('378', 'tfri couer'),
('79', 'ith-ovary'),
('79', 'intratumoural heterogenity'),
('574', 'ith-ovary'),
('574', 'intratumoural heterogenity'),
('326', 'tfri couer'),
('326', 'ith-ovary'),
('326', 'intratumoural heterogenity'),
('1069', 'cell culture'),
('830', 'tfri couer'),
('830', 'ith-ovary'),
('830', 'intratumoural heterogenity'),
('1114', 'tfri couer'),
('1114', 'ith-ovary'),
('1114', 'cell culture'),
('1114', 'intratumoural heterogenity'),
('34', 'tfri couer'),
('479', 'tfri couer'),
('479', 'ith-ovary'),
('479', 'intratumoural heterogenity'),
('919', 'ith-ovary'),
('919', 'intratumoural heterogenity'),
('182', 'tfri couer'),
('2210', 'ith-endometrium'),
('2210', 'intratumoural heterogenity'),
('1687', 'precursor to prevention (tics)'),
('1143', 'tfri couer'),
('1143', 'ith-ovary'),
('1143', 'intratumoural heterogenity'),
('515', 'tcga'),
('515', 'tfri couer'),
('515', 'ith-ovary'),
('515', 'intratumoural heterogenity'),
('156', 'tfri couer'),
('156', 'ith-ovary'),
('156', 'intratumoural heterogenity'),
('1890', 'precursor to prevention (tics)'),
('463', 'ith-ovary'),
('463', 'intratumoural heterogenity'),
('241', 'ith-ovary'),
('241', 'intratumoural heterogenity'),
('1439', 'precursor to prevention (tics)'),
('946', 'tcga'),
('946', 'tfri couer'),
('946', 'xenograft'),
('2136', 'precursor to prevention (tics)'),
('2', 'tfri couer'),
('2', 'intratumoural heterogenity'),
('2', 'ith-ovary'),
('1169', 'precursor to prevention (tics)'),
('814', 'tfri couer'),
('814', 'xenograft'),
('1590', 'tfri couer'),
('1879', 'precursor to prevention (tics)'),
('1247', 'tfri couer'),
('1247', 'intratumoural heterogenity'),
('1247', 'ith-ovary'),
('1218', 'precursor to prevention (tics)'),
('980', 'tfri couer'),
('980', 'intratumoural heterogenity'),
('980', 'ith-ovary'),
('523', 'tfri couer'),
('1964', 'endometriosis'),
('1719', 'ovarian cancer diagnosis'),
('1719', 'cell culture'),
('1719', 'xenograft'),
('1719', 'intratumoural heterogenity'),
('1719', 'ith-ovary'),
('1719', 'tfri couer'),
('280', 'tfri couer'),
('2215', 'tfri couer'),
('2180', 'cell culture'),
('1416', 'cell culture'),
('3004', 'ith-ovary'),
('3004', 'intratumoural heterogenity'),
('12', 'ith-ovary'),
('12', 'intratumoural heterogenity'),
('1099', 'cell culture'),
('1261', 'precursor to prevention (tics)'),
('2234', 'fimbrial scraping for culture'),
('2234', 'endometriosis'),
('1150', 'fimbrial scraping for culture'),
('662', 'tfri couer'),
('662', 'ith-ovary'),
('662', 'intratumoural heterogenity'),
('1820', 'precursor to prevention (tics)'),
('1225', 'precursor to prevention (tics)'),
('1994', 'tfri couer'),
('759', 'tcga'),
('759', 'tfri couer'),
('759', 'xenograft'),
('759', 'ith-ovary'),
('759', 'intratumoural heterogenity'),
('1140', 'tfri couer'),
('1846', 'ith-ovary'),
('1846', 'intratumoural heterogenity'),
('1545', 'ith-ovary'),
('1545', 'intratumoural heterogenity'),
('1203', 'ith-ovary'),
('1203', 'intratumoural heterogenity'),
('15', 'tfri couer'),
('145', 'tfri couer'),
('1474', 'tfri couer'),
('1078', 'cell culture'),
('1745', 'precursor to prevention (tics)'),
('499', 'ith-ovary'),
('499', 'intratumoural heterogenity'),
('2176', 'ith-ovary'),
('2176', 'intratumoural heterogenity'),
('1257', 'fimbrial scraping for culture'),
('369', 'tcga'),
('369', 'tfri couer'),
('11', 'tfri couer'),
('2033', 'endometriosis'),
('2213', 'ith-endometrium'),
('2213', 'intratumoural heterogenity'),
('1922', 'tfri couer'),
('1493', 'ith-ovary'),
('1493', 'intratumoural heterogenity'),
('1493', 'tfri couer'),
('384', 'tfri couer'),
('464', 'tfri couer'),
('1369', 'tfri couer'),
('2052', 'endometriosis'),
('1650', 'precursor to prevention (tics)'),
('496', 'tcga'),
('496', 'tfri couer'),
('496', 'ith-ovary'),
('496', 'intratumoural heterogenity'),
('1122', 'tfri couer'),
('1122', 'xenograft'),
('1122', 'cell culture'),
('514', 'ith-ovary'),
('514', 'intratumoural heterogenity'),
('876', 'precursor to prevention (tics)'),
('2191', 'ith-ovary'),
('2191', 'cell culture'),
('2191', 'intratumoural heterogenity'),
('522', 'ith-ovary'),
('522', 'intratumoural heterogenity'),
('1035', 'tfri couer'),
('1693', 'intratumoural heterogenity'),
('1693', 'ith-ovary'),
('1693', 'ovarian cancer diagnosis'),
('1144', 'tfri couer'),
('1144', 'intratumoural heterogenity'),
('1144', 'ith-ovary'),
('782', 'tfri couer'),
('782', 'ith-ovary'),
('782', 'xenograft'),
('782', 'intratumoural heterogenity'),
('1366', 'tfri couer'),
('2055', 'endometriosis'),
('2182', 'cell culture'),
('348', 'ith-ovary'),
('348', 'intratumoural heterogenity'),
('1847', 'tcga'),
('1011', 'tcga'),
('1011', 'tfri couer'),
('2249', 'endometriosis'),
('2421', 'intratumoural heterogenity'),
('2421', 'ith-endometrium'),
('1632', 'cell culture'),
('801', 'tcga'),
('801', 'tfri couer'),
('801', 'ovarian cancer diagnosis'),
('801', 'xenograft'),
('65', 'tfri couer'),
('1117', 'tfri couer'),
('1349', 'tfri couer'),
('2186', 'intratumoural heterogenity'),
('2463', 'intratumoural heterogenity'),
('2463', 'ith-endometrium'),
('818', 'tfri couer'),
('1835', 'precursor to prevention (tics)'),
('544', 'tcga'),
('544', 'tfri couer'),
('1057', 'tcga'),
('1057', 'tfri couer'),
('2128', 'precursor to prevention (tics)'),
('1258', 'precursor to prevention (tics)'),
('1164', 'cell culture'),
('2232', 'tfri couer'),
('1834', 'precursor to prevention (tics)'),
('1739', 'xenograft'),
('412', 'tfri couer'),
('412', 'ith-ovary'),
('412', 'intratumoural heterogenity'),
('1884', 'tfri couer'),
('1926', 'ith-ovary'),
('1926', 'intratumoural heterogenity'),
('1926', 'tfri couer'),
('1538', 'precursor to prevention (tics)'),
('579', 'tfri couer'),
('654', 'tfri couer'),
('654', 'ith-ovary'),
('654', 'intratumoural heterogenity'),
('365', 'tfri couer'),
('365', 'ith-ovary'),
('365', 'intratumoural heterogenity'),
('2197', 'cell culture'),
('2197', 'ith-ovary'),
('2197', 'intratumoural heterogenity'),
('1159', 'fimbrial scraping for culture'),
('1159', 'cell culture'),
('720', 'tfri couer'),
('1724', 'ovarian cancer diagnosis'),
('1724', 'ith-ovary'),
('1724', 'intratumoural heterogenity'),
('1724', 'tfri couer'),
('223', 'tfri couer'),
('223', 'intratumoural heterogenity'),
('223', 'ith-ovary'),
('419', 'tfri couer'),
('419', 'ith-ovary'),
('419', 'intratumoural heterogenity'),
('247', 'ith-ovary'),
('247', 'intratumoural heterogenity'),
('441', 'tfri couer'),
('270', 'ith-ovary'),
('270', 'intratumoural heterogenity'),
('1648', 'cell culture'),
('1648', 'intratumoural heterogenity'),
('1648', 'ith-ovary'),
('404', 'tfri couer'),
('1162', 'ith-ovary'),
('1162', 'intratumoural heterogenity'),
('545', 'tfri couer'),
('2194', 'intratumoural heterogenity'),
('2415', 'intratumoural heterogenity'),
('2415', 'ith-endometrium'),
('1123', 'tcga'),
('1123', 'xenograft'),
('811', 'tfri couer'),
('73', 'tfri couer'),
('73', 'ith-ovary'),
('73', 'intratumoural heterogenity'),
('2245', 'ith-endometrium'),
('2245', 'intratumoural heterogenity'),
('1016', 'xenograft'),
('1021', 'tfri couer'),
('1887', 'precursor to prevention (tics)'),
('1268', 'tfri couer'),
('1268', 'xenograft'),
('1433', 'precursor to prevention (tics)'),
('1993', 'endometriosis'),
('686', 'tcga'),
('686', 'tfri couer'),
('614', 'fimbrial scraping for culture'),
('3041', 'ith-endometrium'),
('3041', 'intratumoural heterogenity'),
('345', 'tfri couer'),
('2257', 'cell culture'),
('2296', 'endometriosis'),
('589', 'tcga'),
('589', 'tfri couer'),
('589', 'ith-ovary'),
('589', 'intratumoural heterogenity'),
('1911', 'ith-ovary'),
('1911', 'intratumoural heterogenity'),
('1911', 'tfri couer'),
('839', 'xenograft'),
('1373', 'precursor to prevention (tics)'),
('329', 'tfri couer'),
('329', 'ith-ovary'),
('329', 'intratumoural heterogenity'),
('1855', 'precursor to prevention (tics)'),
('711', 'ith-endometrium'),
('711', 'xenograft'),
('711', 'intratumoural heterogenity'),
('429', 'tfri couer'),
('539', 'xenograft'),
('539', 'ith-ovary'),
('539', 'intratumoural heterogenity'),
('1037', 'tfri couer'),
('254', 'tfri couer'),
('422', 'ith-ovary'),
('422', 'intratumoural heterogenity'),
('167', 'ith-ovary'),
('167', 'intratumoural heterogenity'),
('1833', 'tcga'),
('335', 'ith-ovary'),
('335', 'intratumoural heterogenity'),
('1841', 'tfri couer'),
('1054', 'cell culture'),
('2298', 'intratumoural heterogenity'),
('2298', 'ith-endometrium'),
('1764', 'precursor to prevention (tics)'),
('525', 'tfri couer'),
('1270', 'cell culture'),
('1669', 'precursor to prevention (tics)'),
('2104', 'precursor to prevention (tics)'),
('284', 'ith-ovary'),
('284', 'intratumoural heterogenity'),
('68', 'tfri couer'),
('1246', 'tfri couer'),
('1246', 'precursor to prevention (tics)'),
('1501', 'precursor to prevention (tics)'),
('853', 'tcga'),
('853', 'xenograft'),
('853', 'ith-ovary'),
('853', 'intratumoural heterogenity'),
('1663', 'tfri couer'),
('1084', 'tfri couer'),
('232', 'ith-ovary'),
('232', 'intratumoural heterogenity'),
('498', 'tfri couer'),
('1215', 'tfri couer'),
('1215', 'ith-ovary'),
('1215', 'intratumoural heterogenity'),
('443', 'tfri couer'),
('24', 'tfri couer'),
('402', 'tfri couer'),
('402', 'ith-ovary'),
('402', 'intratumoural heterogenity'),
('2231', 'ith-endometrium'),
('2231', 'intratumoural heterogenity'),
('409', 'tfri couer'),
('565', 'ith-ovary'),
('565', 'intratumoural heterogenity'),
('1145', 'tfri couer'),
('281', 'tfri couer'),
('281', 'ith-ovary'),
('281', 'intratumoural heterogenity'),
('528', 'tfri couer'),
('421', 'tfri couer'),
('421', 'ith-ovary'),
('421', 'intratumoural heterogenity'),
('190', 'tfri couer'),
('190', 'intratumoural heterogenity'),
('739', 'tcga'),
('739', 'tfri couer'),
('739', 'ith-ovary'),
('739', 'intratumoural heterogenity'),
('2025', 'tcga'),
('943', 'tcga'),
('943', 'tfri couer'),
('888', 'ith-endometrium'),
('888', 'intratumoural heterogenity'),
('471', 'tfri couer'),
('1224', 'precursor to prevention (tics)'),
('1066', 'cell culture'),
('158', 'ith-ovary'),
('158', 'intratumoural heterogenity'),
('389', 'tfri couer'),
('1786', 'intratumoural heterogenity'),
('1786', 'ith-ovary'),
('3549', 'cell culture'),
('1908', 'fimbrial scraping for culture'),
('666', 'tcga'),
('666', 'tfri couer'),
('774', 'ovarian cancer diagnosis'),
('2004', 'tfri couer'),
('1961', 'endometriosis'),
('331', 'tfri couer'),
('331', 'ith-ovary'),
('331', 'intratumoural heterogenity'),
('741', 'intratumoural heterogenity'),
('741', 'ith-ovary'),
('1358', 'tcga'),
('2282', 'intratumoural heterogenity'),
('1686', 'intratumoural heterogenity'),
('1686', 'ovarian cancer diagnosis'),
('1686', 'ith-ovary'),
('1686', 'xenograft'),
('1686', 'tfri couer'),
('1286', 'tfri couer'),
('1286', 'precursor to prevention (tics)'),
('246', 'ith-ovary'),
('246', 'intratumoural heterogenity'),
('1727', 'xenograft'),
('1727', 'cell culture'),
('1727', 'ith-ovary'),
('1727', 'intratumoural heterogenity'),
('1727', 'tfri couer'),
('40', 'tfri couer'),
('40', 'ith-ovary'),
('40', 'intratumoural heterogenity'),
('1110', 'tfri couer'),
('1110', 'cell culture'),
('171', 'tfri couer'),
('70', 'tfri couer'),
('255', 'tfri couer'),
('255', 'intratumoural heterogenity'),
('255', 'ith-ovary'),
('1269', 'cell culture'),
('1503', 'ith-ovary'),
('1503', 'intratumoural heterogenity'),
('1912', 'ovarian cancer diagnosis'),
('1912', 'intratumoural heterogenity'),
('1912', 'ith-ovary'),
('1891', 'precursor to prevention (tics)'),
('1174', 'ith-ovary'),
('1174', 'intratumoural heterogenity'),
('1876', 'intratumoural heterogenity'),
('1876', 'ith-ovary'),
('1725', 'ovarian cancer diagnosis'),
('1725', 'ith-ovary'),
('1725', 'intratumoural heterogenity'),
('1725', 'tfri couer'),
('2206', 'endometriosis'),
('366', 'tfri couer'),
('366', 'ith-ovary'),
('366', 'intratumoural heterogenity'),
('1061', 'cell culture'),
('749', 'tfri couer'),
('749', 'ith-ovary'),
('749', 'intratumoural heterogenity'),
('1958', 'ith-ovary'),
('1958', 'intratumoural heterogenity'),
('1462', 'ith-endometrium'),
('1462', 'intratumoural heterogenity'),
('1312', 'cell culture'),
('1977', 'endometriosis'),
('489', 'tfri couer'),
('489', 'ith-ovary'),
('489', 'intratumoural heterogenity'),
('2478', 'ith-endometrium'),
('2478', 'intratumoural heterogenity'),
('1769', 'intratumoural heterogenity'),
('1769', 'ovarian cancer diagnosis'),
('1769', 'ith-ovary'),
('1769', 'xenograft'),
('595', 'ith-ovary'),
('595', 'intratumoural heterogenity'),
('413', 'tfri couer'),
('413', 'ith-ovary'),
('413', 'intratumoural heterogenity'),
('425', 'ith-ovary'),
('425', 'intratumoural heterogenity'),
('1668', 'precursor to prevention (tics)'),
('140', 'ith-ovary'),
('140', 'intratumoural heterogenity'),
('330', 'tfri couer'),
('219', 'ith-ovary'),
('219', 'intratumoural heterogenity'),
('1743', 'precursor to prevention (tics)'),
('1131', 'ith-ovary'),
('1131', 'intratumoural heterogenity'),
('1397', 'precursor to prevention (tics)'),
('1421', 'precursor to prevention (tics)'),
('1421', 'ith-ovary'),
('1421', 'intratumoural heterogenity'),
('1421', 'tfri couer'),
('67', 'tfri couer'),
('1796', 'ovarian cancer diagnosis'),
('1796', 'ith-ovary'),
('1796', 'intratumoural heterogenity'),
('199', 'ith-ovary'),
('199', 'intratumoural heterogenity'),
('1399', 'tfri couer'),
('3030', 'ith-endometrium'),
('3030', 'intratumoural heterogenity'),
('346', 'tfri couer'),
('346', 'ith-ovary'),
('346', 'intratumoural heterogenity'),
('1271', 'xenograft'),
('1191', 'tfri couer'),
('1191', 'precursor to prevention (tics)'),
('681', 'tcga'),
('681', 'tfri couer'),
('681', 'ith-ovary'),
('681', 'intratumoural heterogenity'),
('2086', 'endometriosis'),
('1274', 'tfri couer'),
('1274', 'precursor to prevention (tics)'),
('1049', 'tfri couer'),
('1721', 'ovarian cancer diagnosis'),
('1721', 'ith-ovary'),
('1721', 'intratumoural heterogenity'),
('1673', 'precursor to prevention (tics)'),
('2175', 'cell culture'),
('2297', 'intratumoural heterogenity'),
('2297', 'ith-endometrium'),
('950', 'tcga'),
('950', 'tfri couer'),
('2285', 'intratumoural heterogenity'),
('2285', 'ith-endometrium'),
('283', 'tcga'),
('283', 'tfri couer'),
('283', 'ith-ovary'),
('283', 'intratumoural heterogenity'),
('1406', 'tfri couer'),
('3053', 'intratumoural heterogenity'),
('3053', 'ith-endometrium'),
('1190', 'tfri couer'),
('468', 'ith-ovary'),
('468', 'intratumoural heterogenity'),
('394', 'tfri couer'),
('433', 'ith-ovary'),
('433', 'intratumoural heterogenity'),
('1304', 'precursor to prevention (tics)'),
('591', 'ith-ovary'),
('591', 'intratumoural heterogenity'),
('2200', 'tfri couer'),
('1148', 'cell culture'),
('1027', 'cell culture'),
('1291', 'precursor to prevention (tics)'),
('934', 'ith-ovary'),
('934', 'intratumoural heterogenity'),
('1344', 'tfri couer'),
('1344', 'ith-ovary'),
('1344', 'intratumoural heterogenity'),
('1223', 'tfri couer'),
('2015', 'endometriosis'),
('2290', 'fimbrial scraping for culture'),
('1120', 'cell culture'),
('753', 'tfri couer'),
('1645', 'precursor to prevention (tics)'),
('1862', 'intratumoural heterogenity'),
('1862', 'ith-ovary'),
('2066', 'precursor to prevention (tics)'),
('540', 'tfri couer'),
('2452', 'endometriosis'),
('2177', 'endometriosis'),
('2084', 'ith-ovary'),
('2084', 'ovarian cancer diagnosis'),
('2084', 'intratumoural heterogenity'),
('1250', 'tfri couer'),
('3188', 'cell culture'),
('55', 'ith-ovary'),
('55', 'intratumoural heterogenity'),
('2203', 'ith-endometrium'),
('2203', 'intratumoural heterogenity'),
('1163', 'tfri couer'),
('1307', 'precursor to prevention (tics)'),
('1202', 'precursor to prevention (tics)'),
('3722', 'cell culture'),
('4107', 'cell culture'),
('1448', 'cell culture'),
('1880', 'tfri couer'),
('601', 'tcga'),
('601', 'tfri couer'),
('601', 'ith-ovary'),
('601', 'intratumoural heterogenity'),
('2016', 'ith-ovary'),
('2016', 'intratumoural heterogenity'),
('2451', 'intratumoural heterogenity'),
('2451', 'cell culture'),
('2451', 'ith-ovary'),
('2451', 'xenograft'),
('507', 'tfri couer'),
('2059', 'endometriosis'),
('3715', 'cell culture'),
('81', 'ith-ovary'),
('81', 'intratumoural heterogenity'),
('112', 'tfri couer'),
('1354', 'ith-ovary'),
('1354', 'intratumoural heterogenity'),
('4116', 'ith-ovary'),
('4116', 'intratumoural heterogenity'),
('1883', 'precursor to prevention (tics)'),
('2048', 'endometriosis'),
('485', 'ith-ovary'),
('485', 'intratumoural heterogenity'),
('3745', 'cell culture'),
('682', 'tfri couer'),
('2481', 'endometriosis'),
('133', 'tfri couer'),
('133', 'ith-ovary'),
('133', 'intratumoural heterogenity'),
('1616', 'precursor to prevention (tics)'),
('1839', 'precursor to prevention (tics)'),
('266', 'tfri couer'),
('1608', 'intratumoural heterogenity'),
('1608', 'precursor to prevention (tics)'),
('1608', 'ith-ovary'),
('1608', 'xenograft'),
('1608', 'tfri couer'),
('1608', 'cell culture'),
('530', 'tfri couer'),
('530', 'ith-ovary'),
('530', 'intratumoural heterogenity'),
('2460', 'intratumoural heterogenity'),
('2460', 'ith-endometrium'),
('2289', 'intratumoural heterogenity'),
('2289', 'ith-endometrium'),
('598', 'tfri couer'),
('598', 'ith-ovary'),
('598', 'intratumoural heterogenity'),
('779', 'tcga'),
('779', 'tfri couer'),
('2443', 'intratumoural heterogenity'),
('2443', 'ith-ovary'),
('2226', 'ith-endometrium'),
('2226', 'intratumoural heterogenity'),
('1006', 'tfri couer'),
('1345', 'precursor to prevention (tics)'),
('2156', 'ith-ovary'),
('2156', 'intratumoural heterogenity'),
('2156', 'tfri couer'),
('1285', 'precursor to prevention (tics)'),
('2479', 'ith-ovary'),
('2479', 'intratumoural heterogenity'),
('3051', 'endometriosis'),
('3051', 'intratumoural heterogenity'),
('3051', 'ith-endometrium'),
('2299', 'endometriosis'),
('626', 'tcga'),
('626', 'tfri couer'),
('1734', 'precursor to prevention (tics)'),
('1829', 'precursor to prevention (tics)'),
('278', 'ith-ovary'),
('278', 'intratumoural heterogenity'),
('696', 'cell culture'),
('691', 'tfri couer'),
('334', 'tfri couer'),
('334', 'ith-ovary'),
('334', 'intratumoural heterogenity'),
('122', 'tfri couer'),
('122', 'ith-ovary'),
('122', 'intratumoural heterogenity'),
('1434', 'cell culture'),
('865', 'ith-ovary'),
('865', 'intratumoural heterogenity'),
('1840', 'precursor to prevention (tics)'),
('380', 'ith-ovary'),
('380', 'intratumoural heterogenity'),
('1362', 'cell culture'),
('1362', 'precursor to prevention (tics)'),
('1362', 'xenograft'),
('1362', 'tfri couer'),
('1362', 'ith-ovary'),
('1362', 'intratumoural heterogenity'),
('4046', 'cell culture'),
('4046', 'precursor to prevention (tics)'),
('4046', 'xenograft'),
('4046', 'tfri couer'),
('4046', 'ith-ovary'),
('4046', 'intratumoural heterogenity'),
('1196', 'precursor to prevention (tics)'),
('2418', 'intratumoural heterogenity'),
('2418', 'ith-endometrium'),
('1654', 'ith-ovary'),
('1654', 'intratumoural heterogenity'),
('1178', 'tfri couer'),
('1178', 'xenograft'),
('1178', 'ith-ovary'),
('1178', 'intratumoural heterogenity'),
('363', 'tfri couer'),
('809', 'tfri couer'),
('428', 'ith-ovary'),
('428', 'intratumoural heterogenity'),
('317', 'ith-ovary'),
('317', 'intratumoural heterogenity'),
('1410', 'cell culture'),
('1410', 'ith-ovary'),
('1410', 'xenograft'),
('1410', 'intratumoural heterogenity'),
('197', 'tfri couer'),
('656', 'tcga'),
('656', 'tfri couer'),
('213', 'ith-ovary'),
('213', 'intratumoural heterogenity'),
('609', 'tfri couer'),
('783', 'tfri couer'),
('621', 'tfri couer'),
('621', 'ith-ovary'),
('621', 'intratumoural heterogenity'),
('1283', 'tfri couer'),
('1283', 'precursor to prevention (tics)'),
('1283', 'intratumoural heterogenity'),
('1283', 'ith-ovary'),
('1283', 'cell culture'),
('236', 'tfri couer'),
('1383', 'precursor to prevention (tics)'),
('724', 'tcga'),
('724', 'tfri couer'),
('319', 'tfri couer'),
('1871', 'precursor to prevention (tics)'),
('1128', 'tfri couer'),
('1339', 'tfri couer'),
('1339', 'ith-ovary'),
('1339', 'intratumoural heterogenity'),
('114', 'tfri couer'),
('3029', 'cell culture'),
('1722', 'intratumoural heterogenity'),
('1722', 'ith-endometrium'),
('2051', 'tfri couer'),
('1948', 'endometriosis'),
('4317', 'xenograft'),
('1173', 'ith-ovary'),
('1173', 'xenograft'),
('1173', 'intratumoural heterogenity'),
('2103', 'precursor to prevention (tics)'),
('2103', 'ith-ovary'),
('2103', 'cell culture'),
('2103', 'intratumoural heterogenity'),
('1867', 'tfri couer'),
('1894', 'ovarian cancer diagnosis'),
('1894', 'intratumoural heterogenity'),
('1894', 'ith-ovary'),
('1419', 'precursor to prevention (tics)'),
('2185', 'intratumoural heterogenity'),
('2185', 'ith-ovary'),
('1818', 'precursor to prevention (tics)'),
('1198', 'tfri couer'),
('1198', 'ith-ovary'),
('1198', 'intratumoural heterogenity'),
('2181', 'tfri couer'),
('1962', 'endometriosis'),
('1303', 'tfri couer'),
('1303', 'cell culture'),
('1303', 'xenograft'),
('1303', 'ith-ovary'),
('1303', 'intratumoural heterogenity'),
('3039', 'fimbrial scraping for culture'),
('2105', 'tfri couer'),
('2219', 'endometriosis'),
('3044', 'intratumoural heterogenity'),
('3044', 'ith-endometrium'),
('450', 'tfri couer'),
('450', 'ith-ovary'),
('450', 'intratumoural heterogenity'),
('414', 'tfri couer'),
('1264', 'precursor to prevention (tics)'),
('1999', 'ith-ovary'),
('1999', 'intratumoural heterogenity'),
('2146', 'precursor to prevention (tics)'),
('744', 'tcga'),
('744', 'tfri couer'),
('2014', 'ovarian cancer diagnosis'),
('2014', 'ith-ovary'),
('2014', 'intratumoural heterogenity'),
('2014', 'tfri couer'),
('738', 'tfri couer'),
('2434', 'intratumoural heterogenity'),
('2434', 'ith-endometrium'),
('342', 'tfri couer'),
('342', 'ith-ovary'),
('342', 'intratumoural heterogenity'),
('1256', 'tfri couer'),
('1256', 'xenograft'),
('1219', 'precursor to prevention (tics)'),
('260', 'tfri couer'),
('260', 'intratumoural heterogenity'),
('260', 'ith-ovary'),
('2057', 'ith-ovary'),
('2057', 'intratumoural heterogenity'),
('2057', 'tfri couer'),
('1747', 'tfri couer'),
('790', 'tcga'),
('790', 'tfri couer'),
('1025', 'cell culture'),
('1443', 'tfri couer'),
('1698', 'precursor to prevention (tics)'),
('1071', 'tfri couer'),
('1071', 'ith-ovary'),
('1071', 'intratumoural heterogenity'),
('1659', 'precursor to prevention (tics)'),
('1289', 'intratumoural heterogenity'),
('1289', 'ith-ovary'),
('3031', 'ith-endometrium'),
('3031', 'intratumoural heterogenity'),
('3064', 'intratumoural heterogenity'),
('3064', 'ith-endometrium'),
('868', 'ith-endometrium'),
('868', 'intratumoural heterogenity'),
('1182', 'tfri couer'),
('1182', 'ith-ovary'),
('1182', 'intratumoural heterogenity'),
('1108', 'ith-ovary'),
('1108', 'cell culture'),
('1108', 'intratumoural heterogenity'),
('249', 'tfri couer'),
('3013', 'ith-endometrium'),
('3013', 'intratumoural heterogenity'),
('1053', 'cell culture'),
('964', 'cell culture'),
('448', 'tfri couer'),
('670', 'ith-ovary'),
('670', 'intratumoural heterogenity'),
('2126', 'ovarian cancer diagnosis'),
('2126', 'ith-ovary'),
('2126', 'intratumoural heterogenity'),
('1068', 'xenograft'),
('35', 'ith-ovary'),
('35', 'intratumoural heterogenity'),
('1577', 'ith-ovary'),
('1577', 'intratumoural heterogenity'),
('2022', 'intratumoural heterogenity'),
('1488', 'ith-ovary'),
('1488', 'intratumoural heterogenity'),
('1488', 'tfri couer'),
('1325', 'precursor to prevention (tics)'),
('1179', 'tfri couer'),
('1179', 'ith-ovary'),
('1179', 'intratumoural heterogenity'),
('650', 'tcga'),
('650', 'tfri couer'),
('650', 'ith-ovary'),
('650', 'intratumoural heterogenity'),
('1647', 'intratumoural heterogenity'),
('1647', 'ith-endometrium'),
('1842', 'precursor to prevention (tics)'),
('1842', 'intratumoural heterogenity'),
('1842', 'ith-ovary'),
('1842', 'tfri couer'),
('991', 'tcga'),
('991', 'tfri couer'),
('1074', 'cell culture'),
('1971', 'endometriosis'),
('239', 'tfri couer'),
('239', 'ith-ovary'),
('239', 'intratumoural heterogenity'),
('105', 'ith-ovary'),
('105', 'intratumoural heterogenity'),
('126', 'tfri couer'),
('293', 'tfri couer'),
('2240', 'endometriosis'),
('999', 'tfri couer'),
('798', 'xenograft'),
('2073', 'endometriosis'),
('2073', 'xenograft'),
('1318', 'precursor to prevention (tics)'),
('400', 'ith-ovary'),
('400', 'intratumoural heterogenity'),
('1875', 'xenograft'),
('1695', 'intratumoural heterogenity'),
('1695', 'ith-endometrium'),
('295', 'tfri couer'),
('295', 'intratumoural heterogenity'),
('295', 'ith-ovary'),
('1770', 'ovarian cancer diagnosis'),
('1770', 'xenograft'),
('1770', 'ith-ovary'),
('1770', 'intratumoural heterogenity'),
('4050', 'ovarian cancer diagnosis'),
('518', 'tfri couer'),
('3602', 'intratumoural heterogenity'),
('3602', 'ith-endometrium'),
('3602', 'xenograft'),
('2094', 'endometriosis'),
('949', 'tfri couer'),
('949', 'xenograft'),
('2112', 'precursor to prevention (tics)'),
('1798', 'intratumoural heterogenity'),
('1798', 'ovarian cancer diagnosis'),
('1798', 'ith-ovary'),
('1310', 'precursor to prevention (tics)'),
('325', 'tfri couer'),
('1740', 'tcga'),
('1555', 'cell culture'),
('1555', 'ith-ovary'),
('1555', 'intratumoural heterogenity'),
('1555', 'tfri couer'),
('127', 'tfri couer'),
('127', 'ith-ovary'),
('127', 'intratumoural heterogenity'),
('1129', 'ith-ovary'),
('1129', 'intratumoural heterogenity'),
('1578', 'ith-ovary'),
('1578', 'cell culture'),
('1578', 'intratumoural heterogenity'),
('1578', 'tfri couer'),
('864', 'tfri couer'),
('385', 'tfri couer'),
('385', 'ith-ovary'),
('385', 'intratumoural heterogenity'),
('1910', 'intratumoural heterogenity'),
('2204', 'endometriosis'),
('904', 'tcga'),
('493', 'tcga'),
('493', 'tfri couer'),
('493', 'ith-ovary'),
('493', 'intratumoural heterogenity'),
('1107', 'tfri couer'),
('1306', 'intratumoural heterogenity'),
('1306', 'tfri couer'),
('1306', 'ith-ovary'),
('1050', 'tfri couer'),
('687', 'ith-ovary'),
('687', 'intratumoural heterogenity'),
('1712', 'intratumoural heterogenity'),
('1712', 'ovarian cancer diagnosis'),
('1712', 'ith-ovary'),
('445', 'tfri couer'),
('445', 'ith-ovary'),
('445', 'intratumoural heterogenity'),
('1811', 'intratumoural heterogenity'),
('1811', 'xenograft'),
('1811', 'ith-ovary'),
('1811', 'tfri couer'),
('1384', 'tfri couer'),
('1384', 'ith-ovary'),
('1384', 'intratumoural heterogenity'),
('1204', 'precursor to prevention (tics)'),
('1328', 'tfri couer'),
('1328', 'ith-ovary'),
('1328', 'intratumoural heterogenity'),
('620', 'tcga'),
('620', 'tfri couer'),
('620', 'ith-ovary'),
('620', 'intratumoural heterogenity'),
('1472', 'ith-ovary'),
('1472', 'intratumoural heterogenity'),
('1472', 'tfri couer'),
('444', 'ith-ovary'),
('444', 'intratumoural heterogenity'),
('1991', 'endometriosis'),
('1917', 'xenograft'),
('483', 'tfri couer'),
('800', 'tfri couer'),
('800', 'ith-ovary'),
('800', 'xenograft'),
('800', 'intratumoural heterogenity'),
('124', 'tfri couer'),
('124', 'ith-ovary'),
('124', 'intratumoural heterogenity'),
('131', 'tfri couer'),
('131', 'ith-ovary'),
('131', 'intratumoural heterogenity'),
('3033', 'cell culture'),
('3033', 'endometriosis'),
('181', 'ith-endometrium'),
('181', 'intratumoural heterogenity'),
('1309', 'precursor to prevention (tics)'),
('1768', 'precursor to prevention (tics)'),
('1768', 'intratumoural heterogenity'),
('1768', 'ovarian cancer diagnosis'),
('1768', 'ith-ovary'),
('147', 'ith-ovary'),
('147', 'intratumoural heterogenity'),
('1815', 'ovarian cancer diagnosis'),
('1815', 'ith-ovary'),
('1815', 'intratumoural heterogenity'),
('1211', 'tfri couer'),
('1211', 'ith-ovary'),
('1211', 'intratumoural heterogenity'),
('426', 'tfri couer'),
('426', 'ith-ovary'),
('426', 'intratumoural heterogenity'),
('327', 'tfri couer'),
('327', 'ith-ovary'),
('327', 'intratumoural heterogenity'),
('2254', 'endometriosis'),
('3100', 'cell culture'),
('881', 'tfri couer'),
('258', 'tfri couer'),
('1454', 'ith-ovary'),
('1454', 'intratumoural heterogenity'),
('1454', 'tfri couer'),
('1359', 'cell culture'),
('1359', 'tfri couer'),
('1359', 'ith-ovary'),
('1359', 'xenograft'),
('1359', 'intratumoural heterogenity'),
('4122', 'tfri couer'),
('1916', 'cell culture'),
('436', 'tfri couer'),
('1749', 'xenograft'),
('1749', 'ovarian cancer diagnosis'),
('1749', 'ith-ovary'),
('1749', 'intratumoural heterogenity'),
('1749', 'tfri couer'),
('176', 'tfri couer'),
('1119', 'cell culture'),
('1988', 'endometriosis'),
('57', 'ith-ovary'),
('57', 'intratumoural heterogenity'),
('218', 'tfri couer'),
('218', 'intratumoural heterogenity'),
('218', 'ith-ovary'),
('432', 'tfri couer'),
('1617', 'ith-ovary'),
('1617', 'intratumoural heterogenity'),
('1188', 'ith-ovary'),
('1188', 'intratumoural heterogenity'),
('245', 'ith-ovary'),
('245', 'intratumoural heterogenity'),
('1341', 'precursor to prevention (tics)'),
('66', 'ith-ovary'),
('66', 'intratumoural heterogenity'),
('1098', 'tfri couer'),
('4054', 'tfri couer'),
('1072', 'tfri couer'),
('1072', 'cell culture'),
('1072', 'ith-ovary'),
('1072', 'intratumoural heterogenity'),
('332', 'tfri couer'),
('332', 'intratumoural heterogenity'),
('332', 'ith-ovary'),
('1300', 'intratumoural heterogenity'),
('1300', 'cell culture'),
('1300', 'tfri couer'),
('1300', 'ith-ovary'),
('1464', 'ith-ovary'),
('1464', 'xenograft'),
('1464', 'intratumoural heterogenity'),
('209', 'tfri couer'),
('392', 'tfri couer'),
('392', 'ith-ovary'),
('392', 'intratumoural heterogenity'),
('1400', 'tfri couer'),
('1400', 'xenograft'),
('189', 'tfri couer'),
('1585', 'precursor to prevention (tics)'),
('1251', 'tfri couer'),
('1251', 'precursor to prevention (tics)'),
('1213', 'precursor to prevention (tics)'),
('893', 'tcga'),
('583', 'tcga'),
('583', 'tfri couer'),
('1477', 'ith-ovary'),
('1477', 'intratumoural heterogenity'),
('2425', 'endometriosis'),
('2425', 'fimbrial scraping for culture'),
('891', 'tcga'),
('891', 'tfri couer'),
('1287', 'tfri couer'),
('1262', 'tfri couer'),
('1262', 'xenograft'),
('1298', 'precursor to prevention (tics)'),
('2039', 'xenograft'),
('2039', 'endometriosis'),
('296', 'ith-ovary'),
('296', 'intratumoural heterogenity'),
('1460', 'ith-ovary'),
('1460', 'intratumoural heterogenity'),
('1460', 'tfri couer'),
('2035', 'endometriosis'),
('546', 'tfri couer'),
('1500', 'tfri couer'),
('235', 'ith-ovary'),
('235', 'intratumoural heterogenity'),
('344', 'tfri couer'),
('344', 'ith-ovary'),
('344', 'intratumoural heterogenity'),
('955', 'ith-endometrium'),
('955', 'intratumoural heterogenity'),
('2461', 'intratumoural heterogenity'),
('2461', 'ith-endometrium'),
('1907', 'fimbrial scraping for culture'),
('1907', 'precursor to prevention (tics)'),
('1976', 'endometriosis'),
('1807', 'xenograft'),
('437', 'tfri couer'),
('1158', 'tfri couer'),
('1158', 'xenograft'),
('1201', 'tfri couer'),
('23', 'tfri couer'),
('1866', 'precursor to prevention (tics)'),
('75', 'ith-ovary'),
('75', 'intratumoural heterogenity'),
('2259', 'endometriosis'),
('2118', 'cell culture'),
('2118', 'ith-ovary'),
('2118', 'intratumoural heterogenity'),
('2270', 'endometriosis'),
('3096', 'intratumoural heterogenity'),
('3096', 'ith-endometrium'),
('2424', 'endometriosis'),
('2435', 'endometriosis'),
('2455', 'cell culture'),
('1750', 'xenograft'),
('1489', 'ith-endometrium'),
('1489', 'intratumoural heterogenity'),
('1848', 'tfri couer'),
('2093', 'endometriosis'),
('1281', 'precursor to prevention (tics)'),
('3012', 'cell culture'),
('3012', 'fimbrial scraping for culture'),
('1292', 'ith-ovary'),
('1292', 'intratumoural heterogenity'),
('959', 'tcga'),
('959', 'tfri couer'),
('959', 'intratumoural heterogenity'),
('959', 'ith-ovary'),
('2002', 'endometriosis'),
('1381', 'tfri couer'),
('1391', 'precursor to prevention (tics)'),
('3045', 'intratumoural heterogenity'),
('3045', 'ith-endometrium'),
('1156', 'ith-ovary'),
('1156', 'intratumoural heterogenity'),
('2497', 'ith-endometrium'),
('2497', 'intratumoural heterogenity'),
('3844', 'cell culture'),
('2277', 'endometriosis'),
('827', 'tfri couer'),
('1347', 'ith-ovary'),
('1347', 'intratumoural heterogenity'),
('867', 'tfri couer'),
('867', 'intratumoural heterogenity'),
('867', 'ith-ovary'),
('867', 'xenograft'),
('1197', 'tfri couer'),
('1197', 'cell culture'),
('2077', 'precursor to prevention (tics)'),
('1056', 'cell culture'),
('1056', 'ith-ovary'),
('1056', 'intratumoural heterogenity'),
('3993', 'xenograft'),
('1851', 'precursor to prevention (tics)'),
('505', 'tfri couer'),
('505', 'ith-ovary'),
('505', 'intratumoural heterogenity'),
('2438', 'intratumoural heterogenity'),
('2438', 'ith-endometrium'),
('2440', 'endometriosis'),
('2462', 'endometriosis'),
('1187', 'tfri couer'),
('2403', 'endometriosis'),
('1546', 'ith-ovary'),
('1546', 'intratumoural heterogenity'),
('846', 'tfri couer'),
('2211', 'ith-endometrium'),
('2211', 'intratumoural heterogenity'),
('1631', 'xenograft'),
('1631', 'tfri couer'),
('584', 'ith-endometrium'),
('584', 'intratumoural heterogenity'),
('526', 'tfri couer'),
('526', 'ith-ovary'),
('526', 'intratumoural heterogenity'),
('860', 'tfri couer'),
('2129', 'tfri couer'),
('1523', 'precursor to prevention (tics)'),
('1888', 'intratumoural heterogenity'),
('1888', 'ith-ovary'),
('1888', 'tfri couer'),
('1440', 'tfri couer'),
('1973', 'endometriosis'),
('336', 'tfri couer'),
('336', 'ith-ovary'),
('336', 'intratumoural heterogenity'),
('1518', 'xenograft'),
('1280', 'precursor to prevention (tics)'),
('1795', 'ith-ovary'),
('1795', 'intratumoural heterogenity'),
('184', 'tfri couer'),
('1105', 'cell culture'),
('1111', 'cell culture'),
('1222', 'precursor to prevention (tics)'),
('361', 'ith-ovary'),
('361', 'intratumoural heterogenity'),
('1905', 'ovarian cancer diagnosis'),
('1905', 'ith-ovary'),
('1905', 'intratumoural heterogenity'),
('1905', 'endometriosis'),
('1905', 'tfri couer'),
('383', 'tfri couer'),
('383', 'ith-ovary'),
('383', 'intratumoural heterogenity'),
('1249', 'tfri couer'),
('1249', 'precursor to prevention (tics)'),
('812', 'xenograft'),
('155', 'tfri couer'),
('1436', 'precursor to prevention (tics)'),
('1830', 'precursor to prevention (tics)'),
('2024', 'intratumoural heterogenity'),
('2024', 'ith-endometrium'),
('710', 'ith-ovary'),
('710', 'xenograft'),
('710', 'intratumoural heterogenity'),
('1638', 'ith-ovary'),
('1638', 'intratumoural heterogenity'),
('652', 'tfri couer'),
('933', 'tcga'),
('933', 'tfri couer'),
('3001', 'endometriosis'),
('1505', 'ith-ovary'),
('1505', 'intratumoural heterogenity'),
('1505', 'tfri couer'),
('2202', 'ith-endometrium'),
('2202', 'intratumoural heterogenity'),
('2099', 'endometriosis'),
('730', 'ith-ovary'),
('730', 'intratumoural heterogenity'),
('2216', 'ith-endometrium'),
('2216', 'intratumoural heterogenity'),
('1042', 'ith-ovary'),
('1042', 'intratumoural heterogenity'),
('285', 'tfri couer'),
('285', 'intratumoural heterogenity'),
('285', 'ith-ovary'),
('1779', 'xenograft'),
('2183', 'cell culture'),
('2183', 'intratumoural heterogenity'),
('2183', 'ith-ovary'),
('2835', 'fimbrial scraping for culture'),
('2201', 'ith-ovary'),
('2201', 'intratumoural heterogenity'),
('2414', 'endometriosis'),
('1790', 'tfri couer'),
('619', 'tcga'),
('619', 'tfri couer'),
('619', 'ith-ovary'),
('619', 'intratumoural heterogenity'),
('2110', 'precursor to prevention (tics)'),
('2075', 'precursor to prevention (tics)'),
('1216', 'cell culture'),
('1995', 'endometriosis'),
('355', 'tfri couer'),
('355', 'ith-ovary'),
('355', 'intratumoural heterogenity'),
('1273', 'tfri couer');
INSERT INTO `ovcare_tmp_voa_to_study_file_maker_data` (`voa`, `study_title`) VALUES
('1273', 'ith-ovary'),
('1273', 'xenograft'),
('1273', 'intratumoural heterogenity'),
('217', 'tfri couer'),
('1927', 'tfri couer'),
('173', 'tfri couer'),
('173', 'intratumoural heterogenity'),
('173', 'ith-ovary'),
('1152', 'ith-endometrium'),
('1152', 'intratumoural heterogenity'),
('410', 'tfri couer'),
('903', 'ith-ovary'),
('903', 'intratumoural heterogenity'),
('375', 'ith-ovary'),
('375', 'intratumoural heterogenity'),
('1825', 'precursor to prevention (tics)'),
('1028', 'tfri couer'),
('1028', 'xenograft'),
('1781', 'intratumoural heterogenity'),
('1781', 'ith-ovary'),
('1781', 'tfri couer'),
('242', 'tfri couer'),
('242', 'ith-ovary'),
('242', 'intratumoural heterogenity'),
('120', 'tfri couer'),
('120', 'ith-ovary'),
('120', 'intratumoural heterogenity'),
('2091', 'endometriosis'),
('2286', 'intratumoural heterogenity'),
('2286', 'ith-endometrium'),
('172', 'tfri couer'),
('172', 'ith-ovary'),
('172', 'intratumoural heterogenity'),
('90', 'tfri couer'),
('90', 'ith-ovary'),
('90', 'intratumoural heterogenity'),
('974', 'tfri couer'),
('974', 'xenograft'),
('273', 'tfri couer'),
('273', 'intratumoural heterogenity'),
('273', 'ith-ovary'),
('1340', 'tfri couer'),
('1340', 'ith-ovary'),
('1340', 'intratumoural heterogenity'),
('1398', 'precursor to prevention (tics)'),
('2188', 'endometriosis'),
('1429', 'precursor to prevention (tics)'),
('1957', 'ovarian cancer diagnosis'),
('1957', 'ith-ovary'),
('1957', 'intratumoural heterogenity'),
('1413', 'precursor to prevention (tics)'),
('263', 'ith-ovary'),
('263', 'intratumoural heterogenity'),
('1412', 'precursor to prevention (tics)'),
('352', 'tfri couer'),
('352', 'ith-ovary'),
('352', 'intratumoural heterogenity'),
('667', 'tcga'),
('667', 'tfri couer'),
('667', 'ith-ovary'),
('667', 'intratumoural heterogenity'),
('1301', 'xenograft'),
('1301', 'cell culture'),
('72', 'tfri couer'),
('72', 'ith-ovary'),
('72', 'intratumoural heterogenity'),
('2065', 'precursor to prevention (tics)'),
('2065', 'ith-ovary'),
('2065', 'intratumoural heterogenity'),
('462', 'tfri couer'),
('462', 'ith-ovary'),
('462', 'intratumoural heterogenity'),
('1337', 'precursor to prevention (tics)'),
('1209', 'precursor to prevention (tics)'),
('1368', 'tcga'),
('203', 'tfri couer'),
('201', 'tfri couer'),
('1483', 'ith-ovary'),
('1483', 'intratumoural heterogenity'),
('1393', 'cell culture'),
('337', 'tfri couer'),
('337', 'ith-ovary'),
('337', 'intratumoural heterogenity'),
('175', 'tfri couer'),
('1288', 'ith-ovary'),
('1288', 'intratumoural heterogenity'),
('3693', 'ith-ovary'),
('3693', 'intratumoural heterogenity'),
('3246', 'intratumoural heterogenity'),
('3246', 'ith-ovary'),
('3275', 'intratumoural heterogenity'),
('3275', 'ith-endometrium'),
('3217', 'intratumoural heterogenity'),
('3217', 'ith-endometrium'),
('3664', 'ith-endometrium'),
('3664', 'intratumoural heterogenity'),
('4047', 'ith-endometrium'),
('4047', 'intratumoural heterogenity'),
('3629', 'intratumoural heterogenity'),
('3629', 'ith-endometrium'),
('3662', 'intratumoural heterogenity'),
('3662', 'ith-ovary'),
('3671', 'intratumoural heterogenity'),
('3671', 'ith-endometrium'),
('3209', 'intratumoural heterogenity'),
('3209', 'ith-ovary'),
('3222', 'ith-endometrium'),
('3222', 'intratumoural heterogenity'),
('3222', 'xenograft'),
('3225', 'xenograft'),
('3225', 'intratumoural heterogenity'),
('3225', 'ith-ovary'),
('3852', 'cell culture'),
('3670', 'intratumoural heterogenity'),
('3670', 'ith-endometrium'),
('3264', 'intratumoural heterogenity'),
('3264', 'ith-endometrium'),
('3093', 'intratumoural heterogenity'),
('3093', 'ith-endometrium'),
('3285', 'intratumoural heterogenity'),
('3285', 'ith-endometrium'),
('3285', 'xenograft'),
('3613', 'intratumoural heterogenity'),
('3613', 'ith-ovary'),
('3660', 'intratumoural heterogenity'),
('3660', 'ith-endometrium'),
('3087', 'intratumoural heterogenity'),
('3087', 'ith-endometrium'),
('3655', 'intratumoural heterogenity'),
('3655', 'ith-endometrium'),
('3627', 'intratumoural heterogenity'),
('3627', 'ith-ovary'),
('3295', 'intratumoural heterogenity'),
('3295', 'ith-endometrium'),
('3238', 'xenograft'),
('3238', 'ith-ovary'),
('3238', 'intratumoural heterogenity'),
('3284', 'xenograft'),
('3284', 'intratumoural heterogenity'),
('3284', 'ith-ovary'),
('3657', 'intratumoural heterogenity'),
('3657', 'ith-endometrium'),
('3072', 'cell culture'),
('3682', 'intratumoural heterogenity'),
('3682', 'ith-endometrium'),
('3682', 'xenograft'),
('3263', 'intratumoural heterogenity'),
('3263', 'ith-endometrium'),
('3255', 'intratumoural heterogenity'),
('3255', 'ith-ovary'),
('3625', 'xenograft'),
('3625', 'cell culture'),
('3625', 'intratumoural heterogenity'),
('3625', 'ith-ovary'),
('3593', 'xenograft'),
('3593', 'cell culture'),
('3632', 'ith-endometrium'),
('3632', 'intratumoural heterogenity'),
('3050', 'endometriosis'),
('3107', 'endometriosis'),
('3242', 'intratumoural heterogenity'),
('3242', 'ith-endometrium'),
('3242', 'xenograft'),
('3229', 'intratumoural heterogenity'),
('3229', 'ith-endometrium'),
('3071', 'intratumoural heterogenity'),
('3071', 'ith-ovary'),
('3088', 'intratumoural heterogenity'),
('3088', 'ith-endometrium'),
('3293', 'intratumoural heterogenity'),
('3293', 'ith-endometrium'),
('3677', 'intratumoural heterogenity'),
('3677', 'ith-endometrium'),
('3697', 'intratumoural heterogenity'),
('3697', 'ith-ovary'),
('2962', 'cell culture'),
('3448', 'cell culture'),
('3077', 'intratumoural heterogenity'),
('3077', 'ith-endometrium'),
('3070', 'cell culture'),
('3224', 'xenograft'),
('3611', 'ith-ovary'),
('3611', 'intratumoural heterogenity'),
('3290', 'intratumoural heterogenity'),
('3290', 'ith-ovary'),
('3601', 'intratumoural heterogenity'),
('3601', 'ith-endometrium'),
('3292', 'intratumoural heterogenity'),
('3292', 'ith-endometrium'),
('3623', 'intratumoural heterogenity'),
('3623', 'ith-endometrium'),
('3270', 'ith-endometrium'),
('3270', 'intratumoural heterogenity'),
('3240', 'intratumoural heterogenity'),
('3240', 'ith-endometrium'),
('3055', 'ith-ovary'),
('3055', 'intratumoural heterogenity'),
('3228', 'intratumoural heterogenity'),
('3228', 'ith-ovary'),
('3076', 'ith-endometrium'),
('3076', 'intratumoural heterogenity'),
('3204', 'intratumoural heterogenity'),
('3204', 'ith-endometrium'),
('3268', 'ith-ovary'),
('3268', 'intratumoural heterogenity'),
('3244', 'intratumoural heterogenity'),
('3244', 'ith-ovary'),
('3244', 'xenograft'),
('3244', 'cell culture'),
('3698', 'ith-ovary'),
('3698', 'intratumoural heterogenity'),
('3696', 'cell culture'),
('3696', 'intratumoural heterogenity'),
('3696', 'ith-ovary'),
('3910', 'intratumoural heterogenity'),
('3910', 'ith-endometrium'),
('3654', 'intratumoural heterogenity'),
('3654', 'ith-endometrium'),
('3659', 'intratumoural heterogenity'),
('3659', 'ith-endometrium'),
('3904', 'intratumoural heterogenity'),
('3904', 'ith-endometrium'),
('3042', 'ovarian cancer diagnosis'),
('3663', 'ith-ovary'),
('3663', 'intratumoural heterogenity'),
('3211', 'intratumoural heterogenity'),
('3211', 'ith-endometrium'),
('3327', 'cell culture'),
('3681', 'intratumoural heterogenity'),
('3681', 'ith-endometrium'),
('3690', 'intratumoural heterogenity'),
('3690', 'ith-endometrium'),
('3631', 'ith-endometrium'),
('3631', 'xenograft'),
('3631', 'intratumoural heterogenity'),
('3040', 'cell culture'),
('3647', 'xenograft'),
('3056', 'ith-endometrium'),
('3056', 'intratumoural heterogenity'),
('3060', 'cell culture'),
('3230', 'intratumoural heterogenity'),
('3230', 'ith-endometrium'),
('3049', 'ith-ovary'),
('3049', 'intratumoural heterogenity'),
('3282', 'intratumoural heterogenity'),
('3282', 'ith-ovary'),
('3235', 'xenograft'),
('3235', 'ith-endometrium'),
('3235', 'intratumoural heterogenity'),
('3277', 'intratumoural heterogenity'),
('3277', 'ith-endometrium'),
('3606', 'intratumoural heterogenity'),
('3606', 'ith-endometrium'),
('3216', 'intratumoural heterogenity'),
('3216', 'ith-ovary'),
('3667', 'xenograft'),
('3622', 'intratumoural heterogenity'),
('3622', 'ith-endometrium'),
('3612', 'intratumoural heterogenity'),
('3612', 'ith-ovary'),
('3089', 'intratumoural heterogenity'),
('3089', 'ith-endometrium'),
('3636', 'ith-endometrium'),
('3636', 'intratumoural heterogenity'),
('3092', 'intratumoural heterogenity'),
('3092', 'ith-endometrium'),
('3207', 'intratumoural heterogenity'),
('3207', 'ith-endometrium'),
('3250', 'intratumoural heterogenity'),
('3250', 'ith-endometrium'),
('3248', 'intratumoural heterogenity'),
('3248', 'ith-endometrium'),
('3615', 'intratumoural heterogenity'),
('3615', 'ith-ovary'),
('3254', 'intratumoural heterogenity'),
('3254', 'ith-ovary'),
('3917', 'ith-ovary'),
('3917', 'intratumoural heterogenity'),
('3621', 'intratumoural heterogenity'),
('3621', 'ith-endometrium'),
('3212', 'intratumoural heterogenity'),
('3212', 'ith-endometrium'),
('3286', 'intratumoural heterogenity'),
('3286', 'ith-ovary'),
('4214', 'cell culture'),
('3299', 'intratumoural heterogenity'),
('3299', 'ith-endometrium'),
('3026', 'ith-ovary'),
('3026', 'cell culture'),
('3026', 'intratumoural heterogenity'),
('3922', 'intratumoural heterogenity'),
('3922', 'ith-endometrium'),
('3666', 'intratumoural heterogenity'),
('3666', 'ith-endometrium'),
('3646', 'endometriosis'),
('3610', 'endometriosis'),
('3947', 'xenograft'),
('3094', 'intratumoural heterogenity'),
('3094', 'ith-endometrium'),
('3094', 'cell culture'),
('3094', 'xenograft'),
('3941', 'endometriosis'),
('3976', 'endometriosis'),
('3231', 'endometriosis'),
('3967', 'ith-ovary'),
('3967', 'intratumoural heterogenity'),
('3935', 'intratumoural heterogenity'),
('3935', 'ith-endometrium'),
('3962', 'intratumoural heterogenity'),
('3962', 'ith-endometrium'),
('3962', 'xenograft'),
('3968', 'ith-ovary'),
('3968', 'intratumoural heterogenity'),
('3969', 'xenograft'),
('3969', 'ith-endometrium'),
('3969', 'intratumoural heterogenity'),
('3952', 'intratumoural heterogenity'),
('3952', 'ith-endometrium'),
('3227', 'intratumoural heterogenity'),
('3227', 'ith-endometrium'),
('3058', 'endometriosis'),
('3980', 'ith-endometrium'),
('3980', 'intratumoural heterogenity'),
('3291', 'endometriosis'),
('3970', 'cell culture'),
('3965', 'endometriosis'),
('3090', 'intratumoural heterogenity'),
('3090', 'ith-ovary'),
('3241', 'endometriosis'),
('4101', 'cell culture'),
('3959', 'ith-endometrium'),
('3959', 'intratumoural heterogenity'),
('3999', 'xenograft'),
('3999', 'ith-endometrium'),
('3999', 'intratumoural heterogenity'),
('3288', 'endometriosis'),
('3981', 'cell culture'),
('3981', 'xenograft'),
('3981', 'ith-ovary'),
('3981', 'intratumoural heterogenity'),
('3691', 'intratumoural heterogenity'),
('3691', 'ith-ovary'),
('3915', 'intratumoural heterogenity'),
('3915', 'ith-ovary'),
('3641', 'endometriosis'),
('3943', 'intratumoural heterogenity'),
('3943', 'ith-ovary'),
('3289', 'endometriosis'),
('3975', 'xenograft'),
('3975', 'intratumoural heterogenity'),
('3975', 'ith-ovary'),
('3845', 'cell culture'),
('3992', 'ith-endometrium'),
('3992', 'intratumoural heterogenity'),
('3960', 'ith-endometrium'),
('3960', 'intratumoural heterogenity'),
('3226', 'intratumoural heterogenity'),
('3226', 'ith-endometrium'),
('3940', 'xenograft'),
('3637', 'endometriosis'),
('3649', 'endometriosis'),
('3052', 'endometriosis'),
('3930', 'intratumoural heterogenity'),
('3930', 'ith-endometrium'),
('3956', 'intratumoural heterogenity'),
('3956', 'ith-ovary'),
('3628', 'intratumoural heterogenity'),
('3628', 'ith-endometrium'),
('3905', 'intratumoural heterogenity'),
('3905', 'ith-endometrium'),
('3279', 'endometriosis'),
('3296', 'intratumoural heterogenity'),
('3296', 'ith-endometrium'),
('3296', 'cell culture'),
('3219', 'intratumoural heterogenity'),
('3219', 'ith-endometrium'),
('3219', 'xenograft'),
('3609', 'endometriosis'),
('3213', 'endometriosis'),
('3958', 'xenograft'),
('3256', 'endometriosis'),
('3979', 'endometriosis'),
('3630', 'endometriosis'),
('3035', 'ith-ovary'),
('3035', 'intratumoural heterogenity'),
('3223', 'endometriosis'),
('3086', 'endometriosis'),
('3243', 'endometriosis'),
('3925', 'endometriosis'),
('3078', 'endometriosis'),
('3937', 'cell culture'),
('3600', 'intratumoural heterogenity'),
('3600', 'ith-endometrium'),
('3692', 'intratumoural heterogenity'),
('3692', 'ith-ovary'),
('3989', 'ith-ovary'),
('3989', 'ith-endometrium'),
('3989', 'cell culture'),
('3989', 'xenograft'),
('3989', 'intratumoural heterogenity'),
('3281', 'endometriosis'),
('3994', 'cell culture'),
('3972', 'ith-endometrium'),
('3972', 'intratumoural heterogenity'),
('3095', 'endometriosis'),
('3208', 'endometriosis');

UPDATE ovcare_tmp_voa_to_study_file_maker_data SET study_title = 'TFRI COEUR' WHERE  study_title = 'tfri couer';
SELECT DISTINCT study_title AS '### MIGRATION ERROR ### Study of FileMakerPro unknown' FROM ovcare_tmp_voa_to_study_file_maker_data WHERE study_title NOT IN (SELECT title FROM study_summaries WHERE deleted <> 1);
SELECT DISTINCT voa AS '### MIGRATION ERROR ### VOA of FileMakerPro unknown' FROM ovcare_tmp_voa_to_study_file_maker_data WHERE voa NOT IN (SELECT ovcare_collection_voa_nbr FROM collections WHERE deleted <> 1 AND ovcare_collection_voa_nbr IS NOT NULL);

-- Add VOA#s defined in FileMaherPro app to the Annotation > study records

ALTER TABLE ovcare_ed_study_inclusions ADD COLUMN file_maker_pro_voa_nbrs varchar(250) DEFAULT "'Not a data of FileMakerPro app' Or 'Not defined in the FileMakerPro app'";
ALTER TABLE ovcare_ed_study_inclusions_revs ADD COLUMN file_maker_pro_voa_nbrs varchar(250) DEFAULT "'Not a data of FileMakerPro app' Or 'Not defined in the FileMakerPro app'";

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_study_inclusions', 'file_maker_pro_voa_nbrs', 'input',  NULL , '0', '', '', '', 'file maker app voa numbers', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='file_maker_pro_voa_nbrs' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='file maker app voa numbers' AND `language_tag`=''), '2', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) VALUEs ('file maker app voa numbers','File Maker App VOA#(s)');

DROP TABLE IF EXISTS ovcare_tmp_voas_to_event_master_id;
CREATE TABLE ovcare_tmp_voas_to_event_master_id (
  event_master_id int(11) DEFAULT NULL,
  voas varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO ovcare_tmp_voas_to_event_master_id (event_master_id, voas) 
(SELECT ed.event_master_id, GROUP_CONCAT(col.ovcare_collection_voa_nbr SEPARATOR ' & ')
FROM event_masters em, ovcare_ed_study_inclusions ed, collections col, study_summaries ss, ovcare_tmp_voa_to_study_file_maker_data tmp_data
WHERE em.deleted <> 1 AND col.deleted <> 1 AND ss.deleted <> 1
AND ss.id = ed.study_summary_id AND ed.event_master_id = em.id AND em.participant_id = col.participant_id
AND tmp_data.voa = col.ovcare_collection_voa_nbr AND ss.title = tmp_data.study_title
GROUP BY em.participant_id, ed.event_master_id, ss.title);

UPDATE ovcare_ed_study_inclusions ed, ovcare_tmp_voas_to_event_master_id tmp
SET ed.file_maker_pro_voa_nbrs = tmp.voas
WHERE ed.event_master_id = tmp.event_master_id;

UPDATE ovcare_ed_study_inclusions_revs ed, ovcare_tmp_voas_to_event_master_id tmp
SET ed.file_maker_pro_voa_nbrs = tmp.voas
WHERE ed.event_master_id = tmp.event_master_id;

INSERT INTO i18n (id,en) VALUES ('no new data supposed to be created', 'No new data supposed to be created');

-- Create collection study summary

ALTER TABLE collections ADD COLUMN ovcare_study_summary_id int(11) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN ovcare_study_summary_id int(11) DEFAULT NULL;
ALTER TABLE `collections`
  ADD CONSTRAINT `FK_collections_study_summaries` FOREIGN KEY (`ovcare_study_summary_id`) REFERENCES `study_summaries` (`id`);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'ovcare_study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'collection study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='ovcare_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection study / project' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='ovcare_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection study / project' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO i18n (id,en) VALUES ('collection study / project','Collection Study/Project');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'ovcare_study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'collection study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='ovcare_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection study / project' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES ('study/project is assigned to a collection',  
'Your data cannot be deleted! This study/project is linked to a collection.');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'ovcare_study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'collection study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='ovcare_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection study / project' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='ovcare_collection_voa_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'ovcare_study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'collection study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='ovcare_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection study / project' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='ovcare_collection_voa_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');

UPDATE structure_fields SET language_label = 'specific aliquot study / project' WHERE field = 'study_summary_id' AND model IN ('AliquotMaster','ViewAliquot');
INSERT INTO i18n (id,en) VALUES ('specific aliquot study / project','Study/Project (Aliquot Specific)');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='study_summary_id'), '1', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_column`='0', `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='ovcare_clinical_aliquot' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('ovcare_used_aliq_in_stock_details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='ovcare_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection study / project' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='children_aliquots_selection'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id'), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0');

-- COEUR aliquot clean up 

SELECT CONCAT(AliquotMaster.aliquot_label, ' (', AliquotMaster.barcode,')') AS "Aliquot with study set to 'TFRI-COEUR' but no aliquot internal uses with study = 'TFRI-COEUR' : To create."
FROM aliquot_masters AliquotMaster
INNER JOIN study_summaries AliquotStudySummary ON AliquotStudySummary.id = AliquotMaster.study_summary_id
WHERE AliquotMaster.deleted <> 1 
AND AliquotStudySummary.title = 'TFRI COEUR'
AND AliquotMaster.id NOT IN (
	SELECT AliquotInternalUses.aliquot_master_id 
	FROM aliquot_internal_uses AliquotInternalUses
	INNER JOIN study_summaries UseStudySummary ON UseStudySummary.id = AliquotInternalUses.study_summary_id
	WHERE AliquotInternalUses.deleted <> 1 AND UseStudySummary.title = 'TFRI COEUR'
);

SELECT CONCAT(AliquotMaster.aliquot_label, ' (', AliquotMaster.barcode,')') AS "Aliquot sent to TFRI-COEUR and 'In stock' value different than 'No' : To review and set 'In stock' value to 'No'."
FROM aliquot_internal_uses AliquotInternalUses
INNER JOIN aliquot_masters AliquotMaster ON AliquotInternalUses.aliquot_master_id = AliquotMaster.id
INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
INNER JOIN study_summaries UseStudySummary ON UseStudySummary.id = AliquotInternalUses.study_summary_id
WHERE AliquotInternalUses.deleted <> 1 AND AliquotMaster.deleted <> 1 
AND UseStudySummary.title = 'TFRI COEUR'
AND  AliquotMaster.in_stock != 'no';

SELECT CONCAT(AliquotMaster.aliquot_label, ' (', AliquotMaster.barcode,')') AS "Aliquot with study not set to 'TFRI-COEUR' but defined as shipped to 'TFRI-COEUR' in aliquot use : To correct.", AliquotStudySummary.title AS 'Aliquot Study'
FROM aliquot_masters AliquotMaster
INNER JOIN study_summaries AliquotStudySummary ON AliquotStudySummary.id = AliquotMaster.study_summary_id
WHERE AliquotMaster.deleted <> 1 
AND AliquotStudySummary.title != 'TFRI COEUR' AND AliquotStudySummary.title != '' AND AliquotStudySummary.title IS NOT NULL
AND AliquotMaster.id IN (
	SELECT AliquotInternalUses.aliquot_master_id 
	FROM aliquot_internal_uses AliquotInternalUses
	INNER JOIN study_summaries UseStudySummary ON UseStudySummary.id = AliquotInternalUses.study_summary_id
	WHERE AliquotInternalUses.deleted <> 1 AND UseStudySummary.title = 'TFRI COEUR'
);

SELECT CONCAT(count(*), ' aliquots updated') AS "Aliquot study set to 'TFRI COEUR' when an aliquot internal use study equals 'TFRI COEUR'"
FROM aliquot_masters AliquotMaster, aliquot_internal_uses AliquotInternalUses, study_summaries UseStudySummary
WHERE AliquotMaster.deleted <> 1 
AND AliquotInternalUses.aliquot_master_id = AliquotMaster.id
AND AliquotInternalUses.study_summary_id = UseStudySummary.id AND UseStudySummary.title = 'TFRI COEUR'
AND AliquotMaster.study_summary_id IS NULL;

UPDATE aliquot_masters AliquotMaster, aliquot_internal_uses AliquotInternalUses, study_summaries UseStudySummary
SET AliquotMaster.study_summary_id = (SELECT id FROM study_summaries WHERE title = 'TFRI COEUR'),
AliquotMaster.modified = @modified, 
AliquotMaster.modified_by = @modified_by
WHERE AliquotMaster.deleted <> 1 
AND AliquotInternalUses.aliquot_master_id = AliquotMaster.id
AND AliquotInternalUses.study_summary_id = UseStudySummary.id AND UseStudySummary.title = 'TFRI COEUR'
AND AliquotMaster.study_summary_id IS NULL;

SELECT DISTINCT Participant.participant_identifier AS "'Patient ID' linked to study (annotation) 'TFRI COEUR' with no aliquot flagged as sent to COEUR project. To validate,"
FROM participants Participant
INNER JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE Participant.deleted <> 1 AND EventMaster.deleted <> 1 AND StudySummary.title = 'TFRI COEUR'
AND EventMaster.participant_id NOT IN (
	SELECT Collection.participant_id
	FROM collections Collection
	INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id
	INNER JOIN aliquot_internal_uses AliquotInternalUses ON AliquotInternalUses.aliquot_master_id = AliquotMaster.id
	INNER JOIN study_summaries UseStudySummary ON UseStudySummary.id = AliquotInternalUses.study_summary_id
	WHERE AliquotMaster.deleted <> 1 
	AND UseStudySummary.title = 'TFRI COEUR'
);

-- xenograft sample check

SELECT DISTINCT Participant.participant_identifier AS "'Patient ID' linked to study (annotation) 'Xenograft' with no tissue sample flagged as 'Xenograft Collected'. To validate"
FROM participants Participant
INNER JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE Participant.deleted <> 1 AND EventMaster.deleted <> 1 AND StudySummary.title = 'Xenograft'
AND EventMaster.participant_id NOT IN (
	SELECT Collection.participant_id
	FROM collections Collection
	INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
	INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
	WHERE SampleMaster.deleted <> 1 
	AND SampleDetail.ovcare_xenograft_collected = 'y'
);

-- Cell Culture sample check

SELECT DISTINCT Participant.participant_identifier AS "'Patient ID' linked to study (annotation) 'Cell Culture' with no tissue sample flagged as 'Cell Culture Collected'. To validate"
FROM participants Participant
INNER JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE Participant.deleted <> 1 AND EventMaster.deleted <> 1 AND StudySummary.title = 'Cell Culture'
AND EventMaster.participant_id NOT IN (
	SELECT Collection.participant_id
	FROM collections Collection
	INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
	INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
	WHERE SampleMaster.deleted <> 1 
	AND SampleDetail.ovcare_cell_culture_collected = 'y'
);

-- TMA Block

SELECT 'What about study TMA block' AS '### TO VALIDATE WITH Sahra';

-- Set Collection study_summary_id based on FileMakerPro app and rules we defined with S. Padilla
-- ** 1 ** Set when 1 to 1 relationship exists

DROP TABLE IF EXISTS ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro;
CREATE TABLE ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro (
  event_master_id int(11) DEFAULT NULL,
  voa varchar(100) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  collection_id int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro (event_master_id, voa, study_summary_id, collection_id) 
(SELECT DISTINCT ed.event_master_id, col.ovcare_collection_voa_nbr, ed.study_summary_id, col.id
FROM event_masters em, ovcare_ed_study_inclusions ed, collections col, study_summaries ss, ovcare_tmp_voa_to_study_file_maker_data tmp_data
WHERE em.deleted <> 1 AND col.deleted <> 1 AND ss.deleted <> 1
AND ss.id = ed.study_summary_id AND ed.event_master_id = em.id AND em.participant_id = col.participant_id
AND tmp_data.voa = col.ovcare_collection_voa_nbr AND ss.title = tmp_data.study_title
AND ss.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture'));

SELECT CONCAT(count(*), ' collections updated') AS "Collection study set to FileMakerPro study when a VOA# is linked to only one study in the FileMakerPro app (Based on intial FileMakerPro dump)." 
FROM collections Collection, ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT collection_id FROM (
		SELECT count(*) AS nbr_of_collections, collection_id FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro GROUP BY collection_id
	) res WHERE res.nbr_of_collections = 1
)
AND Collection.id = TmpTable.collection_id;

UPDATE collections Collection, ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable
SET Collection.ovcare_study_summary_id = TmpTable.study_summary_id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT collection_id FROM (
		SELECT count(*) AS nbr_of_collections, collection_id FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro GROUP BY collection_id
	) res WHERE res.nbr_of_collections = 1
)
AND Collection.id = TmpTable.collection_id;

DELETE FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro WHERE collection_id IN (
	SELECT collection_id FROM (
		SELECT count(*) AS nbr_of_collections, collection_id FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro GROUP BY collection_id
	) res WHERE res.nbr_of_collections = 1
);

-- Set Collection study_summary_id based on FileMakerPro app and rules we defined with S. Padilla
-- ** 2 ** Set collection study to "Endometriosis" when participant study (annotation) is equal to "Endometriosis" and no value is equal to {"Intratumoural Heterogenity", "ITH-Ovary" or "ITH-Endometrium"}.

SELECT CONCAT(count(*), ' collections updated') AS "Collection study set to FileMakerPro study 'Endometriosis' when a VOA# is linked to an 'Endometriosis' study and no 'Intratumoural Heterogenity' or 'ITH-Ovary' or 'ITH-Endometrium' study in the FileMakerPro app (Based on intial FileMakerPro dump)." 
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
WHERE TmpTable.study_summary_id  = StudySummary.id
AND StudySummary.title IN ('Endometriosis')
AND TmpTable.collection_id NOT IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
);

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary, collections Collection
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT res.collection_id FROM (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('Endometriosis')
		AND TmpTable.collection_id NOT IN (
			SELECT TmpTable.collection_id
			FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
			WHERE TmpTable.study_summary_id  = StudySummary.id
			AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
		)
	) res
) 
AND Collection.id = TmpTable.collection_id
AND TmpTable.study_summary_id = StudySummary.id
AND StudySummary.title != 'Endometriosis';

UPDATE collections Collection, ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable
SET Collection.ovcare_study_summary_id = TmpTable.study_summary_id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('Endometriosis')
	AND TmpTable.collection_id NOT IN (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
	)
)
AND Collection.id = TmpTable.collection_id;

-- Set Collection study_summary_id based on FileMakerPro app and rules we defined with S. Padilla
-- ** 3 ** Set collection study to "Intratumoural Heterogenity" when participant study (annotation) is equal to "Intratumoural Heterogenity" and no value is equal to {"Endometriosis", "ITH-Ovary" or "ITH-Endometrium"}.

SELECT CONCAT(count(*), ' collections updated') AS "Collection study set to FileMakerPro study 'Intratumoural Heterogenity' when a VOA# is linked to an 'Intratumoural Heterogenity' study and no 'Endometriosis' or 'ITH-Ovary' or 'ITH-Endometrium' study in the FileMakerPro app (Based on intial FileMakerPro dump)." 
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
WHERE TmpTable.study_summary_id  = StudySummary.id
AND StudySummary.title IN ('Intratumoural Heterogenity')
AND TmpTable.collection_id NOT IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
);

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary, collections Collection
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT res.collection_id FROM (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('Intratumoural Heterogenity')
		AND TmpTable.collection_id NOT IN (
			SELECT TmpTable.collection_id
			FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
			WHERE TmpTable.study_summary_id  = StudySummary.id
			AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
		)
	) res
) 
AND Collection.id = TmpTable.collection_id
AND TmpTable.study_summary_id = StudySummary.id
AND StudySummary.title != 'Intratumoural Heterogenity';

UPDATE collections Collection, ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable
SET Collection.ovcare_study_summary_id = TmpTable.study_summary_id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('Intratumoural Heterogenity')
	AND TmpTable.collection_id NOT IN (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
	)
)
AND Collection.id = TmpTable.collection_id;

-- Set Collection study_summary_id based on FileMakerPro app and rules we defined with S. Padilla
-- ** 4 ** Set collection study to "ITH-Ovary" when participant study (annotation) is equal to "ITH-Ovary" and no value is equal to {"Endometriosis" or "ITH-Endometrium"}.

SELECT CONCAT(count(*), ' collections updated') AS "Collection study set to FileMakerPro study 'ITH-Ovary' when a VOA# is linked to an 'ITH-Ovary' study and no 'Endometriosis' or 'ITH-Endometrium' study in the FileMakerPro app (Based on intial FileMakerPro dump)." 
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
WHERE TmpTable.study_summary_id  = StudySummary.id
AND StudySummary.title IN ('ITH-Ovary')
AND TmpTable.collection_id NOT IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
);

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary, collections Collection
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT res.collection_id FROM (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('ITH-Ovary')
		AND TmpTable.collection_id NOT IN (
			SELECT TmpTable.collection_id
			FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
			WHERE TmpTable.study_summary_id  = StudySummary.id
			AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
		)
	) res
) 
AND Collection.id = TmpTable.collection_id
AND TmpTable.study_summary_id = StudySummary.id
AND StudySummary.title != 'ITH-Ovary';

UPDATE collections Collection, ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable
SET Collection.ovcare_study_summary_id = TmpTable.study_summary_id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('ITH-Ovary')
	AND TmpTable.collection_id NOT IN (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
	)
)
AND Collection.id = TmpTable.collection_id;

-- Set Collection study_summary_id based on FileMakerPro app and rules we defined with S. Padilla
-- ** 5 ** Set collection study to "ITH-Endometrium" when participant study (annotation) is equal to "ITH-Endometrium" and no value is equal to {"Endometriosis" or "ITH-Ovary"}.

SELECT CONCAT(count(*), ' collections updated') AS "Collection study set to FileMakerPro study 'ITH-Endometrium' when a VOA# is linked to an 'ITH-Endometrium' study and no 'Endometriosis' or 'ITH-Ovary' study in the FileMakerPro app (Based on intial FileMakerPro dump)." 
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
WHERE TmpTable.study_summary_id  = StudySummary.id
AND StudySummary.title IN ('ITH-Endometrium')
AND TmpTable.collection_id NOT IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
);

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary, collections Collection
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT res.collection_id FROM (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('ITH-Endometrium')
		AND TmpTable.collection_id NOT IN (
			SELECT TmpTable.collection_id
			FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
			WHERE TmpTable.study_summary_id  = StudySummary.id
			AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
		)
	) res
) 
AND Collection.id = TmpTable.collection_id
AND TmpTable.study_summary_id = StudySummary.id
AND StudySummary.title != 'ITH-Endometrium';

UPDATE collections Collection, ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable
SET Collection.ovcare_study_summary_id = TmpTable.study_summary_id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1 
AND Collection.ovcare_study_summary_id IS NULL
AND Collection.id IN (
	SELECT TmpTable.collection_id
	FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
	WHERE TmpTable.study_summary_id  = StudySummary.id
	AND StudySummary.title IN ('ITH-Endometrium')
	AND TmpTable.collection_id NOT IN (
		SELECT TmpTable.collection_id
		FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
		WHERE TmpTable.study_summary_id  = StudySummary.id
		AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
	)
)
AND Collection.id = TmpTable.collection_id;

-- Set Collection study_summary_id based on FileMakerPro app and rules we defined with S. Padilla
-- ** 5 ** Summary : Voa# unable to process

SELECT "VOA#s linked to studies in FileMakerPro app the process is unable to manage (see bewlo). Collection study has to be donne manually.";
SELECT GROUP_CONCAT(StudySummary.title SEPARATOR ' & ') AS "Studies", TmpTable.voa
FROM ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro TmpTable, study_summaries StudySummary
WHERE TmpTable.study_summary_id  = StudySummary.id
AND TmpTable.collection_id NOT IN (SELECT id FROM collections WHERE ovcare_study_summary_id IS NOT NULL AND ovcare_study_summary_id NOT LIKE '')
GROUP BY  TmpTable.voa;

-- Set the study of any tissue collections having no study defined by the previous rules (see above) and linked to a participant having only one tissue collection based on following sub-rules
-- ** 1 ** Set tissue collection study to the 'Annotation>Study' when only one participant 'Annotation>Study' 

ALTER TABLE participants ADD COLUMN tmp_participant_with_one_tissue_collection tinyint(1) DEFAULT '0';

UPDATE participants 
SET tmp_participant_with_one_tissue_collection = '1' 
WHERE id IN (
	SELECT participant_id
	FROM (
		SELECT res2.participant_id, count(*) AS tissue_col_nbr
		FROM (
			SELECT DISTINCT Collection.participant_id, Collection.id
			FROM collections Collection
			INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
			INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
			WHERE Collection.deleted <> 1
		) res2
		GROUP BY res2.participant_id
	) res WHERE res.tissue_col_nbr = 1
);

SELECT CONCAT(count(*), ' collections updated') AS "Tissue collection study set to the unique participant 'Annotation>Study' (different than 'TFRI COEUR','Xenograft','Cell Culture') for any participant having only one tissue collection"
FROM (
	SELECT DISTINCT Collection.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id IN (
		SELECT res.participant_id
		FROM (
			SELECT em.participant_id, count(*) AS nbr_part_with_one_study
			FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
			WHERE em.deleted <> 1 AND ss.deleted <> 1 
			AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
			AND ss.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture')
			GROUP BY em.participant_id
		) res WHERE res.nbr_part_with_one_study = 1
	) AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture')
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
) res;

UPDATE participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
SET Collection.ovcare_study_summary_id = StudySummary.id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Participant.deleted <> 1 
AND Participant.tmp_participant_with_one_tissue_collection = '1'
AND Participant.id IN (
	SELECT res.participant_id
	FROM (
		SELECT em.participant_id, count(*) AS nbr_part_with_one_study
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture')
		GROUP BY em.participant_id
	) res WHERE res.nbr_part_with_one_study = 1) 
AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture')
AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
AND Collection.ovcare_study_summary_id IS NULL;

-- Set the study of any tissue collections having no study defined by the previous rules (see above) and linked to a participant having only one tissue collection based on following sub-rules
-- ** 2- Set tissue collection study to the 'Annotation>Study' 'Endometriosis' when a participant 'Annotation>Study' is equal to 'Endometriosis' 
-- 			  and no participant 'Annotation>Study' is equal to 'Intratumoural Heterogenity', 'ITH-Ovary' or 'ITH-Endometrium' in ATiM 

SELECT CONCAT(count(*), ' collections updated') AS "Tissue collection study set to the participant 'Annotation>Study' 'Endometriosis' for any participant having only one tissue collection and no 'Annotation>Study' euqal to {'Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium'}"
FROM (
	SELECT DISTINCT Collection.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'Endometriosis'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
) res;

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary
WHERE EventMaster.deleted <> 1 AND EventMaster.participant_id IN (
	SELECT Participant.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'Endometriosis'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
)
AND EventMaster.id = EventDetail.event_master_id AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture');

UPDATE participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
SET Collection.ovcare_study_summary_id = StudySummary.id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Participant.deleted <> 1 
AND Participant.tmp_participant_with_one_tissue_collection = '1'
AND Participant.id NOT IN (
	SELECT em.participant_id
	FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
	WHERE em.deleted <> 1 AND ss.deleted <> 1 
	AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
	AND ss.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')) 
AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'Endometriosis'
AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
AND Collection.ovcare_study_summary_id IS NULL;

-- Set the study of any tissue collections having no study defined by the previous rules (see above) and linked to a participant having only one tissue collection based on following sub-rules
-- ** 3- Set tissue collection study to the 'Annotation>Study' 'Intratumoural Heterogenity' when a participant 'Annotation>Study' is equal to 'Intratumoural Heterogenity' 
-- 			  and no participant 'Annotation>Study' is equal to 'Endometriosis', 'ITH-Ovary' or 'ITH-Endometrium' in ATiM 

SELECT CONCAT(count(*), ' collections updated') AS "Tissue collection study set to the participant 'Annotation>Study' 'Intratumoural Heterogenity' for any participant having only one tissue collection and no 'Annotation>Study' euqal to {'Endometriosis','ITH-Ovary','ITH-Endometrium'}"
FROM (
	SELECT DISTINCT Collection.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'Intratumoural Heterogenity'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
) res;

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary
WHERE EventMaster.deleted <> 1 AND EventMaster.participant_id IN (
	SELECT Participant.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'Intratumoural Heterogenity'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
)
AND EventMaster.id = EventDetail.event_master_id AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture');

UPDATE participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
SET Collection.ovcare_study_summary_id = StudySummary.id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Participant.deleted <> 1 
AND Participant.tmp_participant_with_one_tissue_collection = '1'
AND Participant.id NOT IN (
	SELECT em.participant_id
	FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
	WHERE em.deleted <> 1 AND ss.deleted <> 1 
	AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
	AND ss.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')) 
AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'Intratumoural Heterogenity'
AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
AND Collection.ovcare_study_summary_id IS NULL;

-- Set the study of any tissue collections having no study defined by the previous rules (see above) and linked to a participant having only one tissue collection based on following sub-rules
-- ** 4- Set tissue collection study to the 'Annotation>Study' 'ITH-Ovary' when a participant 'Annotation>Study' is equal to 'ITH-Ovary' 
-- 			  and no participant 'Annotation>Study' is equal to 'Endometriosis' or 'ITH-Endometrium' in ATiM 

SELECT CONCAT(count(*), ' collections updated') AS "Tissue collection study set to the participant 'Annotation>Study' 'ITH-Ovary' for any participant having only one tissue collection and no 'Annotation>Study' euqal to {'Endometriosis','ITH-Endometrium'}"
FROM (
	SELECT DISTINCT Collection.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Endometriosis','ITH-Endometrium')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'ITH-Ovary'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
) res;

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary
WHERE EventMaster.deleted <> 1 AND EventMaster.participant_id IN (
	SELECT Participant.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Endometriosis','ITH-Endometrium')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'ITH-Ovary'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
)
AND EventMaster.id = EventDetail.event_master_id AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture');

UPDATE participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
SET Collection.ovcare_study_summary_id = StudySummary.id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Participant.deleted <> 1 
AND Participant.tmp_participant_with_one_tissue_collection = '1'
AND Participant.id NOT IN (
	SELECT em.participant_id
	FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
	WHERE em.deleted <> 1 AND ss.deleted <> 1 
	AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
	AND ss.title IN ('Endometriosis','ITH-Endometrium')) 
AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'ITH-Ovary'
AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
AND Collection.ovcare_study_summary_id IS NULL;

-- Set the study of any tissue collections having no study defined by the previous rules (see above) and linked to a participant having only one tissue collection based on following sub-rules
-- ** 5- Set tissue collection study to the 'Annotation>Study' 'ITH-Endometrium' when a participant 'Annotation>Study' is equal to 'ITH-Endometrium' 
-- 			  and no participant 'Annotation>Study' is equal to 'Endometriosis' or 'ITH-Ovary' in ATiM

SELECT CONCAT(count(*), ' collections updated') AS "Tissue collection study set to the participant 'Annotation>Study' 'ITH-Endometrium' for any participant having only one tissue collection and no 'Annotation>Study' euqal to {'Endometriosis', 'ITH-Ovary'}"
FROM (
	SELECT DISTINCT Collection.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Endometriosis', 'ITH-Ovary')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'ITH-Endometrium'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
) res;

SELECT DISTINCT StudySummary.title AS "Other studies assigned to participants of the previous updated collections (to validate)."
FROM event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary
WHERE EventMaster.deleted <> 1 AND EventMaster.participant_id IN (
	SELECT Participant.id
	FROM participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
	WHERE Participant.deleted <> 1 
	AND Participant.tmp_participant_with_one_tissue_collection = '1'
	AND Participant.id NOT IN (
		SELECT em.participant_id
		FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
		WHERE em.deleted <> 1 AND ss.deleted <> 1 
		AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
		AND ss.title IN ('Endometriosis', 'ITH-Ovary')) 
	AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
	AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'ITH-Endometrium'
	AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
	AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
	AND Collection.ovcare_study_summary_id IS NULL
)
AND EventMaster.id = EventDetail.event_master_id AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title NOT IN ('TFRI COEUR','Xenograft','Cell Culture');

UPDATE participants Participant, event_masters EventMaster, ovcare_ed_study_inclusions EventDetail, study_summaries StudySummary, collections Collection, sample_masters SampleMaster, sample_controls SampleControl
SET Collection.ovcare_study_summary_id = StudySummary.id,
Collection.modified = @modified, 
Collection.modified_by = @modified_by
WHERE Participant.deleted <> 1 
AND Participant.tmp_participant_with_one_tissue_collection = '1'
AND Participant.id NOT IN (
	SELECT em.participant_id
	FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
	WHERE em.deleted <> 1 AND ss.deleted <> 1 
	AND ed.event_master_id = em.id AND ed.study_summary_id = ss.id
	AND ss.title IN ('Endometriosis', 'ITH-Ovary')) 
AND EventMaster.deleted <> 1 AND EventMaster.participant_id = Participant.id AND EventMaster.id = EventDetail.event_master_id
AND EventDetail.study_summary_id = StudySummary.id AND StudySummary.title = 'ITH-Endometrium'
AND Participant.id = Collection.participant_id AND Collection.deleted <> 1
AND Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
AND SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'tissue'
AND Collection.ovcare_study_summary_id IS NULL;

-- Collection study results summary

SELECT res2.participant_id, res2.ovcare_collection_voa_nbr, res2.ovcare_collection_voa_nbr AS 'Collection VOA#', res2.study AS 'Collection Study', res2.sample AS 'Collection sample(s)', IFNULL(GROUP_CONCAT(res1.studies SEPARATOR ' + '),'') AS 'Participant-Annotation Studies'
FROM (
	SELECT Collection.participant_id, Collection.ovcare_collection_voa_nbr, IFNULL(StudySummary.title, '') as study, GROUP_CONCAT(CONCAT(SampleControl.sample_type, ' ', IFNULL(SampleDetail.tissue_source, '')) SEPARATOR ' & ') as sample
	FROM collections Collection
	LEFT JOIN study_summaries StudySummary ON StudySummary.id = Collection.ovcare_study_summary_id
	INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1
	INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id AND SampleControl.sample_category = 'specimen'
	LEFT JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
	WHERE Collection.deleted <> 1
	GROUP BY Collection.participant_id, Collection.ovcare_collection_voa_nbr, StudySummary.title
) res2 LEFT JOIN (
	SELECT em.participant_id, CONCAT(ss.title, IF(ed.file_maker_pro_voa_nbrs LIKE '%Not a data of FileMakerPro app%','[No FileMakerPro VOA#]', CONCAT(' [FileMakerPro VOA#(s) : ', ed.file_maker_pro_voa_nbrs, ']'))) AS studies
	FROM event_masters em, ovcare_ed_study_inclusions ed, study_summaries ss
	WHERE em.deleted <> 1 AND ss.id = ed.study_summary_id AND ed.event_master_id = em.id AND ss.title NOT IN ('TFRI COEUR', 'Xenograft', 'Cell Culture')
) res1 ON res1.participant_id = res2.participant_id 
GROUP BY res2.ovcare_collection_voa_nbr, res2.ovcare_collection_voa_nbr, res2.study, res2.sample
ORDER BY res2.participant_id, res2.ovcare_collection_voa_nbr;

-- Insert into revs tables

INSERT INTO collections_revs (id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, ovcare_collection_type, sop_master_id, collection_property,
collection_notes, participant_id, diagnosis_master_id, consent_master_id, treatment_master_id, event_master_id, ovcare_collection_voa_nbr, ovcare_study_summary_id,
modified_by, version_created)
(SELECT id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, ovcare_collection_type, sop_master_id, collection_property,
collection_notes, participant_id, diagnosis_master_id, consent_master_id, treatment_master_id, event_master_id, ovcare_collection_voa_nbr, ovcare_study_summary_id,
modified_by, modified FROM collections WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy,
storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, ovcare_clinical_aliquot, 
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy,
storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, ovcare_clinical_aliquot, 
modified_by, modified FROM aliquot_masters WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, 
cell_viability, hemolysis_signs, ovcare_storage_method, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, 
cell_viability, hemolysis_signs, ovcare_storage_method, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_blocks_revs (aliquot_master_id, block_type, patho_dpt_block_code, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, block_type, patho_dpt_block_code, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tissue_slides_revs (aliquot_master_id, immunochemistry, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, immunochemistry, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_tissue_slides ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tissue_cores_revs (aliquot_master_id, version_created) 
(SELECT aliquot_master_id, modified FROM aliquot_masters INNER JOIN ad_tissue_cores ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_whatman_papers_revs (aliquot_master_id, used_blood_volume, used_blood_volume_unit, version_created) 
(SELECT aliquot_master_id, used_blood_volume, used_blood_volume_unit, modified FROM aliquot_masters INNER JOIN ad_whatman_papers ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_cell_slides_revs (aliquot_master_id, immunochemistry, version_created) 
(SELECT aliquot_master_id, immunochemistry, modified FROM aliquot_masters INNER JOIN ad_cell_slides ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

-- Drop temporary table

DROP TABLE IF EXISTS ovcare_tmp_voa_to_study_file_maker_data;
DROP TABLE IF EXISTS ovcare_tmp_voas_to_event_master_id;
DROP TABLE IF EXISTS ovcare_tmp_voa_study_summary_id_based_on_filemaker_pro;
ALTER TABLE participants DROP COLUMN tmp_participant_with_one_tissue_collection;

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Change ovcare report to add collection study creatrion data
-- -------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_study_applied_to_list", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("collection", "collection"),
("aliquot", "aliquot"),
("use and/or event", "use and/or event"),
("collection and aliquot", "collection and aliquot"),
("aliquot and use/event", "aliquot and use/event");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_study_applied_to_list"), 
(SELECT id FROM structure_permissible_values WHERE value="collection" AND language_alias="collection"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_study_applied_to_list"), 
(SELECT id FROM structure_permissible_values WHERE value="aliquot" AND language_alias="aliquot"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_study_applied_to_list"), 
(SELECT id FROM structure_permissible_values WHERE value="use and/or event" AND language_alias="use and/or event"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_study_applied_to_list"), 
(SELECT id FROM structure_permissible_values WHERE value="collection and aliquot" AND language_alias="collection and aliquot"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_study_applied_to_list"), 
(SELECT id FROM structure_permissible_values WHERE value="aliquot and use/event" AND language_alias="aliquot and use/event"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_study_applied_to_list"), 
(SELECT id FROM structure_permissible_values WHERE value="all" AND language_alias="all"), "6", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'ovcare_study_applied_to', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_study_applied_to_list') , '0', '', '', '', '', 'linked to');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_study_applied_to' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_study_applied_to_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='linked to'), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_study_applied_to'), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_fields SET `language_label`='linked to',  `language_tag`='' WHERE model='0' AND tablename='' AND field='ovcare_study_applied_to' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_study_applied_to_list');
INSERT IGNORE INTO i18n (id,en) 
VALUES 
('studies','Studies'),
('no study selection','No study selection'),
('linked to', 'Linked To'),
('all records', 'All Records'),
("only one linked to value can be selected", "Only one 'Linked To' value can be selected"),
('collection and aliquot','Collection and Aliquot'),
('aliquot and use/event','Aliquot and Use/Event');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- New Specimen : Tampon & swap
-- -------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `ovcare_sd_spe_vaginal_swabs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  KEY `FK_sd_spe_swabs_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_ovcare_sd_spe_vaginal_swabs` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `ovcare_sd_spe_vaginal_swabs_revs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ovcare_sd_spe_vaginal_tampons` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `collected_tube_nbr` varchar(20) DEFAULT NULL,
  KEY `FK_sd_spe_tampons_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_ovcare_sd_spe_vaginal_tampons` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `ovcare_sd_spe_vaginal_tampons_revs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `collected_tube_nbr` varchar(20) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
 ('vaginal swab', 'specimen', 'ovcare_sd_spe_vaginal_swabs,specimens', 'ovcare_sd_spe_vaginal_swabs', '0', 'vaginal swab'),
 ('vaginal tampon', 'specimen', 'ovcare_sd_spe_vaginal_tampons,specimens', 'ovcare_sd_spe_vaginal_tampons', '0', 'vaginal tampon');
INSERT INTO `i18n` (`id`, `en`) 
VALUES
('vaginal swab', "Vaginal Swab"),
('vaginal tampon', "Vaginal Tampon");
INSERT INTO `parent_to_derivative_sample_controls` (parent_sample_control_id, `derivative_sample_control_id`, `flag_active`) 
VALUES 
(null, (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'vaginal swab'), '1'),
(null, (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'vaginal tampon'), '1'),
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'vaginal swab'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'dna'), '1'),
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'vaginal swab'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'rna'), '1'),
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'vaginal tampon'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'dna'), '1'),
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'vaginal tampon'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'rna'), '1');

INSERT INTO `structures` (`alias`) 
VALUES 
('ovcare_sd_spe_vaginal_swabs'),
('ovcare_sd_spe_vaginal_tampons');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_sd_spe_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '443', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_sd_spe_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '444', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_sd_spe_vaginal_tampons'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '443', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_sd_spe_vaginal_tampons'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '444', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_sd_spe_vaginal_tampons'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected tubes nbr' AND `language_tag`=''), '1', '442', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES 
((SELECT `id` FROM `sample_controls` where `sample_type` = 'vaginal swab'), 'tube', '', 'ad_spec_tubes_incl_ml_vol', 'ad_tubes', 'ml', '1', '', '0', 'vaginal swab|tube'),
((SELECT `id` FROM `sample_controls` where `sample_type` = 'vaginal tampon'), 'tube', '', 'ad_spec_tubes_incl_ml_vol', 'ad_tubes', 'ml', '1', '', '0', 'vaginal tampon|tube');
INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'vaginal swab|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'vaginal swab|tube'), 1, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'vaginal tampon|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'vaginal tampon|tube'), 1, NULL);

-- -------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------
INSERT IGNORE INTO i18n (id,en) 
VALUES 
("at least one '%s' path report is linked to this unknown diagnosis and can not be linked to this new type of diagnosis","At least one '%s' is linked to this unknown diagnosis and can not be linked to this new type of diagnosis");

-- -------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6xxx' WHERE version_number = '2.6.7';

