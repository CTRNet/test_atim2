UPDATE structure_fields SET tablename='sd_spe_bloods' WHERE model='SampleDetail' AND field='blood_type';
UPDATE structure_fields SET tablename='sd_spe_tissues' WHERE model='SampleDetail' AND field='tissue_laterality';
UPDATE structure_fields SET tablename='sd_spe_urines' WHERE model='SampleDetail' AND field='urine_aspect';
UPDATE structure_fields SET tablename='sd_spe_urines' WHERE model='SampleDetail' AND field='pellet_signs';
UPDATE structure_fields SET tablename='sd_der_cell_cultures' WHERE model='SampleDetail' AND field='culture_status';
UPDATE structure_fields SET tablename='sd_der_cell_cultures' WHERE model='SampleDetail' AND field='cell_passage_number';

UPDATE structure_fields SET tablename='ad_blocks' WHERE model='AliquotDetail' AND field='block_type';
UPDATE structure_fields SET tablename='ad_cell_slides' WHERE model='AliquotDetail' AND field='immunochemistry' AND tablename='';
UPDATE structure_fields SET tablename='ad_tubes' WHERE model='AliquotDetail' AND field='concentration';
UPDATE structure_fields SET tablename='ad_tubes' WHERE model='AliquotDetail' AND field='cell_count';
UPDATE structure_fields SET tablename='ad_tubes' WHERE model='AliquotDetail' AND field='cell_count_unit';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_gel_matrices', 'cell_count', 'float_positive',  NULL , '0', 'size=5', '', '', 'cell count', ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_gel_matrices', 'cell_count_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') , '0', '', '', '', '', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_gel_matrices' AND `field`='cell_count' AND `type`='float_positive' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cell_count' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_gel_matrices' AND `field`='cell_count_unit' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cell_count_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tissue_slides', 'immunochemistry', 'input',  NULL , '0', 'size=30', '', '', 'immunochemistry code', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tissue_slides' AND `field`='immunochemistry' AND `type`='input' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_cell_slides' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


/*
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='tumor_size_greatest_dimension';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='additional_dimension_a';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='additional_dimension_b';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='tumor_size_cannot_be_determined';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='tumour_grade';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='tumour_grade_specify';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_tnm_descriptor_m';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_tnm_descriptor_r';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_tnm_descriptor_y';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_tstage';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_nstage';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_nstage_nbr_node_examined';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_nstage_nbr_node_involved';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_mstage';
UPDATE structure_fields SET tablename='ed_' WHERE model='EventDetail' AND field='path_mstage_metastasis_site_specify';
*/