
REPLACE INTO i18n (id,en,fr) 
VALUES 
('necrosis percentage','Necrosis &#37;','Nécrose &#37;'),
('necrosis percentage list','Necrosis &#37; (List)','Nécrose &#37; (liste)'),
('viability percentage','Viability &#37;','&#37; de viabilit');

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0  WHERE label = 'print barcodes';

UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET `type`='input', `setting`='size=10,class=range file' WHERE `field`='participant_identifier';
INSERT INTO structure_validations (structure_field_id,rule,language_message) VALUES ((SELECT id FROM structure_fields WHERE `field`='participant_identifier' AND `model`='Participant'), 'custom,/^[0-9]+$/', 'participant identifier should be a positive integer');
INSERT INTO i18n (id,en,fr) VALUES ('participant identifier should be a positive integer','Bank Nbr should be a positive integer','No Banque doit être un entier positif');

-- --------------------------------------------------------------------------------------------------------
-- VERSION
-- --------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '5714' WHERE version_number = '2.6.2';

-- 20140806 --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_tx_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings ADD COLUMN radiologic_rf_response varchar(50) DEFAULT NULL AFTER radiologic_tace_response;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs ADD COLUMN radiologic_rf_response varchar(50) DEFAULT NULL AFTER radiologic_tace_response;
UPDATE structure_value_domains SET domain_name = 'qc_nd_ed_radiologic_rf_tace_response', source = "StructurePermissibleValuesCustom::getCustomDropdown('Medical imagings : Radiologic TACE/RF response')" WHERE domain_name = 'qc_nd_ed_radiologic_tace_response';
UPDATE structure_permissible_values_custom_controls SET name = 'Medical imagings : Radiologic TACE/RF response' WHERE name = 'Medical imagings : Radiologic TACE response';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'radiologic_rf_response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ed_radiologic_rf_tace_response') , '0', '', '', '', 'radiologic rf response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='radiologic_rf_response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ed_radiologic_rf_tace_response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiologic rf response' AND `language_tag`=''), '2', '232', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('radiologic rf response','Radiologic RF Response');

UPDATE versions SET branch_build_number = '5844' WHERE version_number = '2.6.2';

-- 20141023 --------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  ADD COLUMN metastatic_lymph_nodes_number smallint(5) unsigned default null,
  ADD COLUMN metastatic_lymph_nodes_size decimal(6,2) default null;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  ADD COLUMN metastatic_lymph_nodes_number smallint(5) unsigned default null,
  ADD COLUMN metastatic_lymph_nodes_size decimal(6,2) default null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'metastatic_lymph_nodes_number', 'integer_positive',  NULL , '0', 'size=5', '', '', '', 'number'), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'metastatic_lymph_nodes_size', 'float_positive',  NULL , '0', 'size=5', '', '', '', 'size (cm)');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_pancreas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='metastatic_lymph_nodes_number' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='number'), '2', '107', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_pancreas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='metastatic_lymph_nodes_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='size (cm)'), '2', '107', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='tumors',  `language_tag`='number' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='pancreas_number' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='',  `language_tag`='size (cm)' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='pancreas_size' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en) VALUES ('tumors', 'Tumors');
  
UPDATE versions SET branch_build_number = '5925' WHERE version_number = '2.6.2';

-- 20141112 --------------------------------------------------------------------------------------------------------

ALTER TABLE ed_cap_report_gallbladders MODIFY distance_of_invasive_carcinoma_from_closest_margin_mm decimal(5,1) DEFAULT NULL;
ALTER TABLE ed_cap_report_gallbladders_Revs MODIFY distance_of_invasive_carcinoma_from_closest_margin_mm decimal(5,1) DEFAULT NULL;
 
UPDATE versions SET branch_build_number = '6055' WHERE version_number = '2.6.2';

