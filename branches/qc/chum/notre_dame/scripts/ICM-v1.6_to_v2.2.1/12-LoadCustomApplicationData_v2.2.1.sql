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
SET mast.sample_label = CONCAT(mast.sample_label, ' -HEMO')
WHERE det.hemolysis_signs = 'yes'
AND mast.id = det.sample_master_id
AND mast.deleted != 1;

UPDATE sample_masters mast, sd_der_plasmas det
SET mast.sample_label = CONCAT(mast.sample_label, ' -HEMO')
WHERE det.hemolysis_signs = 'yes'
AND mast.id = det.sample_master_id
AND mast.deleted != 1;














