-- NPTTB Custom v0.11
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.11', '');

-- ======================================================================================
-- Eventum ID: 3104 CNS Location Checkboxes
-- ======================================================================================	

-- Table update
ALTER TABLE `sd_spe_tissues` 
ADD COLUMN `npttb_cns_frontal` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_location`,
ADD COLUMN `npttb_cns_parietal` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_frontal`,
ADD COLUMN `npttb_cns_temporal` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_parietal`,
ADD COLUMN `npttb_cns_occipital` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_temporal`,
ADD COLUMN `npttb_cns_thalamus_basal_ganglia` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_occipital`,
ADD COLUMN `npttb_cns_brainstem` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_thalamus_basal_ganglia`,
ADD COLUMN `npttb_cns_cerebellum` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_brainstem`,
ADD COLUMN `npttb_cns_spinal_cord` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_cerebellum`,
ADD COLUMN `npttb_cns_spinal_root` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_spinal_cord`,
ADD COLUMN `npttb_cns_peripheral_nerve` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_spinal_root`,
ADD COLUMN `npttb_cns_optic_pathway` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_peripheral_nerve`,
ADD COLUMN `npttb_cns_pituitary` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_optic_pathway`,
ADD COLUMN `npttb_cns_auditory_pathway` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_pituitary`,
ADD COLUMN `npttb_cns_other` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_auditory_pathway`,
ADD COLUMN `npttb_cns_other_specify` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_other`;

ALTER TABLE `sd_spe_tissues_revs` 
ADD COLUMN `npttb_cns_frontal` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_location`,
ADD COLUMN `npttb_cns_parietal` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_frontal`,
ADD COLUMN `npttb_cns_temporal` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_parietal`,
ADD COLUMN `npttb_cns_occipital` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_temporal`,
ADD COLUMN `npttb_cns_thalamus_basal_ganglia` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_occipital`,
ADD COLUMN `npttb_cns_brainstem` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_thalamus_basal_ganglia`,
ADD COLUMN `npttb_cns_cerebellum` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_brainstem`,
ADD COLUMN `npttb_cns_spinal_cord` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_cerebellum`,
ADD COLUMN `npttb_cns_spinal_root` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_spinal_cord`,
ADD COLUMN `npttb_cns_peripheral_nerve` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_spinal_root`,
ADD COLUMN `npttb_cns_optic_pathway` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_peripheral_nerve`,
ADD COLUMN `npttb_cns_pituitary` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_optic_pathway`,
ADD COLUMN `npttb_cns_auditory_pathway` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_pituitary`,
ADD COLUMN `npttb_cns_other` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_auditory_pathway`,
ADD COLUMN `npttb_cns_other_specify` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_cns_other`;

ALTER TABLE `sd_spe_tissues` 
DROP COLUMN `npttb_cns_location`;

ALTER TABLE `sd_spe_tissues_revs` 
DROP COLUMN `npttb_cns_location`;