-- 20150326 --------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`) VALUES
(null, 'qc_hb_report_ctrnet_catalogue_sorted_by_icd_name', 'qc_hb_report_ctrnet_catalog_sorted_by_icd_desc', 'ctrnet_calatogue_submission_file_params', 'qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd', 'index', 'ctrnetCatalogSubmissionFileSorteByIcdCodes', 1, NULL, 0, NULL, 0, NULL);
INSERT INTO i18n (id,en,fr) 
VALUES
('qc_hb_report_ctrnet_catalog_sorted_by_icd_desc','Data creation for CTRNet catalog sorted by ICD-10 Codes.','Génération des données pour le catalogue de CTRNet triées selon codes ICD-10.'),
('qc_hb_report_ctrnet_catalog_sorted_by_icd_name','CTRNet catalog (sorted by ICD-10 Codes)','Catalogue CTRNet (trié selon codes ICD-10)');
INSERT INTO structures(`alias`) VALUES ('qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_hb_primary_icd10_codes', 'input',  NULL , '0', '', '', '', 'primary icd 10 codes', ''), 
('Datamart', '0', '', 'qc_hb_dagnosis_icd10_codes', 'input',  NULL , '0', '', '', '', 'diagnosis icd 10 codes', ''), 
('Datamart', '0', '', 'qc_hb_ctrnet_classification', 'input',  NULL , '0', '', '', '', 'ctrnet classification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='sample_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='cases_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cases number' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='aliquots_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquots number' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_hb_primary_icd10_codes'), '0', '-1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_hb_dagnosis_icd10_codes'), '0', '-2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_hb_ctrnet_classification'), '0', '-3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES
('ctrnet classification','CTRNet - Classification','CTRNet - Classification'),
('diagnosis icd 10 codes','Collection Diagnosis ICD-10','ICD-10 du diagnostic de la collection'),
('primary icd 10 codes','Primary Diagnosis ICD-10','ICD-10 du diagnostic primaire');
UPDATE structure_fields SET field = 'qc_hb_collection_icd10_codes' WHERE field = 'qc_hb_dagnosis_icd10_codes';
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_hb_primary_icd10_codes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ctrnet_calatogue_submission_file_sorted_by_icd') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_hb_collection_icd10_codes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('more than %s','More than %s','Plus de %s');

UPDATE versions SET branch_build_number = '6134' WHERE version_number = '2.6.2';
  
-- 20150326 --------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) 
VALUES
('core_installname', 'Hepatopancreatobiliary', 'Hépatopancréatobiliaire');

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-53' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `language_label`='number cycles' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_num_cycles' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`) 
VALUES
(null, 'radio-embolization', 'hepatobiliary', 1, 'qc_hb_txd_radioembolizations', 'qc_hb_tx_radioembolizations', 0, (SELECT id FROM protocol_controls WHERE type = 'radiotherapy'), NULL, 'hepatobiliary|radio-embolization', 0, NULL);
CREATE TABLE IF NOT EXISTS `qc_hb_txd_radioembolizations` (
  `treatment_master_id` int(11) NOT NULL,
  `complication` varchar(50) NOT NULL DEFAULT '',
  `complication_date` date DEFAULT NULL,
  `complication_date_accuracy` char(1) NOT NULL DEFAULT '',
  `complication_treatment` varchar(150) DEFAULT NULL,
  `catheterism_type` varchar(50) DEFAULT NULL,
  `arterioportal_fistula` char(1) DEFAULT '',
  `pulmonary_shunt` char(1) DEFAULT '',
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_hb_txd_radioembolizations_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `complication` varchar(50) NOT NULL DEFAULT '',
  `complication_date` date DEFAULT NULL,
  `complication_date_accuracy` char(1) NOT NULL DEFAULT '',
  `complication_treatment` varchar(150) DEFAULT NULL,
  `catheterism_type` varchar(50) DEFAULT NULL,
  `arterioportal_fistula` char(1) DEFAULT '',
  `pulmonary_shunt` char(1) DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3042 ;
ALTER TABLE `qc_hb_txd_radioembolizations`
  ADD CONSTRAINT `qc_hb_txd_radioembolizations_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, source)
VALUES
('qc_hb_radioembolization_complications', "StructurePermissibleValuesCustom::getCustomDropdown('Radio-Embolization - Complication : Type')"),
('qc_hb_radioembolization_complication_treatments', "StructurePermissibleValuesCustom::getCustomDropdown('Radio-Embolization - Complication : Treatment')"),
('qc_hb_radioembolization_catheterism_types', "StructurePermissibleValuesCustom::getCustomDropdown('Radio-Embolization : Catheterism Type')");
INSERT INTO structures(`alias`) VALUES ('qc_hb_tx_radioembolizations');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_radioembolizations', 'complication', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_radioembolization_complications') , '0', '', '', '', 'complication type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_radioembolizations', 'complication_date', 'date',  NULL , '0', '', '', '', 'complication date', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_radioembolizations', 'complication_treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_radioembolization_complication_treatments') , '0', '', '', '', 'complication treatment', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_radioembolizations', 'catheterism_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_radioembolization_catheterism_types') , '0', '', '', '', 'catheterism type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_radioembolizations', 'arterioportal_fistula', 'yes_no',  NULL , '0', '', '', '', 'arterioportal fistula', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_radioembolizations', 'pulmonary_shunt', 'yes_no',  NULL , '0', '', '', '', 'pulmonary shunt', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_radioembolizations' AND `field`='complication' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_radioembolization_complications')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complication type' AND `language_tag`=''), '1', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_radioembolizations' AND `field`='complication_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complication date' AND `language_tag`=''), '1', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_radioembolizations' AND `field`='complication_treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_radioembolization_complication_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complication treatment' AND `language_tag`=''), '1', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '100', 'other', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_radioembolizations' AND `field`='catheterism_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_radioembolization_catheterism_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='catheterism type' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_radioembolizations' AND `field`='arterioportal_fistula' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='arterioportal fistula' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_radioembolizations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_radioembolizations' AND `field`='pulmonary_shunt' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pulmonary shunt' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Radio-Embolization - Complication : Type', 1, 50, 'clinical - treatment'),
('Radio-Embolization - Complication : Treatment', 1, 150, 'clinical - treatment'),
('Radio-Embolization : Catheterism Type', 1, 50, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radio-Embolization : Catheterism Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('total' ,'', '', '1', @control_id),
('selective' ,'', '', '1', @control_id),
('supraselective' ,'', '', '1', @control_id);
INSERT IGNORE INTO i18n (id,en)
VALUES 
('radio-embolization', 'Radio-Embolization'),
('catheterism type','Catheterism Type'),
('arterioportal fistula', 'Arterioportal Fistula'),
('pulmonary shunt', 'Pulmonary Shunt');

UPDATE versions SET branch_build_number = '6157' WHERE version_number = '2.6.2';

-- 20150430 --------------------------------------------------------------------------------------------------------

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'scores', 'charlson score', 1, 'qc_hb_ed_score_charlson', 'qc_hb_ed_score_charlsons', 0, 'scores|charlson score', 0, 0, 1);

INSERT IGNORE INTO i18n (id,en) VALUES ('charlson score', 'Charlson Score');
  
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_hb_scoring_age", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("<=40yrs", "<=40yrs");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_scoring_age"), (SELECT id FROM structure_permissible_values WHERE value="<=40yrs" AND language_alias="<=40yrs"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("41-50", "41-50");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_scoring_age"), (SELECT id FROM structure_permissible_values WHERE value="41-50" AND language_alias="41-50"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("51-60", "51-60");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_scoring_age"), (SELECT id FROM structure_permissible_values WHERE value="51-60" AND language_alias="51-60"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("61-70", "61-70");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_scoring_age"), (SELECT id FROM structure_permissible_values WHERE value="61-70" AND language_alias="61-70"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("71-80", "71-80");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_scoring_age"), (SELECT id FROM structure_permissible_values WHERE value="71-80" AND language_alias="71-80"), "", "1");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="2" WHERE svd.domain_name='qc_hb_scoring_age' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="41-50" AND language_alias="41-50");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='qc_hb_scoring_age' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="51-60" AND language_alias="51-60");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="4" WHERE svd.domain_name='qc_hb_scoring_age' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="61-70" AND language_alias="61-70");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="5" WHERE svd.domain_name='qc_hb_scoring_age' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="71-80" AND language_alias="71-80");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="1" WHERE svd.domain_name='qc_hb_scoring_age' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="<=40yrs" AND language_alias="<=40yrs");

INSERT INTO structures(`alias`) VALUES ('qc_hb_ed_score_charlson');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'scoring_age', 'select', (SELECT id FROM structure_value_domains WHERE domain_name= 'qc_hb_scoring_age') , '0', '', '', '', 'scoring age', ''),
				
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'myocardial_infarction', 'checkbox',  NULL , '0', '', '', '', 'myocardial infarction (history, not ecg changes only)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'congestive_heart_failure', 'checkbox',  NULL , '0', '', '', '', 'congestive heart failure', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'peripheral_disease', 'checkbox',  NULL , '0', '', '', '', 'peripheral disease (includes aortic aneurysm >= 6 cm', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'cerebrovascular_disease', 'checkbox',  NULL , '0', '', '', '', 'cerebrovascular disease: cva with mild or no residua or tia', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'dementia', 'checkbox',  NULL , '0', '', '', '', 'dementia', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'chronic_pulmonary_disease', 'checkbox',  NULL , '0', '', '', '', 'chronic pulmonary disease', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'connective_tissue_disease', 'checkbox',  NULL , '0', '', '', '', 'connective tissue disease', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'peptic_ulcer_disease', 'checkbox',  NULL , '0', '', '', '', 'peptic ulcer disease', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'mild_liver_disease', 'checkbox',  NULL , '0', '', '', '', 'mild liver disease (without portal hypertension, inlcudes chronic hepatitis)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'diabetes_without_end-organ_damage', 'checkbox',  NULL , '0', '', '', '', 'diabetes without end-organ damage (excludes diet-controlled alone)', ''),
				
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'hemiplegia', 'checkbox',  NULL , '0', '', '', '', 'hemiplegia', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'moderate_or_severe_renal_disease', 'checkbox',  NULL , '0', '', '', '', 'moderate or severe renal disease', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'diabetes_with_end-organ_damage', 'checkbox',  NULL , '0', '', '', '', 'diabetes with end-organ damage (retinopathy, neuropathy,nephropathy, or brittle diabetes)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'tumor_without_metastasis', 'checkbox',  NULL , '0', '', '', '', 'tumor without metastasis (exclude if > 5 y from diagnosis)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'leukemia', 'checkbox',  NULL , '0', '', '', '', 'leukemia(acute or chronic)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'lymphoma', 'checkbox',  NULL , '0', '', '', '', 'lymphoma', ''),
				
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'moderate_or_severe_liver_disease', 'checkbox',  NULL , '0', '', '', '', 'moderate or severe liver disease', ''),
				
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'metastatic_solid_tumor', 'checkbox',  NULL , '0', '', '', '', 'metastatic solid tumor', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'aids', 'checkbox',  NULL , '0', '', '', '', 'aids (not just hiv positive)', ''),
				
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_score_charlsons', 'result', 'integer_positive',  NULL , '0', '', '', '', 'result', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='scoring_age'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
		
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='myocardial_infarction'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='congestive_heart_failure'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='peripheral_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='cerebrovascular_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='dementia'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='chronic_pulmonary_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='connective_tissue_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='peptic_ulcer_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='mild_liver_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='diabetes_without_end-organ_damage'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
		
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='hemiplegia'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='moderate_or_severe_renal_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='diabetes_with_end-organ_damage'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='tumor_without_metastasis'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='leukemia'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='lymphoma'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
		
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='moderate_or_severe_liver_disease'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
		
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='metastatic_solid_tumor'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='aids'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
		
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_charlson'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_score_charlsons' AND `field`='result'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
   
CREATE TABLE IF NOT EXISTS `qc_hb_ed_score_charlsons` (
  `event_master_id` int(11) NOT NULL,
  
  `scoring_age` varchar(10),
		
  `myocardial_infarction` tinyint(1) DEFAULT '0',
  `congestive_heart_failure` tinyint(1) DEFAULT '0',
  `peripheral_disease` tinyint(1) DEFAULT '0',
  `cerebrovascular_disease` tinyint(1) DEFAULT '0',
  `dementia` tinyint(1) DEFAULT '0',
  `chronic_pulmonary_disease` tinyint(1) DEFAULT '0',
  `connective_tissue_disease` tinyint(1) DEFAULT '0',
  `peptic_ulcer_disease` tinyint(1) DEFAULT '0',
  `mild_liver_disease` tinyint(1) DEFAULT '0',
  `diabetes_without_end-organ_damage` tinyint(1) DEFAULT '0',
		
  `hemiplegia` tinyint(1) DEFAULT '0',
  `moderate_or_severe_renal_disease` tinyint(1) DEFAULT '0',
  `diabetes_with_end-organ_damage` tinyint(1) DEFAULT '0',
  `tumor_without_metastasis` tinyint(1) DEFAULT '0',
  `leukemia` tinyint(1) DEFAULT '0',
  `lymphoma` tinyint(1) DEFAULT '0',
		
  `moderate_or_severe_liver_disease` tinyint(1) DEFAULT '0',
		
  `metastatic_solid_tumor` tinyint(1) DEFAULT '0',
  `aids` tinyint(1) DEFAULT '0',
  
  `result` int(10) DEFAULT NULL,  
  
  `deleted_by` int(10) unsigned NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_hb_ed_score_charlsons_revs` (
  `event_master_id` int(11) NOT NULL,
  
  `scoring_age` varchar(10),
		
  `myocardial_infarction` tinyint(1) DEFAULT '0',
  `congestive_heart_failure` tinyint(1) DEFAULT '0',
  `peripheral_disease` tinyint(1) DEFAULT '0',
  `cerebrovascular_disease` tinyint(1) DEFAULT '0',
  `dementia` tinyint(1) DEFAULT '0',
  `chronic_pulmonary_disease` tinyint(1) DEFAULT '0',
  `connective_tissue_disease` tinyint(1) DEFAULT '0',
  `peptic_ulcer_disease` tinyint(1) DEFAULT '0',
  `mild_liver_disease` tinyint(1) DEFAULT '0',
  `diabetes_without_end-organ_damage` tinyint(1) DEFAULT '0',
		
  `hemiplegia` tinyint(1) DEFAULT '0',
  `moderate_or_severe_renal_disease` tinyint(1) DEFAULT '0',
  `diabetes_with_end-organ_damage` tinyint(1) DEFAULT '0',
  `tumor_without_metastasis` tinyint(1) DEFAULT '0',
  `leukemia` tinyint(1) DEFAULT '0',
  `lymphoma` tinyint(1) DEFAULT '0',
		
  `moderate_or_severe_liver_disease` tinyint(1) DEFAULT '0',
		
  `metastatic_solid_tumor` tinyint(1) DEFAULT '0',
  `aids` tinyint(1) DEFAULT '0',
  
  `result` int(10) DEFAULT NULL,  
  
  `deleted_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_hb_ed_score_charlsons`
  ADD CONSTRAINT `qc_hb_ed_score_charlson_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT IGNORE INTO i18n (id,en)
VALUES
('scoring age', 'Scoring age'),
				
('myocardial infarction (history, not ecg changes only)', 'Myocardial infarction (history, not ECG changes only)'),
('congestive heart failure', 'Congestive heart failure'),
('peripheral disease (includes aortic aneurysm >= 6 cm', 'Peripheral disease (includes aortic aneurysm >= 6 cm'),
('cerebrovascular disease: cva with mild or no residua or tia', 'Cerebrovascular disease: CVA with mild or no residua or TIA'),
('dementia', 'Dementia'),
('chronic pulmonary disease', 'Chronic pulmonary disease'),
('connective tissue disease', 'Connective tissue disease'),
('peptic ulcer disease', 'Peptic ulcer disease'),
('mild liver disease (without portal hypertension, inlcudes chronic hepatitis)', 'Mild liver disease (without portal hypertension, inlcudes chronic hepatitis)'),
('diabetes without end-organ damage (excludes diet-controlled alone)', 'Diabetes without end-organ damage (excludes diet-controlled alone)'),
				
('hemiplegia', 'Hemiplegia'),
('moderate or severe renal disease', 'Moderate or severe renal disease'),
('diabetes with end-organ damage (retinopathy, neuropathy,nephropathy, or brittle diabetes)', 'Diabetes with end-organ damage (retinopathy, neuropathy,nephropathy, or brittle diabetes)'),
('tumor without metastasis (exclude if > 5 y from diagnosis)', 'Tumor without metastasis (exclude if > 5 y from diagnosis)'),
('leukemia(acute or chronic)', 'Leukemia(acute or chronic)'),
('lymphoma', 'Lymphoma'),
				
('moderate or severe liver disease', 'Moderate or severe liver disease'),
				
('metastatic solid tumor', 'Metastatic solid tumor'),
('aids (not just hiv positive)', 'AIDS (not just HIV positive)');
  
UPDATE versions SET branch_build_number = '6178' WHERE version_number = '2.6.2';

-- 20150803 --------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `type`='float_positive' WHERE model='TreatmentDetail' AND tablename='qc_hb_txd_surgery_pancreas' AND field='wirsung_diameter' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE `qc_hb_txd_surgery_pancreas` MODIFY `wirsung_diameter` decimal(7,2) default null;
ALTER TABLE `qc_hb_txd_surgery_pancreas_revs` MODIFY `wirsung_diameter` decimal(7,2) default null;
UPDATE versions SET branch_build_number = '6238' WHERE version_number = '2.6.2';
