
-- 2014-12-08

-- changed cart completed date to datetime

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_whatman_papers', 'procure_card_completed_datetime', 'datetime',  NULL , '0', '', '', '', 'card completed at', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='card completed at' AND `language_tag`=''), '1', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0', '0');
ALTER TABLE ad_whatman_papers ADD COLUMN procure_card_completed_datetime DATETIME DEFAULT NULL;
ALTER TABLE ad_whatman_papers_revs ADD COLUMN procure_card_completed_datetime DATETIME DEFAULT NULL;
ALTER TABLE ad_whatman_papers ADD COLUMN procure_card_completed_datetime_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE ad_whatman_papers_revs ADD COLUMN procure_card_completed_datetime_accuracy char(1) NOT NULL DEFAULT '';
SELECT 'TODO: Changed cart completed date to datetime. Validate before to go live.' AS '### MESSAGE ###'; 
SELECT 'Unable to set procure_card_completed_datetime' AS 'error', SpecimenDetail.sample_master_id, AliquotMaster.barcode, SpecimenDetail.reception_datetime, SpecimenDetail.reception_datetime_accuracy, AliquotDetail.procure_card_completed_at, AliquotDetail.procure_card_completed_datetime
FROM sample_masters SampleMaster
INNEr JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN ad_whatman_papers AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
WHERE AliquotMaster.deleted <> 1
AND AliquotDetail.procure_card_completed_at IS NOT NULL AND AliquotDetail.procure_card_completed_at NOT LIKE ''
AND (SpecimenDetail.reception_datetime_accuracy NOT IN ('c','i','h') OR SpecimenDetail.reception_datetime IS NULL OR SpecimenDetail.reception_datetime LIKE '');
UPDATE sample_masters SampleMaster, specimen_details SpecimenDetail, aliquot_masters AliquotMaster, ad_whatman_papers AliquotDetail
SET AliquotDetail.procure_card_completed_datetime = CONCAT(SUBSTR(SpecimenDetail.reception_datetime,1,10), ' ', AliquotDetail.procure_card_completed_at), AliquotDetail.procure_card_completed_datetime_accuracy = 'c'
WHERE SpecimenDetail.sample_master_id = SampleMaster.id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotDetail.aliquot_master_id = AliquotMaster.id
AND AliquotMaster.deleted <> 1
AND AliquotDetail.procure_card_completed_at IS NOT NULL AND AliquotDetail.procure_card_completed_at NOT LIKE ''
AND SpecimenDetail.reception_datetime_accuracy IN ('c','i','h') AND SpecimenDetail.reception_datetime IS NOT NULL AND SpecimenDetail.reception_datetime NOT LIKE '';
UPDATE sample_masters SampleMaster, specimen_details SpecimenDetail, aliquot_masters AliquotMaster, ad_whatman_papers_revs AliquotDetail
SET AliquotDetail.procure_card_completed_datetime = CONCAT(SUBSTR(SpecimenDetail.reception_datetime,1,10), ' ', AliquotDetail.procure_card_completed_at), AliquotDetail.procure_card_completed_datetime_accuracy = 'c'
WHERE SpecimenDetail.sample_master_id = SampleMaster.id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotDetail.aliquot_master_id = AliquotMaster.id
AND AliquotMaster.deleted <> 1
AND AliquotDetail.procure_card_completed_at IS NOT NULL AND AliquotDetail.procure_card_completed_at NOT LIKE ''
AND SpecimenDetail.reception_datetime_accuracy IN ('c','i','h') AND SpecimenDetail.reception_datetime IS NOT NULL AND SpecimenDetail.reception_datetime NOT LIKE '';
ALTER TABLE ad_whatman_papers DROP COLUMN procure_card_completed_at;
ALTER TABLE ad_whatman_papers_revs DROP COLUMN procure_card_completed_at;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_at' AND `language_label`='card completed at' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_at' AND `language_label`='card completed at' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_at' AND `language_label`='card completed at' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('no storage datetime has to be completed for whatman paper',"No 'Initial Storage Date' has to be completed for whatman paper",'Aucune date initiale d''entreposage ne doit être saisie pour un papier whatman');

