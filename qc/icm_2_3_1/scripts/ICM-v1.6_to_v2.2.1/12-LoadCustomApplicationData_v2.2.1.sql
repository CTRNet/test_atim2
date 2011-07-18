INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND model LIKE 'AliquotMaster'  ), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', 
'0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_aliquot_spent_times_defintion'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND  `field`='aliquot_label'  ), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO `aliquot_controls` (`id`, `aliquot_type`, `aliquot_type_precision`, `form_alias`, `detail_tablename`, `volume_unit`, `comment`, `display_order`, `databrowser_label`) VALUES
(1005, 'tube', 'blood cells', 'aliquot_masters,ad_der_blood_cell_tubes', 'ad_tubes', 'ml', 'Derivative tube requiring volume in ml specific for blood cells', 0, 'tube');
INSERT INTO sample_to_aliquot_controls 
(sample_control_id, aliquot_control_id, flag_active)
VALUES ((SELECT id FROM sample_controls WHERE sample_type IN ('blood cell')), '1005', '1' );
SET @id = LAST_INSERT_ID();
INSERT INTO realiquoting_controls (parent_sample_to_aliquot_control_id, child_sample_to_aliquot_control_id, flag_active)
VALUES (@id,@id,1);
INSERT INTO sample_to_aliquot_controls 
(sample_control_id, aliquot_control_id, flag_active)
VALUES ((SELECT id FROM sample_controls WHERE sample_type IN ('pbmc')), '1005', '1' );
SET @id = LAST_INSERT_ID();
INSERT INTO realiquoting_controls (parent_sample_to_aliquot_control_id, child_sample_to_aliquot_control_id, flag_active)
VALUES (@id,@id,1);
UPDATE sample_to_aliquot_controls SET flag_active = '0'
WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('pbmc', 'blood cell'))
AND aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE aliquot_type IN ('tube') AND form_alias LIKE '%ad_der_cell_tubes_incl_ml_vol%');