-- Remove current CNS field
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_location' AND `language_label`='npttb cns location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cns_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_location' AND `language_label`='npttb cns location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cns_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_location' AND `language_label`='npttb cns location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cns_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Add new checkboxes
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_auditory_pathway', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns auditory pathway', ''),
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_brainstem', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns brainstem', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_cerebellum', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns cerebellum', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_frontal', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns frontal', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_occipital', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns occipital', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_optic_pathway', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns optic pathway', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_parietal', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns parietal', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_peripheral_nerve', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns peripheral nerve', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_pituitary', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns pituitary', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_spinal_cord', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns spinal cord', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_spinal_root', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns spinal root', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_thalamus_basal_ganglia', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns thalamus basal ganglia', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_other', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'npttb cns other', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_other_specify', 'input',  NULL , '0', 'size=20', '', '', '', 'npttb cns other specify');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_auditory_pathway' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns auditory pathway' AND `language_tag`=''), '1', '450', 'npttb cns location', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_brainstem' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns brainstem' AND `language_tag`=''), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_cerebellum' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns cerebellum' AND `language_tag`=''), '1', '455', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_frontal' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns frontal' AND `language_tag`=''), '1', '456', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_occipital' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns occipital' AND `language_tag`=''), '1', '457', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_optic_pathway' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns optic pathway' AND `language_tag`=''), '1', '458', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_parietal' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns parietal' AND `language_tag`=''), '1', '465', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_peripheral_nerve' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns peripheral nerve' AND `language_tag`=''), '1', '466', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_pituitary' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns pituitary' AND `language_tag`=''), '1', '467', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_spinal_cord' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns spinal cord' AND `language_tag`=''), '1', '470', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_spinal_root' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns spinal root' AND `language_tag`=''), '1', '471', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_thalamus_basal_ganglia' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns thalamus basal ganglia' AND `language_tag`=''), '1', '472', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_other' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns other' AND `language_tag`=''), '1', '473', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_other_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='npttb cns other specify'), '1', '474', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('npttb cns auditory pathway', 'Auditory Pathway', ''),
 ('npttb cns brainstem', 'Brainstem', ''),
 ('npttb cns cerebellum', 'Cerebellum', ''),
 ('npttb cns frontal', 'Frontal', ''),
 ('npttb cns occipital', 'Occipital', ''),
 ('npttb cns optic pathway', 'Optic Pathway', ''),
 ('npttb cns parietal', 'Parietal', ''),
 ('npttb cns peripheral nerve', 'Peripheral Nerve', ''),
 ('npttb cns pituitary', 'Pituitary', ''),
 ('npttb cns spinal cord', 'Spinal Cord', ''),
 ('npttb cns spinal root', 'Spinal Root', ''),
 ('npttb cns thalamus basal ganglia', 'Thalamus and Basal Ganglia', ''), 
 ('npttb cns other', 'Other CNS Location', ''), 
 ('npttb cns other specify', 'If Other CNS, Specify', '');   
 
-- ======================================================================================
-- Eventum ID: 3103 QC Score
-- ======================================================================================     

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='quality_control_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="260/280" AND language_alias="260/280");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='quality_control_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="28/18" AND language_alias="28/18");


-- ======================================================================================
-- Eventum ID: 2616 Sample Code Format
-- ======================================================================================

ALTER TABLE `sample_masters` 
ADD COLUMN `npttb_sample_code` VARCHAR(45) NULL AFTER `sample_code`;

ALTER TABLE `sample_masters_revs` 
ADD COLUMN `npttb_sample_code` VARCHAR(45) NULL AFTER `sample_code`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'npttb_sample_code', 'input',  NULL , '0', 'size=20', '', '', 'npttb sample code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='npttb_sample_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='npttb sample code' AND `language_tag`=''), '1', '1000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('npttb sample code', 'NPTTB Sample Code', '');


-- ======================================================================================
-- Eventum ID: 3105 Storage Updates 
-- ======================================================================================

-- Remove all demo boxes
DELETE FROM `storage_controls` WHERE `storage_type`='demo1';
DELETE FROM `storage_controls` WHERE `storage_type`='demo2';
DELETE FROM `storage_controls` WHERE `storage_type`='demo3';
DELETE FROM `storage_controls` WHERE `storage_type`='demo4';
DELETE FROM `storage_controls` WHERE `storage_type`='demo5';
DELETE FROM `storage_controls` WHERE `storage_type`='demo6';
DELETE FROM `storage_controls` WHERE `storage_type`='demo7';
DELETE FROM `storage_controls` WHERE `storage_type`='demo8';
DELETE FROM `storage_controls` WHERE `storage_type`='demo9';
DELETE FROM `storage_controls` WHERE `storage_type`='demo10';
DELETE FROM `storage_controls` WHERE `storage_type`='demo11';
DELETE FROM `storage_controls` WHERE `storage_type`='demo12';
DELETE FROM `storage_controls` WHERE `storage_type`='BloodUrine';

