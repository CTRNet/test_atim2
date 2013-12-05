-- TFRI AML/MDS Custom Script
-- Version: v0.4
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS-AML v0.4 DEV', '');
	
/*
	Eventum Issue: #2828 - Storage config - disable racks, boxes, shelves
*/

UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='TMA-blc 23X15';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='TMA-blc 29X21';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box100 1A-20E';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box25';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box81';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box81 1A-9I';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='cupboard';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='incubator';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='rack10';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='rack11';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='rack16';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='rack24';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='rack9';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='shelf';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='fridge';


/*
	Eventum Issue: #2820: Collection - Hide collection property and collection site values
*/

-- Hide collection property
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

INSERT INTO `structure_permissible_values_customs` (`id`,`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES 
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'6','6','',0,1,'2013-12-05 15:06:59',1,'2013-12-05 15:06:59',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'5','5','',0,1,'2013-12-05 15:06:59',1,'2013-12-05 15:06:59',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'4','4','',0,1,'2013-12-05 15:06:59',1,'2013-12-05 15:06:59',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'3','3','',0,1,'2013-12-05 15:06:59',1,'2013-12-05 15:06:59',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'2','2','',0,1,'2013-12-05 15:06:59',1,'2013-12-05 15:06:59',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'1','1','',0,1,'2013-12-05 15:06:59',1,'2013-12-05 15:06:59',1,0);


/*
	Eventum Issue: #2833: Add bank names
*/

UPDATE `banks` SET `name`='BCLQ', `description`='' WHERE `id`='1';
INSERT INTO `banks` (`name`) VALUES ('Hematology Cell Bank of BC');
INSERT INTO `banks` (`name`, `description`) VALUES ('MTB', 'Manitoba Tumour Bank');
INSERT INTO `banks` (`name`) VALUES ('Princess Margaret Cancer Centre');


/*
	Eventum Issue: #2823: Blood and Tubes - Change label
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('blood', 'Peripheral blood', ''),
 ('tube', 'Vial', '');

/*
	Eventum Issue: #2822: Blood tubes - Add value for other and text field
*/

-- Update blood tube value domain
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="1" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="EDTA" AND language_alias="EDTA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="2" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="4" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="6" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="5" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");

-- Add text field for other tube value
ALTER TABLE `sd_spe_bloods` 
ADD COLUMN `tfri_blood_tube_other` VARCHAR(50) NULL DEFAULT NULL AFTER `collected_volume_unit`;

ALTER TABLE `sd_spe_bloods_revs` 
ADD COLUMN `tfri_blood_tube_other` VARCHAR(50) NULL DEFAULT NULL AFTER `collected_volume_unit`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'tfri_blood_tube_other', 'input',  NULL , '0', 'size=10', '', '', 'tfri blood tube other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='tfri_blood_tube_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='tfri blood tube other' AND `language_tag`=''), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='444' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='445' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='443' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='',  `language_tag`='tfri blood tube other' WHERE model='SampleDetail' AND tablename='sd_spe_bloods' AND field='tfri_blood_tube_other' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('blood tube type', 'Blood Tube', ''),
 ('tfri blood tube other', 'Other tube type', '');

/*
	Eventum Issue: #2836: Sample master - hide fields
*/

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	Eventum Issue: #2837: Blood sample - WBC and Blast count
*/

ALTER TABLE `sd_spe_bloods` 
ADD COLUMN `tfri_wbc_count` DECIMAL(5,2) NULL DEFAULT NULL AFTER `tfri_blood_tube_other`,
ADD COLUMN `tfri_blast_count` DECIMAL(5,2) NULL DEFAULT NULL AFTER `tfri_wbc_count`;

ALTER TABLE `sd_spe_bloods_revs` 
ADD COLUMN `tfri_wbc_count` DECIMAL(5,2) NULL DEFAULT NULL AFTER `tfri_blood_tube_other`,
ADD COLUMN `tfri_blast_count` DECIMAL(5,2) NULL DEFAULT NULL AFTER `tfri_wbc_count`;

-- Add field to blood specimen form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'tfri_wbc_count', 'float',  NULL , '0', 'size=10', '', '', 'tfri wbc count', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'tfri_blast_count', 'float',  NULL , '0', 'size=10', '', '', 'tfri blast count', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='tfri_wbc_count' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='tfri wbc count' AND `language_tag`=''), '1', '448', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='tfri_blast_count' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='tfri blast count' AND `language_tag`=''), '1', '449', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri wbc count', 'WBC Count', ''),
 ('tfri blast count', 'Blast Count', '');
 
/*
	Eventum Issue: #2816: AML Diagnosis Form
*/

-- Purge existing form
DELETE FROM `structure_formats` WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` where `tablename` = 'dxd_tfri_aml');
DELETE FROM `structure_fields` where tablename = 'dxd_tfri_aml';