-- Add field study to drugs....

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Drug', 'Drug', 'drugs', 'procure_study', 'yes_no',  NULL , '0', '', 'y', '', 'study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='drugs'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='procure_study' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='y' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE drugs ADD COLUMN procure_study char(1) default '';
ALTER TABLE drugs_revs ADD COLUMN procure_study char(1) default '';
UPDATE structure_fields SET  `default`='n' WHERE model='Drug' AND tablename='drugs' AND field='procure_study' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr) VALUES ('the type of a used drug can not be changed', 'The type of a already used drug can not be changed', 'Le type d''un médicament déjà utilisé ne peut être changé');
UPDATE structure_fields SET language_label = 'clinical study or experimental treatment' WHERE field = 'procure_study' AND model = 'Drug';
INSERT INTO i18n (id,en,fr) VALUES ('clinical study or experimental treatment', 'Clinical Study/Experimental Treatment', 'Étude clinique/Traitement expérimental');
ALTER TABLE drugs MODIFY procure_study tinyint(1) DEFAULT '0';
ALTER TABLE drugs_revs MODIFY procure_study tinyint(1) DEFAULT '0';
UPDATE structure_fields SET  `type`='checkbox',  `default`='' WHERE model='Drug' AND tablename='drugs' AND field='procure_study' AND `type`='yes_no' AND structure_value_domain  IS NULL ;

-- ADD bcr

ALTER TABLE procure_ed_clinical_followup_worksheet_aps ADD COLUMN biochemical_relapse char(1) default '';
ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs ADD COLUMN biochemical_relapse char(1) default '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_aps', 'biochemical_relapse', 'yes_no',  NULL , '0', '', '', '', 'biochemical relapse', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_aps'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='biochemical_relapse' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biochemical relapse' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('biochemical relapse','Biochemical Relapse','Récidive biochimique');  
UPDATE structure_fields SET  `language_help`='procure_ed_followup_worksheet_aps_help' WHERE model='EventDetail' AND tablename='procure_ed_clinical_followup_worksheet_aps' AND field='biochemical_relapse' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr) VALUES ('procure_ed_followup_worksheet_aps_help', 'Superior or equal to 0.2ng/ml', 'Supérieure ou égale à 0,2 ng / ml');

-- Add scan result

ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events ADD COLUMN results VARCHAR(50) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs ADD COLUMN results VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_followup_exam_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'Exam Results\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Exam Results', 'clinical - annotation', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Exam Results');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive','Positif',  '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative','Négatif',  '1', @control_id, NOW(), NOW(), 1, 1),
('suspicious','Suspicious','Suspect',  '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_results') , '0', '', '', '', 'result', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Add scan site

ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events ADD COLUMN sites VARCHAR(100) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs ADD COLUMN sites VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_followup_exam_sites', "StructurePermissibleValuesCustom::getCustomDropdown(\'Exam Sites\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Exam Sites', 'clinical - annotation', '100');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'sites', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_sites') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='sites' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' ), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='results' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_results') AND `flag_confidential`='0');

-- Remove curitherapy

SELECT 'Curietherapy to remove. Should be replaced by radio-brachy. See: ' , participant_id, treatment_master_id FROM treatment_masters INNER JOIN procure_txd_followup_worksheet_treatments ON id = treatment_master_id WHERE deleted <> 1 AND treatment_type = 'curietherapy';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup medical treatment types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value = 'curietherapy';

-- Add prostatectomy

SELECT 'WARNING: Added prostatectomy to treatment list' as '### MESSAGE ###';
-- SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup medical treatment types');
-- INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
-- VALUES
-- ('prostatectomy','Prostatectomy','Prostatectomie',  '1', @control_id, NOW(), NOW(), 1, 1);