-- Purge all existing storage
SET foreign_key_checks = 0;
DELETE FROM `storage_masters`;
DELETE FROM `storage_masters_revs`;

DELETE FROM `std_racks_revs`;
DELETE FROM `std_racks`;

DELETE FROM `std_boxs_revs`;
DELETE FROM `std_boxs`;

DELETE FROM `std_nitro_locates_revs`;
DELETE FROM `std_nitro_locates`;
SET foreign_key_checks = 1;

-- Disable all other types
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='3';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='9';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='10';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='11';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='12';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='13';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='14';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='15';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='16';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='17';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `id`='18';

-- Create Nitrogen Tank with 26 position and rack
INSERT INTO `storage_controls` (`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES 
('Nitrogen Tank', 'position', 'integer', '26', '26', '1', '0', '0', '1', '1', '0', '1', 'std_customs', 'custom#storage types#Nitrogen Tank', '1'),
('Rack (14)', '', NULL, NULL, '0', '0', '0', '0', '1', '0', '0', '1', 'std_customs', 'custom#storage types#Rack (14)', '0');

-- Create Blood and Urine boxes 12xH
INSERT INTO `storage_controls` (`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`,  `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES 
('BloodUrine', 'column', 'integer', '12', 'row', 'alphabetical', '8', '0', '0', '0', '0', '1', '0', '0', '1', 'std_customs', 'custom#storage types#BloodUrine', '1');


-- ======================================================================================
-- Eventum ID: 3145 - New storages (Cardboard, Slide and Block) 
-- ======================================================================================

-- Create Slide box
INSERT INTO `storage_controls` (`storage_type`,`coord_x_title`,`coord_x_type`,`coord_x_size`,`coord_y_title`,`coord_y_type`,`coord_y_size`,`display_x_size`,`display_y_size`,`reverse_x_numbering`,`reverse_y_numbering`,`horizontal_increment`,`set_temperature`,`is_tma_block`,`flag_active`,`detail_form_alias`,`detail_tablename`,`databrowser_label`,`check_conflicts`) VALUES
('Slide Box',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,0,0,1,'','std_customs','custom#storage types#Slide Box',0);

-- Create Block tray
INSERT INTO `storage_controls` (`storage_type`,`coord_x_title`,`coord_x_type`,`coord_x_size`,`coord_y_title`,`coord_y_type`,`coord_y_size`,`display_x_size`,`display_y_size`,`reverse_x_numbering`,`reverse_y_numbering`,`horizontal_increment`,`set_temperature`,`is_tma_block`,`flag_active`,`detail_form_alias`,`detail_tablename`,`databrowser_label`,`check_conflicts`) VALUES
('Block Tray',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,0,0,1,'','std_customs','custom#storage types#Block Tray',0);

-- Create Cardboard box
INSERT INTO `storage_controls` (`storage_type`,`coord_x_title`,`coord_x_type`,`coord_x_size`,`coord_y_title`,`coord_y_type`,`coord_y_size`,`display_x_size`,`display_y_size`,`reverse_x_numbering`,`reverse_y_numbering`,`horizontal_increment`,`set_temperature`,`is_tma_block`,`flag_active`,`detail_form_alias`,`detail_tablename`,`databrowser_label`,`check_conflicts`) VALUES
('Cardboard Box',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,0,0,1,'','std_customs','custom#storage types#Cardboard Box',0);

-- ======================================================================================
-- Eventum ID: 3146 - TTB Dx - Awaiting Final Path Review 
-- ======================================================================================

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Awaiting Final Path Report", "Awaiting Final Path Report");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Awaiting Final Path Report" AND language_alias="Awaiting Final Path Report"), "0", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('Awaiting Final Path Report', 'Awaiting Final Path Report', '');

-- Set value as default for new records
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') ,  `default`='Awaiting Final Path Report' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='npttb_ttb_diagnosis' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis');