-- Drop columns
ALTER TABLE `dxd_tfri_aml` 
DROP COLUMN `tfri_other_diagnosis`,
DROP COLUMN `tfri_aml_transform_mds_mdp`,
DROP COLUMN `tfri_aml_myeloid_proliferations`,
DROP COLUMN `tfri_aml_ambiguous_lineage`,
DROP COLUMN `tfri_aml_aml_not_otherwise_categorized`,
DROP COLUMN `tfri_aml_recurrent_genetic`;

ALTER TABLE `dxd_tfri_aml_revs` 
DROP COLUMN `tfri_other_diagnosis`,
DROP COLUMN `tfri_aml_transform_mds_mdp`,
DROP COLUMN `tfri_aml_myeloid_proliferations`,
DROP COLUMN `tfri_aml_ambiguous_lineage`,
DROP COLUMN `tfri_aml_aml_not_otherwise_categorized`,
DROP COLUMN `tfri_aml_recurrent_genetic`;

-- Add new columns
ALTER TABLE `dxd_tfri_aml` 
ADD COLUMN `aml_recurrent_genetic_runx1-runx1t1` CHAR(3) NULL AFTER `diagnosis_master_id`,
ADD COLUMN `aml_recurrent_genetic_cbfbeta_myh11` CHAR(3) NULL AFTER `aml_recurrent_genetic_runx1-runx1t1`,
ADD COLUMN `apl_recurrent_genetic_pml_raralpha` CHAR(3) NULL AFTER `aml_recurrent_genetic_cbfbeta_myh11`,
ADD COLUMN `aml_recurrent_genetic_dek-nup214` CHAR(3) NULL AFTER `apl_recurrent_genetic_pml_raralpha`,
ADD COLUMN `aml_recurrent_genetic_rpn1-evi1` CHAR(3) NULL AFTER `aml_recurrent_genetic_dek-nup214`,
ADD COLUMN `aml_recurrent_genetic_rbm15-mkl1` CHAR(3) NULL AFTER `aml_recurrent_genetic_rpn1-evi1`,
ADD COLUMN `aml_recurrent_genetic_mutated_npm1` CHAR(3) NULL AFTER `aml_recurrent_genetic_rbm15-mkl1`,
ADD COLUMN `aml_recurrent_genetic_mutated_cebpa` CHAR(3) NULL AFTER `aml_recurrent_genetic_mutated_npm1`,
ADD COLUMN `aml_recurrent_genetic_myelodysplasia_related` CHAR(3) NULL AFTER `aml_recurrent_genetic_mutated_cebpa`,
ADD COLUMN `aml_nos_minimally_differentiated` CHAR(3) NULL AFTER `aml_recurrent_genetic_myelodysplasia_related`,
ADD COLUMN `aml_nos_without_maturation` CHAR(3) NULL AFTER `aml_nos_minimally_differentiated`,
ADD COLUMN `aml_nos_acute_myelomonocytic_leukemia` CHAR(3) NULL AFTER `aml_nos_without_maturation`,
ADD COLUMN `aml_nos_acute_monoblastic_monocytic_leukemia` CHAR(3) NULL AFTER `aml_nos_acute_myelomonocytic_leukemia`,
ADD COLUMN `aml_nos_acute_erythroid_leukemia_pure` CHAR(3) NULL AFTER `aml_nos_acute_monoblastic_monocytic_leukemia`,
ADD COLUMN `aml_nos_acute_erythroid_leukemia_erythroleukemia` CHAR(3) NULL AFTER `aml_nos_acute_erythroid_leukemia_pure`,
ADD COLUMN `aml_nos_megakaryoblastic_leukemia` CHAR(3) NULL AFTER `aml_nos_acute_erythroid_leukemia_erythroleukemia`,
ADD COLUMN `aml_nos_acute_basophilic_leukemia` CHAR(3) NULL AFTER `aml_nos_megakaryoblastic_leukemia`,
ADD COLUMN `aml_nos_acute_panmyelosis_myelofibrosis` CHAR(3) NULL AFTER `aml_nos_acute_basophilic_leukemia`,
ADD COLUMN `aml_nos_myeloid_sarcoma` CHAR(3) NULL AFTER `aml_nos_acute_panmyelosis_myelofibrosis`,
ADD COLUMN `aml_nos_blastic_plasmacytoid_dendritic_cell_neoplasm` CHAR(3) NULL AFTER `aml_nos_myeloid_sarcoma`,
ADD COLUMN `aml_ambiguous_acute_undifferentiated_leukemia` CHAR(3) NULL AFTER `aml_nos_blastic_plasmacytoid_dendritic_cell_neoplasm`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_bcr-abl1` CHAR(3) NULL AFTER `aml_ambiguous_acute_undifferentiated_leukemia`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_mll_rearranged` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_bcr-abl1`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_b-myeloid_nos` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_mll_rearranged`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_t-myeloid_nos` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_b-myeloid_nos`,
ADD COLUMN `aml_ambiguous_natural_killer_cell_lymphoblastic` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_t-myeloid_nos`;