INSERT INTO structures(`alias`) VALUES ('ad_der_blood_cell_tubes');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_solution', 'tmp blood cell solution', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_blood_cell_storage_solution') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `language_label`='lot number' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `language_label`='current volume' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `language_label`='initial volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `language_help`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='creat_to_stor_spent_time_msg' AND `language_label`='creation to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `language_label`='cell count' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  AND `language_help`=''), '1', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `language_label`='aliquot concentration' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_cell_tubes' AND `field`='concentration_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_concentration_unit')  AND `language_help`=''), '1', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `language_help`=''), '1', '1201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`='generated_parent_sample_sample_type_help'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created (into the system)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_created'), '1', '2000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_stor_spent_time_msg' AND `language_label`='collection to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_solution' AND `language_label`='tmp blood cell solution' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_blood_cell_storage_solution')  AND `language_help`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

UPDATE aliquot_masters al, sample_masters samp
SET al.aliquot_control_id = 1005,  aliquot_type = 'tube'
WHERE samp.sample_type IN ('pbmc', 'blood cell')
AND al.aliquot_type = 'tube'
AND samp.id = al.sample_master_id;

UPDATE aliquot_masters al, sample_masters samp, sd_der_pbmcs detail, ad_tubes as tube
SET tube.tmp_storage_solution = detail.tmp_solution
WHERE samp.sample_type IN ('pbmc')
AND al.aliquot_type = 'tube'
AND al.aliquot_control_id = 1005
AND detail.sample_master_id = samp.id
AND samp.id = al.sample_master_id 
AND tube.aliquot_master_id = al.id;

UPDATE aliquot_masters al, sample_masters samp, sd_der_blood_cells detail, ad_tubes as tube
SET tube.tmp_storage_solution = detail.tmp_solution
WHERE samp.sample_type IN ('blood cell')
AND al.aliquot_type = 'tube'
AND al.aliquot_control_id = 1005
AND detail.sample_master_id = samp.id
AND samp.id = al.sample_master_id 
AND tube.aliquot_master_id = al.id;

ALTER TABLE sd_der_blood_cells
  DROP COLUMN `tmp_solution`;
ALTER TABLE sd_der_blood_cells_revs
  DROP COLUMN `tmp_solution`;
ALTER TABLE sd_der_pbmcs
  DROP COLUMN `tmp_solution`;
ALTER TABLE sd_der_pbmcs_revs
  DROP COLUMN `tmp_solution`;
  
DELETE FROM structure_formats
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'tmp_solution' AND tablename IN ('sd_der_pbmcs','sd_der_blood_cells'));
DELETE FROM structure_fields WHERE field = 'tmp_solution' AND tablename IN ('sd_der_pbmcs','sd_der_blood_cells');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_all_tubes_storage_solution', '', '', NULL);
SET @domain_id = LAST_INSERT_ID();
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, flag_active)
(SELECT DISTINCT @domain_id, val.id, '1' 
FROM structure_value_domains AS dom
INNER JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id = dom.id AND link.flag_active = '1'
INNER JOIN structure_permissible_values AS val ON val.id = link.structure_permissible_value_id 
WHERE dom.domain_name IN ('qc_tissue_storage_solution', 'qc_dna_rna_storage_solution', 'qc_cell_storage_solution', 'qc_blood_cell_storage_solution', 'qc_ascit_cell_storage_solution'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_all_tubes_storage_method', '', '', NULL);
SET @domain_id = LAST_INSERT_ID();
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, flag_active)
(SELECT DISTINCT @domain_id, val.id, '1' 
FROM structure_value_domains AS dom
INNER JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id = dom.id AND link.flag_active = '1'
INNER JOIN structure_permissible_values AS val ON val.id = link.structure_permissible_value_id 
WHERE dom.domain_name IN ('qc_tissue_storage_method', 'qc_ascit_cell_storage_method'));

UPDATE structure_fields SET structure_value_domain = (SELECT ID FROM structure_value_domains WHERE domain_name = 'qc_all_tubes_storage_solution'), field = 'tmp_tube_storage_solution'
WHERE field = 'storage_solution' AND model = 'ViewAliquot';
UPDATE structure_fields SET structure_value_domain = (SELECT ID FROM structure_value_domains WHERE domain_name = 'qc_all_tubes_storage_method'), field = 'tmp_tube_storage_method'
WHERE field = 'storage_method' AND model = 'ViewAliquot';

UPDATE structure_fields SET type = 'select' WHERE field IN ('tmp_tube_storage_method', 'tmp_tube_storage_solution');

INSERT INTO structures(`alias`) VALUES ('qc_report_bank_and_date_range_definition');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_report_bank_and_date_range_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='report_date_range' AND `language_label`='date range' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_report_bank_and_date_range_definition'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE datamart_reports SET form_alias_for_search = 'qc_report_bank_and_date_range_definition' 
WHERE name IN ('bank activity report', 'specimens collection/derivatives creation');

UPDATE datamart_reports SET flag_active= '0' WHERE name = 'bank activity report (per period)';

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('no date restriction', 'No date restriction' ,'Aucune restriction de date'),
('total', 'Total' ,'Total'),
('all obtained consents should have a signed date', 'All obtained consents should have a signed date!', 'Tous les consentements obtenus devraient avoir une date de signature!'),
('period','Period','Période'),
('PROCURE - consent report', 'PROCURE - Consent Report', 'PROCURE - Rapport des consentements'),
('PROCURE consent''s statistics', 'Statistics built on PROCURE consents.', 'Statistiques basées sur ​​les consentements PROCURE'),
('other contacts if deceased', 'Other Contacts if Deceased', 'Autre contacts si décès');

UPDATE structure_fields SET language_label = 'urine blood use for followup' WHERE language_label = 'annual followup' AND model = '0';	
UPDATE structure_fields SET language_label = 'contact for additional data' WHERE language_label = 'contact if info required' AND model = '0';	
UPDATE structure_fields SET language_label = 'contact for additional data' WHERE language_label = 'contact if discovery' AND model = '0';	
UPDATE structure_fields SET language_label = 'research other disease' WHERE language_label = 'study other diseases' AND model = '0';	
UPDATE structure_fields SET language_label = 'inform discovery on other disease' WHERE language_label = 'contact if discovery on other diseases' AND model = '0';	
	
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('date_from','action'));

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='0' AND tablename='' AND field='other_contacts_if_die' AND type='integer' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='0' AND tablename='' AND field='denied' AND type='integer' AND structure_value_domain  IS NULL );

UPDATE sample_masters mast, sd_der_serums det
SET mast.sample_label = CONCAT(mast.sample_label, ' HEMO')
WHERE det.hemolysis_signs = 'yes'
AND mast.id = det.sample_master_id
AND mast.deleted != 1;

UPDATE sample_masters mast, sd_der_plasmas det
SET mast.sample_label = CONCAT(mast.sample_label, ' HEMO')
WHERE det.hemolysis_signs = 'yes'
AND mast.id = det.sample_master_id
AND mast.deleted != 1;

UPDATE structure_fields SET setting = 'class=range' WHERE field = 'identifier_value' AND model In ('ViewSample','ViewCollection','ViewAliquot');

UPDATE structure_formats 
SET `flag_search`='0' ,`flag_index`='0' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('view_aliquot_joined_to_sample_and_collection' , 'view_sample_joined_to_collection')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field='participant_identifier');

DELETE FROM `versions`;
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.1', NOW(), '2961');

UPDATE structure_fields, structure_validations
SET structure_validations.rule = 'custom,/(^[0-9]+[-][0-9]*$)|(^[0-9]*$)/'
WHERE structure_fields.id = structure_validations.structure_field_id
AND structure_fields.field LIKE 'cell_passage_number' AND model LIKE 'SampleDetail';



INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'biological_material_use', 'checkbox',  NULL , '0', '', '', '', 'biological material use', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'use_of_blood', 'checkbox',  NULL , '0', '', '', '', 'use of blood', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'use_of_urine', 'checkbox',  NULL , '0', '', '', '', 'use of urine', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'research_other_disease', 'checkbox',  NULL , '0', '', '', '', 'research other disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biological material use' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of blood' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_urine' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of urine' AND `language_tag`=''), '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='research_other_disease' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='research other disease' AND `language_tag`=''), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');





INSERT INTO datamart_adhoc(title, description, plugin, model, form_alias_for_search, form_alias_for_results, form_links_for_results,
sql_query_for_results, flag_use_query_results) VALUES(
'manon collection query title', 
'manon collection query desc', 
'inventorymanagement', 
'Collection', 
'new_participants_manon', 
'new_participants_manon', 
'detail=>/inventorymanagement/collections/detail/%%Collection.id%%/',
'SELECT BankNumber.identifier_value AS bank_number, NdNumber.identifier_value AS nd_number, HdNumber.identifier_value AS hd_number,
SlNumber.identifier_value AS sl_number, Participant.last_name, Participant.first_name, RamqNumber.identifier_value as ramq_number,
Collection.collection_site AS collection_site, Collection.collection_datetime AS collection_datetime,
Collection.collection_datetime_accuracy AS collection_datetime_accuracy, Collection.id AS id
 FROM collections AS Collection
INNER JOIN clinical_collection_links AS ccl ON Collection.id=ccl.collection_id
INNER JOIN participants AS Participant ON ccl.participant_id=Participant.id
LEFT JOIN banks ON Collection.bank_id = banks.id
LEFT JOIN misc_identifiers AS BankNumber ON BankNumber.participant_id=Participant.id AND banks.misc_identifier_control_id=BankNumber.misc_identifier_control_id  
LEFT JOIN misc_identifiers AS NdNumber ON  NdNumber.participant_id=Participant.id AND NdNumber.misc_identifier_control_id=9
LEFT JOIN misc_identifiers AS HdNumber ON HdNumber.participant_id=Participant.id AND HdNumber.misc_identifier_control_id=8
LEFT JOIN misc_identifiers AS SlNumber ON SlNumber.participant_id=Participant.id AND SlNumber.misc_identifier_control_id=10
LEFT JOIN misc_identifiers as RamqNumber ON RamqNumber.participant_id=Participant.id AND RamqNumber.misc_identifier_control_id=7
WHERE Collection.collection_datetime >= "@@Collection.collection_datetime_start@@" 
 AND Collection.collection_datetime <= "@@Collection.collection_datetime_end@@" 
 AND Collection.collection_site = "@@Collection.collection_site@@"
 AND Collection.bank_id = "@@Collection.bank_id@@"',
'1'
);

INSERT INTO structures(`alias`) VALUES ('new_participants_manon');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', 'BankNumber', 'misc_identifiers', 'bank_number', 'input',  NULL , '0', '', '', '', 'bank #', ''), 
('', 'NdNumber', 'misc_identifiers', 'nd_number', 'input',  NULL , '0', '', '', '', 'notre-dame id', ''), 
('', 'HdNumber', 'misc_identifiers', 'hd_number', 'input',  NULL , '0', '', '', '', 'hotel-dieu id', ''), 
('', 'SlNumber', 'misc_identifiers', 'sl_number', 'input',  NULL , '0', '', '', '', 'saint-luc id', ''), 
('', 'RamqNumber', 'misc_identifiers', 'ramq_number', 'input',  NULL , '0', '', '', '', 'ramq #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='BankNumber' AND `tablename`='misc_identifiers' AND `field`='bank_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank #' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='NdNumber' AND `tablename`='misc_identifiers' AND `field`='nd_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notre-dame id' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='HdNumber' AND `tablename`='misc_identifiers' AND `field`='hd_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hotel-dieu id' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='SlNumber' AND `tablename`='misc_identifiers' AND `field`='sl_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='saint-luc id' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '0', '5', '', '1', 'last name', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '0', '6', '', '1', 'first name', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='RamqNumber' AND `tablename`='misc_identifiers' AND `field`='ramq_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ramq #' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection site' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '9', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime_accuracy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `flag_confidential`='0'), '0', '10', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='new_participants_manon'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0'), '0', '11', '', '1', 'bank', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

('manon collection query title', "New participants (for Manon)", "Nouveaux participants (pour Manon)"),
('manon collection query desc', "Displays collections with some of the linked participant data.", "Affiche les collections avec certaines informations des participants liés."),
INSERT INTO i18n (id, en, fr) VALUES
("bank #", "Bank #", "# banque"),
("notre-dame id", "Notre-Date ID", "# Dossier Notre-Dame"),
("hotel-dieu id", "Hotel-Dieu ID", "# Dossier Hotel-Dieu"),
("saint-luc id", "Saint-Luc ID", "# Dossier Saint-Luc"),
("ramq #", "RAMQ #", "# RAMQ"),
("new patients", "New patients", "Nouveaux patients"),
("normal tissues", "Normal tissues", "Tissus normaux"),
("tumoral tissues", "Tumoral tissues", "Tissus tumoraux"),
("benin tissues", "Benin tissus", "Tissus bénins"),
("blood collection", "Blood collection", "Prélèvement sanguin"),
("derivative products", "Derivative products", "Produits dérivés");


INSERT INTO datamart_reports (name, description, form_alias_for_search, form_alias_for_results, form_type_for_results, function, flag_active) VALUES
('banking activity', '', 'qc_nd_banking_activity', 'qc_nd_banking_activity', 'index', 'bankingNd', 1);

INSERT INTO structures(`alias`) VALUES ('qc_nd_banking_activity');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks'), '0', '', '', '', 'collection bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='report_date_range' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date range' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection bank' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'new_patients', 'integer_positive',  NULL , '0', '', '', '', 'new patients', ''), 
('Datamart', '0', '', 'normal_tissues', 'integer_positive',  NULL , '0', '', '', '', 'normal tissues', ''), 
('Datamart', '0', '', 'tumoral_tissues', 'integer_positive',  NULL , '0', '', '', '', 'tumoral tissues', ''), 
('Datamart', '0', '', 'benin_tissues', 'integer_positive',  NULL , '0', '', '', '', 'benin tissues', ''), 
('Datamart', '0', '', 'ascite', 'integer_positive',  NULL , '0', '', '', '', 'ascite', ''), 
('Datamart', '0', '', 'blood_collection', 'integer_positive',  NULL , '0', '', '', '', 'blood collection', ''), 
('Datamart', '0', '', 'serum', 'integer_positive',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'derivative_products', 'integer_positive',  NULL , '0', '', '', '', 'derivative products', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='new_patients' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='new patients' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='normal_tissues' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='normal tissues' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='tumoral_tissues' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumoral tissues' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='benin_tissues' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='benin tissues' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ascite' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ascite' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='blood_collection' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood collection' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='serum' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='serum' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_banking_activity'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='derivative_products' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='derivative products' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE collections SET bank_id = 5 WHERE bank_id IS NULL AND acquisition_label LIKE 'ORL-300%';
UPDATE collections_revs SET bank_id = 5 WHERE bank_id IS NULL AND acquisition_label LIKE 'ORL-300%';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
VALUES 
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='study_summary_id'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='1', `language_tag`='order_study' WHERE structure_id=(SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Order' AND tablename='orders' AND field='study_summary_id');

UPDATE orders SET processing_status = '' WHERE processing_status IS NULL;
UPDATE orders_revs SET processing_status = '' WHERE processing_status IS NULL;

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='aliquot_label' AND type='input' AND structure_value_domain  IS NULL );

UPDATE sample_masters AS samp, specimen_details AS spec
SET spec.supplier_dept = 'gynaecology/oncology clinic'
WHERE samp.id = spec.sample_master_id AND samp.sample_type = 'ascite'
AND spec.supplier_dept = 'family cancer center';

UPDATE sample_masters AS samp, specimen_details_revs AS spec
SET spec.supplier_dept = 'gynaecology/oncology clinic'
WHERE samp.id = spec.sample_master_id AND samp.sample_type = 'ascite'
AND spec.supplier_dept = 'family cancer center';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("isopentane + OCT", "isopentane + oct");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="block_type"),  (SELECT id FROM structure_permissible_values WHERE value="isopentane + OCT" AND language_alias="isopentane + oct"), "4", "1");



INSERT INTO lab_type_laterality_match (selected_type_code, selected_labo_laterality, sample_type_matching, tissue_source_matching, nature_matching, laterality_matching) VALUES
('AM', '', 'sample_type_matching', 'tonsil', 'sane', '');