-- Treatment type to remove

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='type (to remove)' WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field='type' AND `type`='input' AND structure_value_domain  IS NULL ;
SELECT 'WARNING: Treatment type (text field renamed to [type (to remove)]) has been replaced by field [type] (drop down list).' AS '### MESSAGE ###'
UNION ALL
SELECT 'WARNING: Previous field [type (to remove)] should be removed.' AS '### MESSAGE ###'
UNION ALL
SELECT 'TODO 1: Check data have been correclty migrated to [type] field and add clean up if required.' AS '### MESSAGE ###'
UNION ALL
SELECT 'TODO 2: Then remove old field renamed to [type (to remove)] running follwing queries (already included into custom_post263.2.sql).' AS '### MESSAGE ###'
UNION ALL
SELECT "DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');" AS '### MESSAGE ###'
UNION ALL
SELECT "DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));" AS '### MESSAGE ###'
UNION ALL
SELECT "DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');" AS '### MESSAGE ###'
UNION ALL
SELECT "ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;" AS '### MESSAGE ###'
UNION ALL
SELECT "ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;" AS '### MESSAGE ###';

-- Add radio precision

ALTER TABLE procure_txd_followup_worksheet_treatments ADD COLUMN radiotherpay_precision varchar(50) default null;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs ADD COLUMN radiotherpay_precision varchar(50) default null;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_radiotherpay_precision', "StructurePermissibleValuesCustom::getCustomDropdown(\'Radiotherapy Precisions\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Radiotherapy Precisions', 'clinical - treatment', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Precisions');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('brachy','Brachy','Curiethérapie',  '1', @control_id, NOW(), NOW(), 1, 1),
('curative','Curative','Curatif',  '1', @control_id, NOW(), NOW(), 1, 1),
('palliative','Palliative','Palliatif',  '1', @control_id, NOW(), NOW(), 1, 1),
('adjuvant','Adjuvant','Adjuvant',  '1', @control_id, NOW(), NOW(), 1, 1),
('salvage','Salvage','De rattrapage',  '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'radiotherpay_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_radiotherpay_precision') , '0', '', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='radiotherpay_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_radiotherpay_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('no precision has to be associated to the selected treatment type', 'No precision has to be associated to the selected treatment type','Aucun précision ne doit être défini pour le type du traitement sélectionné');

-- Add other cancer treatment 

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`) 
VALUES
(null, 'other tumor treatment', '', 1, 'procure_txd_other_tumor_treatments', 'procure_txd_other_tumor_treatment', 0, NULL, NULL, 'other tumor treatment', 0, NULL);
INSERT INTO i18n (id,en,fr) VALUES ('other tumor treatment', 'Other Tumor Treatment', 'Traitement d''autres tumeurs');
CREATE TABLE IF NOT EXISTS `procure_txd_other_tumor_treatments` (
  `treatment_master_id` int(11) NOT NULL,
  `treatment_type` varchar(50) DEFAULT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `procure_txd_other_tumor_treatments_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `treatment_type` varchar(50) DEFAULT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;
ALTER TABLE `procure_txd_other_tumor_treatments`
  ADD CONSTRAINT `procure_txd_other_tumor_treatments_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('procure_txd_other_tumor_treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_other_tumor_sites', "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Tumor Sites\')"),
('procure_other_tumor_treatment_types', "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Tumor Treatment Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Other Tumor Sites', 'clinical - treatment', '100'),
('Other Tumor Treatment Types', 'clinical - treatment', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Tumor Treatment Types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('chemotherapy','Chemotherapy','Chimiothérapie',  '1', @control_id, NOW(), NOW(), 1, 1),
('radiotherapy','Radiotherapy','Radiothérapie',  '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Tumor Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('breast - breast', 'Breast - Breast', 'Sein - Sein',  '1', @control_id, NOW(), NOW(), 1, 1),
('central nervous system - brain', 'Central Nervous System - Brain', 'Système Nerveux Central - Cerveau',  '1', @control_id, NOW(), NOW(), 1, 1),
('central nervous system - other central nervous system', 'Central Nervous System - Other', 'Système Nerveux Central - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('central nervous system - spinal cord', 'Central Nervous System - Spinal Cord', 'Système Nerveux Central - Moelle épinière',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - anal', 'Digestive - Anal', 'Appareil digestif - Anal',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - appendix', 'Digestive - Appendix', 'Appareil digestif - Appendice',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - bile ducts', 'Digestive - Bile Ducts', 'Appareil digestif - Voies biliaires',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - colorectal', 'Digestive - Colorectal', 'Appareil digestif - Colorectal',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - esophageal', 'Digestive - Esophageal', 'Appareil digestif - Oesophage',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - gallbladder', 'Digestive - Gallbladder', 'Appareil digestif - Vésicule biliaire',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - liver', 'Digestive - Liver', 'Appareil digestif - Foie',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - other digestive', 'Digestive - Other', 'Appareil digestif - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - pancreas', 'Digestive - Pancreas', 'Appareil digestif - Pancréas',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - small intestine', 'Digestive - Small Intestine', 'Appareil digestif - Intestin grêle',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - stomach', 'Digestive - Stomach', 'Appareil digestif - Estomac',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - cervical', 'Female Genital - Cervical', 'Appareil génital féminin - Col de l''utérus',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - endometrium', 'Female Genital - Endometrium', 'Appareil génital féminin - Endomètre',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - fallopian tube', 'Female Genital - Fallopian Tube', 'Appareil génital féminin - Trompes de Fallope',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - gestational trophoblastic neoplasia', 'Female Genital - Gestational Trophoblastic Neoplasia', 'Appareil génital féminin - Néoplasie trophoblastique gestationnelle',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - other female genital', 'Female Genital - Other', 'Appareil génital féminin - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - ovary', 'Female Genital - Ovary', 'Appareil génital féminin - Ovaire',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - peritoneal', 'Female Genital - Peritoneal', 'Appareil génital féminin - Péritoine',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - uterine', 'Female Genital - Uterine', 'Appareil génital féminin - Utérin',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - vagina', 'Female Genital - Vagina', 'Appareil génital féminin - Vagin',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - vulva', 'Female Genital - Vulva', 'Appareil génital féminin - Vulve',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - hodgkin''s disease', 'Haematological - Hodgkin''s Disease', 'Hématologie - Maladie de Hodgkin',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - leukemia', 'Haematological - Leukemia', 'Hématologie - Leucémie',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - lymphoma', 'Haematological - Lymphoma', 'Hématologie - Lymphome',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - non-hodgkin''s lymphomas', 'Haematological - Non-Hodgkin''s Lymphomas', 'Hématologie - Lymphome Non-hodgkinien',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - other haematological', 'Haematological - Other', 'Hématologie - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - larynx', 'Head & Neck - Larynx', 'Tête & Cou - Larynx',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - lip and oral cavity', 'Head & Neck - Lip and Oral Cavity', 'Tête & Cou - Lèvres et la cavité buccale',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - nasal cavity and sinuses', 'Head & Neck - Nasal Cavity and Sinuses', 'Tête & Cou - Cavité nasale et sinus',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - other head & neck', 'Head & Neck - Other', 'Tête & Cou - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - pharynx', 'Head & Neck - Pharynx', 'Tête & Cou - Pharynx',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - salivary glands', 'Head & Neck - Salivary Glands', 'Tête & Cou - Glandes salivaires',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - thyroid', 'Head & Neck - Thyroid', 'Tête & Cou - Thyroïde',  '1', @control_id, NOW(), NOW(), 1, 1),
('male genital - other male genital', 'Male Genital - Other', 'Appareil génital masculin - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('male genital - penis', 'Male Genital - Penis', 'Appareil génital masculin - Pénis',  '1', @control_id, NOW(), NOW(), 1, 1),
('male genital - testis', 'Male Genital - Testis', 'Appareil génital masculin - Testicule',  '1', @control_id, NOW(), NOW(), 1, 1),
('musculoskeletal sites - bone', 'Musculoskeletal Sites - Bone', 'Sites musculo-squelettiques - Os',  '1', @control_id, NOW(), NOW(), 1, 1),
('musculoskeletal sites - other bone', 'Musculoskeletal Sites - Other Bone', 'Sites musculo-squelettiques - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('musculoskeletal sites - soft tissue sarcoma', 'Musculoskeletal Sites - Soft Tissue Sarcoma', 'Sites musculo-squelettiques - Sarcome des tissus mous',  '1', @control_id, NOW(), NOW(), 1, 1),
('ophthalmic - eye', 'Ophthalmic - Eye', 'Ophtalmique - Yeux',  '1', @control_id, NOW(), NOW(), 1, 1),
('ophthalmic - other eye', 'Ophthalmic - Other', 'Ophtalmique - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('other - gross metastatic disease', 'Other - Gross Metastatic Disease', '',  '1', @control_id, NOW(), NOW(), 1, 1),
('other - primary unknown', 'Other - Primary Unknown', 'Autre - Primaire inconnu',  '1', @control_id, NOW(), NOW(), 1, 1),
('skin - melanoma', 'Skin - Melanoma', 'Peau - Melanome',  '1', @control_id, NOW(), NOW(), 1, 1),
('skin - non melanomas', 'Skin - Non Melanomas', 'Peau - Autre que Melanome',  '1', @control_id, NOW(), NOW(), 1, 1),
('skin - other skin', 'Skin - Other', 'Peau - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('thoracic - lung', 'Thoracic - Lung', 'Thoracique - Poumon',  '1', @control_id, NOW(), NOW(), 1, 1),
('thoracic - mesothelioma', 'Thoracic - Mesothelioma', 'Thoracique - Mésothéliome',  '1', @control_id, NOW(), NOW(), 1, 1),
('thoracic - other thoracic', 'Thoracic - Other', 'Thoracique - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - bladder', 'Urinary Tract - Bladder', 'Voies urinaires - Vessie',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - kidney', 'Urinary Tract - Kidney', 'Voies urinaires - Rein',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - other urinary tract', 'Urinary Tract - Other', 'Voies urinaires - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - renal pelvis and ureter', 'Urinary Tract - Renal Pelvis and Ureter', 'Voies urinaires - Bassinet et uretère',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - urethra', 'Urinary Tract - Urethra', 'Voies urinaires - Urètre',  '1', @control_id, NOW(), NOW(), 1, 1);		
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_other_tumor_treatments', 'treatment_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_treatment_types') , '0', '', '', '', 'treatment type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_other_tumor_treatments', 'tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_other_tumor_treatments' AND `field`='treatment_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_treatment_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment type' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_other_tumor_treatments' AND `field`='tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='procure_txd_other_tumor_treatments' AND `field`='treatment_type'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `tablename`='procure_txd_other_tumor_treatments' AND `field`='tumor_site'), 'notEmpty');

-- Change recurrence site to check boxes

ALTER TABLE procure_ed_clinical_followup_worksheets
  ADD COLUMN clinical_recurrence_site_bones tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_liver tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_lungs tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_others tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_clinical_followup_worksheets_revs
  ADD COLUMN clinical_recurrence_site_bones tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_liver tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_lungs tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_others tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_bones', 'checkbox',  NULL , '0', '', '', '', 'bone metastasis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_liver', 'checkbox',  NULL , '0', '', '', '', 'liver metastasis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_lungs', 'checkbox',  NULL , '0', '', '', '', 'lung metastasis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_others', 'checkbox',  NULL , '0', '', '', '', 'other metastasis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_bones' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bone metastasis' AND `language_tag`=''), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_liver' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver metastasis' AND `language_tag`=''), '1', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_lungs' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lung metastasis' AND `language_tag`=''), '1', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_others' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other metastasis' AND `language_tag`=''), '1', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_bones = '1' WHERE clinical_recurrence_site = 'bones';
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_liver = '1' WHERE clinical_recurrence_site = 'liver';
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_lungs = '1' WHERE clinical_recurrence_site = 'lungs';
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_others = '1' WHERE clinical_recurrence_site = 'others';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_bones = '1' WHERE clinical_recurrence_site = 'bones';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_liver = '1' WHERE clinical_recurrence_site = 'liver';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_lungs = '1' WHERE clinical_recurrence_site = 'lungs';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_others = '1' WHERE clinical_recurrence_site = 'others';
ALTER TABLE procure_ed_clinical_followup_worksheets DROP COLUMN clinical_recurrence_site;
ALTER TABLE procure_ed_clinical_followup_worksheets_revs DROP COLUMN clinical_recurrence_site;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `language_label`='site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `language_label`='site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `language_label`='site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup clinical recurrence sites');
SELECT value AS 'procure followup clinical recurrence sites unmigrated: to clean up' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value not IN ('liver', 'lungs', 'bones', 'others');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'procure followup clinical recurrence sites';
INSERT INTO i18n (id,en,fr) 
VALUES
('liver metastasis', 'Liver Metastasis', 'Métastase au Foie'),
('lung metastasis', 'Lung Metastasis', 'Métastase aux poumons'),
('bone metastasis', 'Bone Metastasis', 'Métastase aux os'),
('other metastasis', 'Others Metastasis', 'Autres métastases');

-- Change follow-up report

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_02_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_03_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_04_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_05_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_06_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_07_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_08_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_09_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_10_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_11_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_12_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_13_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_14_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_15_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_16_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_17_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_18_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_19_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', '');	
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_first_collection_date'), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_first_collection_date'), '0', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_first_collection_date'), '0', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_first_collection_date'), '0', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_first_collection_date'), '0', '51', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_first_collection_date'), '0', '61', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_first_collection_date'), '0', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_first_collection_date'), '0', '81', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_first_collection_date'), '0', '91', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_first_collection_date'), '0', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_first_collection_date'), '0', '111', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_first_collection_date'), '0', '121', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_first_collection_date'), '0', '131', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_first_collection_date'), '0', '141', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_first_collection_date'), '0', '151', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_first_collection_date'), '0', '161', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_first_collection_date'), '0', '171', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_first_collection_date'), '0', '181', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_first_collection_date'), '0', '191', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET language_label = 'first collection date' WHERE field like 'procure_%_first_collection_date';
INSERT INTO i18n (id,en,fr) VALUES ('first collection date', '1st Col. Date', '1ere date de col.');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_followup_worksheets_nbr', 'input',  NULL , '0', 'size=3', '', '', 'follow-up worksheets number', ''), 
('Datamart', '0', '', 'procure_number_of_visit_with_collection', 'input',  NULL , '0', 'size=3', '', '', 'number of visit with collection', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_followup_worksheets_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='follow-up worksheets number' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_number_of_visit_with_collection' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='number of visit with collection' AND `language_tag`=''), '0', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_label`='follow-up worksheet' WHERE model='0' AND tablename='' AND field='procure_followup_worksheets_nbr' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='collection' WHERE model='0' AND tablename='' AND field='procure_number_of_visit_with_collection' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='number of visits with' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_followup_worksheets_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('follow-up worksheet', 'Follow-up Worksheet', 'Fiche de suivi'),
('number of visits with', 'Nbr. of Visits With', 'Nbr. de visites avec');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_prostatectomy_date', 'date',  NULL , '0', '', '', '', 'prostatectomy', ''), 
('Datamart', '0', '', 'procure_last_collection_date', 'date',  NULL , '0', '', '', '', 'last collection date', ''), 
('Datamart', '0', '', 'procure_time_from_last_collection_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time from last collection (months)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_prostatectomy_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prostatectomy' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_last_collection_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last collection date' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_time_from_last_collection_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='time from last collection (months)' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_label`='date' WHERE model='0' AND tablename='' AND field='procure_last_collection_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='last collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_last_collection_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('last collection','Last Collection','Dernière collection'),('time from last collection (months)','Time past (months)','Temps écoulé (mois)');

-- version

UPDATE versions SET branch_build_number = '5981' WHERE version_number = '2.6.3';