ALTER TABLE `dxd_tfri_aml_revs` 
ADD COLUMN `aml_recurrent_genetic_runx1-runx1t1` CHAR(3) NULL AFTER `diagnosis_master_id`,
ADD COLUMN `aml_recurrent_genetic_cbfbeta_myh11` CHAR(3) NULL AFTER `aml_recurrent_genetic_runx1-runx1t1`,
ADD COLUMN `apl_recurrent_genetic_pml_raralpha` CHAR(3) NULL AFTER `aml_recurrent_genetic_cbfbeta_myh11`,
ADD COLUMN `aml_recurrent_genetic_dek-nup214` CHAR(3) NULL AFTER `apl_recurrent_genetic_pml_raralpha`,
ADD COLUMN `aml_recurrent_genetic_rpn1-evi1` CHAR(3) NULL AFTER `aml_recurrent_genetic_dek-nup214`,
ADD COLUMN `aml_recurrent_genetic_rbm15-mkl1` CHAR(3) NULL AFTER `aml_recurrent_genetic_rpn1-evi1`,
ADD COLUMN `aml_recurrent_genetic_mutated_npm1` CHAR(3) NULL AFTER `aml_recurrent_genetic_rbm15-mkl1`,
ADD COLUMN `aml_recurrent_genetic_mutated_cebpa` CHAR(3) NULL AFTER `aml_recurrent_genetic_mutated_npm1`,
ADD COLUMN `aml_recurrent_genetic_myelodysplasia_related` CHAR(3) NULL AFTER `aml_recurrent_genetic_mutated_cebpa`,
ADD COLUMN `aml_nos_minimally_differentiated` CHAR(3) NULL AFTER `aml_recurrent_genetic_myelodysplasia_related`,
ADD COLUMN `aml_nos_without_maturation` CHAR(3) NULL AFTER `aml_nos_minimally_differentiated`,
ADD COLUMN `aml_nos_acute_myelomonocytic_leukemia` CHAR(3) NULL AFTER `aml_nos_without_maturation`,
ADD COLUMN `aml_nos_acute_monoblastic_monocytic_leukemia` CHAR(3) NULL AFTER `aml_nos_acute_myelomonocytic_leukemia`,
ADD COLUMN `aml_nos_acute_erythroid_leukemia_pure` CHAR(3) NULL AFTER `aml_nos_acute_monoblastic_monocytic_leukemia`,
ADD COLUMN `aml_nos_acute_erythroid_leukemia_erythroleukemia` CHAR(3) NULL AFTER `aml_nos_acute_erythroid_leukemia_pure`,
ADD COLUMN `aml_nos_megakaryoblastic_leukemia` CHAR(3) NULL AFTER `aml_nos_acute_erythroid_leukemia_erythroleukemia`,
ADD COLUMN `aml_nos_acute_basophilic_leukemia` CHAR(3) NULL AFTER `aml_nos_megakaryoblastic_leukemia`,
ADD COLUMN `aml_nos_acute_panmyelosis_myelofibrosis` CHAR(3) NULL AFTER `aml_nos_acute_basophilic_leukemia`,
ADD COLUMN `aml_nos_myeloid_sarcoma` CHAR(3) NULL AFTER `aml_nos_acute_panmyelosis_myelofibrosis`,
ADD COLUMN `aml_nos_blastic_plasmacytoid_dendritic_cell_neoplasm` CHAR(3) NULL AFTER `aml_nos_myeloid_sarcoma`,
ADD COLUMN `aml_ambiguous_acute_undifferentiated_leukemia` CHAR(3) NULL AFTER `aml_nos_blastic_plasmacytoid_dendritic_cell_neoplasm`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_bcr-abl1` CHAR(3) NULL AFTER `aml_ambiguous_acute_undifferentiated_leukemia`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_mll_rearranged` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_bcr-abl1`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_b-myeloid_nos` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_mll_rearranged`,
ADD COLUMN `aml_ambiguous_mixed_phenotype_t-myeloid_nos` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_b-myeloid_nos`,
ADD COLUMN `aml_ambiguous_natural_killer_cell_lymphoblastic` CHAR(3) NULL AFTER `aml_ambiguous_mixed_phenotype_t-myeloid_nos`;


