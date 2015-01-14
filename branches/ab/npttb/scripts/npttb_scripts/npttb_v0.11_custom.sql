-- NPTTB Custom v0.11
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.11', '');
	
-- Eventum ID: 3104 CNS Location Checkboxes

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
      
-- Eventum ID: 3103 QC Score
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='quality_control_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="260/280" AND language_alias="260/280");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='quality_control_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="28/18" AND language_alias="28/18");


-- Eventum ID: 2616 Sample Code Format
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
 
-- Eventum ID: 3105 Storage Updates

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

INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(5,'5',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,2,3,NULL,'R1','NT-R1','','1','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(6,'6',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,4,5,NULL,'R2','NT-R2','','2','',-120.00,'celsius','','2014-11-04 22:54:19',6,'2014-11-04 22:54:50',6,0),
(7,'7',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,6,7,NULL,'R3','NT-R3','','3','',-120.00,'celsius','','2014-11-04 22:55:35',6,'2014-11-04 22:55:35',6,0),
(8,'8',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,8,9,NULL,'R4','NT-R4','','4','',-120.00,'celsius','','2014-11-04 22:56:12',6,'2014-11-04 22:56:12',6,0),
(9,'9',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,10,11,NULL,'R5','NT-R5','','5','',-120.00,'celsius','','2014-11-04 22:56:26',6,'2014-11-04 22:56:26',6,0),
(10,'10',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,12,13,NULL,'R6','NT-R6','','6','',-120.00,'celsius','','2014-11-04 22:57:55',6,'2014-11-04 22:57:55',6,0),
(11,'11',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,14,15,NULL,'R7','NT-R7','','7','',-120.00,'celsius','','2014-11-04 22:58:34',6,'2014-11-04 22:59:15',6,0),
(13,'13',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,16,17,NULL,'R8','NT-R8','','8','',-120.00,'celsius','','2014-11-04 22:59:56',6,'2014-11-04 22:59:56',6,0),
(14,'14',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,18,19,NULL,'R9','NT-R9','','9','',-120.00,'celsius','','2014-11-04 23:00:38',6,'2014-11-04 23:00:38',6,0),
(15,'15',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,20,21,NULL,'R10','NT-R10','','10','',-120.00,'celsius','','2014-11-04 23:01:01',6,'2014-11-04 23:01:01',6,0),
(16,'16',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,22,23,NULL,'R11','NT-R11','','11','',-120.00,'celsius','','2014-11-04 23:01:25',6,'2014-11-04 23:01:25',6,0),
(17,'17',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,24,25,NULL,'R12','NT-R12','','12','',-120.00,'celsius','','2014-11-04 23:01:38',6,'2014-11-04 23:01:38',6,0),
(18,'18',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,26,27,NULL,'R13','NT-R13','','13','',-120.00,'celsius','','2014-11-04 23:02:24',6,'2014-11-04 23:02:24',6,0),
(19,'19',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,28,29,NULL,'R14','NT-R14','','14','',-120.00,'celsius','','2014-11-04 23:02:44',6,'2014-11-04 23:06:25',6,0),
(20,'20',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,30,31,NULL,'R15','NT-R15','','15','',-120.00,'celsius','','2014-11-04 23:03:04',6,'2014-11-04 23:03:04',6,0),
(21,'21',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,32,33,NULL,'R16','NT-R16','','16','',-120.00,'celsius','','2014-11-04 23:03:18',6,'2014-11-04 23:03:18',6,0),
(22,'22',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,34,35,NULL,'R17','NT-R17','','17','',-120.00,'celsius','','2014-11-04 23:03:32',6,'2014-11-04 23:03:32',6,0),
(23,'23',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,36,37,NULL,'R18','NT-R18','','18','',-120.00,'celsius','','2014-11-04 23:03:49',6,'2014-11-04 23:03:49',6,0),
(24,'24',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,38,39,NULL,'R19','NT-R19','','19','',-120.00,'celsius','','2014-11-04 23:04:05',6,'2014-11-04 23:04:05',6,0),
(25,'25',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,40,41,NULL,'R20','NT-R20','','20','',-120.00,'celsius','','2014-11-04 23:04:19',6,'2014-11-04 23:04:19',6,0),
(26,'26',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,42,43,NULL,'R21','NT-R21','','21','',-120.00,'celsius','','2014-11-04 23:04:31',6,'2014-11-04 23:04:31',6,0),
(27,'27',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,44,45,NULL,'R22','NT-R22','','22','',-120.00,'celsius','','2014-11-04 23:04:46',6,'2014-11-04 23:04:46',6,0),
(28,'28',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,46,47,NULL,'R23','NT-R23','','23','',-120.00,'celsius','','2014-11-04 23:05:00',6,'2014-11-04 23:05:00',6,0),
(29,'29',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,48,49,NULL,'R24','NT-R24','','24','',-120.00,'celsius','','2014-11-04 23:05:21',6,'2014-11-04 23:05:21',6,0),
(30,'30',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,50,51,NULL,'R25','NT-R25','','25','',-120.00,'celsius','','2014-11-04 23:05:34',6,'2014-11-04 23:05:34',6,0),
(31,'31',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,52,53,NULL,'R26','NT-R26','','26','',-120.00,'celsius','','2014-11-04 23:05:47',6,'2014-11-04 23:05:47',6,0);

INSERT INTO `std_customs` (`storage_master_id`) VALUES 
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22),
(23),
(24),
(25),
(26),
(27),
(28),
(29),
(30),
(31);

-- Create -80 Freezer 
INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(32,'32',6,NULL,57,58,NULL,'FR','FR','','','',-80.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0);

INSERT INTO `std_freezers` (`storage_master_id`) VALUES (32);

-- Create Blood and Urine boxes 12xH
INSERT INTO `storage_controls` (`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`,  `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES 
('BloodUrine', 'column', 'integer', '12', 'row', 'alphabetical', '8', '0', '0', '0', '0', '1', '0', '0', '1', 'std_customs', 'custom#storage types#BloodUrine', '1');

-- Rack 1
INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(33,'33',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,56,57,NULL,'BU86','NT-R1-BU86','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(34,'34',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,58,59,NULL,'BU87','NT-R1-BU87','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(35,'35',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,60,61,NULL,'BU88','NT-R1-BU88','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(36,'36',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,62,63,NULL,'BU89','NT-R1-BU89','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(37,'37',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,64,65,NULL,'BU90','NT-R1-BU90','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(38,'38',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,66,67,NULL,'BU91','NT-R1-BU91','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(39,'39',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,68,69,NULL,'BU92','NT-R1-BU92','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(40,'40',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,70,71,NULL,'BU93','NT-R1-BU93','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(41,'41',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,72,73,NULL,'BU94','NT-R1-BU94','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(42,'42',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,74,75,NULL,'BU95','NT-R1-BU95','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(43,'43',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,76,77,NULL,'BU96','NT-R1-BU96','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(44,'44',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,78,79,NULL,'BU97','NT-R1-BU97','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(45,'45',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,80,81,NULL,'BU98','NT-R1-BU98','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(46,'46',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,82,83,NULL,'BU99','NT-R1-BU99','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0);

INSERT INTO `std_customs` (`storage_master_id`) VALUES (33), (34), (35), (36), (37), (38), (39), (40), (41), (42), (43), (44), (45), (46);
