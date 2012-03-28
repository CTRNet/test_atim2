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

