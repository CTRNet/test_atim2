-- ------------------------------------------------------------------
-- Add modification to tissue DNA report: add buffy coat
-- ------------------------------------------------------------------

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0'), '0', '0', '-', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0'), '0', '-1', '', '1', 'aliquot type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_params') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'Generated', '', 'qc_lady_qc_nano_drop_tested_rna_yield_ug', 'input',  NULL , '0', 'size=5', '', '', 'nano drop tested rna yield ug', ''), 
('Datamart', 'Generated', '', 'qc_lady_qc_bioanalyzer_tested_rna_yield_ug', 'input',  NULL , '0', 'size=5', '', '', 'bioanalyzer tested rna yield ug', ''), 
('Datamart', 'Generated', '', 'qc_lady_qc_nano_drop_tested_dna_yield_ug', 'input',  NULL , '0', 'size=5', '', '', 'nano drop tested dna yield ug', ''), 
('Datamart', 'Generated', '', 'qc_lady_qc_pico_green_tested_dna_yield_ug', 'input',  NULL , '0', 'size=5', '', '', 'pico green tested dna yield ug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_lady_qc_nano_drop_tested_rna_yield_ug'), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_lady_qc_bioanalyzer_tested_rna_yield_ug'), '0', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_lady_qc_nano_drop_tested_dna_yield_ug'), '0', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_lady_qc_pico_green_tested_dna_yield_ug'), '0', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'); 
UPDATE structure_formats SET `display_order`='44' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_report_tissue_dna_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_lady_qc_pico_green_tested_dna_yield_ug' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr)
VALUES
('concentration unit missing', 'Concentration unit missing', 'Unité concentration manquante'),
('nano drop tested rna yield ug','RNA Yield (ug/NanoDrop/Tested tube)','Quantité ARN (ug/NanoDrop/Tube testé)'),
('bioanalyzer tested rna yield ug','RNA Yield (ug/Bioanalyzer/Tested tube)','Quantité ARN (ug/Bioanalyzer/Tube testé)'),
('nano drop tested dna yield ug','DNA Yield (ug/NanoDrop/Tested tube)','Quantité ADN (ug/NanoDrop/Tube testé)'),
('pico green tested dna yield ug','DNA Yield (ug/PicoGreen/Tested tube)','Quantité ADN (ug/PicoGreen/Tube testé)');

REPLACE INTO i18n (id,en,fr) VALUES 
('qc_lady_report_tissue_dna_summary', 'DNA Report', 'Rapport - ADN'),
('qc_lady_report_tissue_dna_summary creation', 'Create ''DNA Report''', 'Créer ''Rapport - ADN'''),
('qc_lady_report_tissue_dna_summary_desc', 'Will list :<br>- Tissue type, tissue review then quality controls linked to a tissue DNA <br>- And quality controls of Buffy Coat DNA','Liste: <br>- le type du tissu, les résultats du rapport d''histologie et les contrôles de qualité attachés à un ADN de tissu <br>- et les contrôles de qualité attachés à un ADN de Buffy Coat.');

UPDATE datamart_reports
SET name = 'qc_lady_report_tissue_buffy_coat_dna_summary',
description = 'qc_lady_report_tissue_buffy_coat_dna_summary_desc',
form_alias_for_search = 'qc_lady_report_tissue_buffy_coat_dna_summary_params',
form_alias_for_results = 'qc_lady_report_tissue_buffy_coat_dna_summary_results',
function = 'createTissueAndBuffyCoatDNASummary'
WHERE 
name = 'qc_lady_report_tissue_dna_summary';
UPDATE structures SET alias = 'qc_lady_report_tissue_buffy_coat_dna_summary_params' WHERE alias = 'qc_lady_report_tissue_dna_summary_params';
UPDATE structures SET alias = 'qc_lady_report_tissue_buffy_coat_dna_summary_results' WHERE alias = 'qc_lady_report_tissue_dna_summary_results';

UPDATE i18n SET id = 'qc_lady_report_tissue_buffy_coat_dna_summary' WHERE id = 'qc_lady_report_tissue_dna_summary';
UPDATE i18n SET id = 'qc_lady_report_tissue_buffy_coat_dna_summary_desc' WHERE id = 'qc_lady_report_tissue_dna_summary_desc';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_buffy_coat_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_report_tissue_buffy_coat_dna_summary_results'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qc_lady_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE versions SET build_number = '5293' WHERE version_number = '2.5.4';
UPDATE versions SET permissions_regenerated = 0;
