-- NPTTB Custom v0.10
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.10', '');
	
-- Eventum ID: #3095 - Laterality
UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality') AND `flag_confidential`='0');
	
-- Eventum ID: #3094 - Diagnosis Type
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Rhabdomyosarcoma", "npttb Rhabdomyosarcoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Rhabdomyosarcoma" AND language_alias="npttb Rhabdomyosarcoma"), "62", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Normal" AND language_alias="Normal"), "50", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Reactive", "npttb Reactive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Reactive" AND language_alias="npttb Reactive"), "62", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('npttb Rhabdomyosarcoma', 'Rhabdomyosarcoma', ''),
 ('npttb Reactive', 'Reactive', '');
 
-- Eventum ID: #3075 - Collection form Disable SOP field
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

-- Eventum ID: #3076 - Blood sample form - Tubes collected
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Eventum ID: #3096 - RNA/DNA Concentration

-- Add new field
ALTER TABLE `ad_tubes` 
ADD COLUMN `concentration_secondary` DECIMAL(10,2) NULL DEFAULT NULL AFTER `concentration_unit`,
ADD COLUMN `concentration_secondary_unit` VARCHAR(20) NULL DEFAULT NULL AFTER `concentration_secondary`,
ADD COLUMN `concentration_secondary_type` VARCHAR(45) NULL DEFAULT NULL AFTER `concentration_secondary_unit`;
ALTER TABLE `ad_tubes_revs` 
ADD COLUMN `concentration_secondary` DECIMAL(10,2) NULL DEFAULT NULL AFTER `concentration_unit`,
ADD COLUMN `concentration_secondary_unit` VARCHAR(20) NULL DEFAULT NULL AFTER `concentration_secondary`,
ADD COLUMN `concentration_secondary_type` VARCHAR(45) NULL DEFAULT NULL AFTER `concentration_secondary_unit`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'concentration_secondary', 'float_positive',  NULL , '0', 'size=5', '', '', 'concentration secondary', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'concentration_secondary_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_secondary' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='concentration secondary' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_secondary_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

-- Value domain for type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("concentration_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("nanovue", "nanovue");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="concentration_type"), (SELECT id FROM structure_permissible_values WHERE value="nanovue" AND language_alias="nanovue"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("qubit", "qubit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="concentration_type"), (SELECT id FROM structure_permissible_values WHERE value="qubit" AND language_alias="qubit"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("picogreen", "picogreen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="concentration_type"), (SELECT id FROM structure_permissible_values WHERE value="picogreen" AND language_alias="picogreen"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="concentration_type"), (SELECT id FROM structure_permissible_values WHERE value="bioanalyzer" AND language_alias="bioanalyzer"), "1", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'concentration_secondary_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='concentration_type') , '0', '', '', '', 'concentration secondary type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_secondary_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='concentration secondary type' AND `language_tag`=''), '1', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('concentration secondary', 'Concentration (secondary)', ''),
 ('aliquot concentration', 'Concentration (by NanoVue)', ''),
 ('concentration secondary type', 'Secondary Concentration Type', ''),
 ('nanovue', 'NanoVue', ''),
 ('qubit', 'Qubit', ''),
 ('picogreen', 'PicoGreen', '');
 

-- Eventum ID: #3098 - CNS Location
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cns_location", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("frontal", "frontal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="frontal" AND language_alias="frontal"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("parietal", "parietal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="parietal" AND language_alias="parietal"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("temporal", "temporal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="temporal" AND language_alias="temporal"), "12", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("occipital", "occipital");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="occipital" AND language_alias="occipital"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("thalamus and basal ganglia", "thalamus and basal ganglia");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="thalamus and basal ganglia" AND language_alias="thalamus and basal ganglia"), "13", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("brainstem", "brainstem");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="brainstem" AND language_alias="brainstem"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cerebellum", "cerebellum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="cerebellum" AND language_alias="cerebellum"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("spinal cord", "spinal cord");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="spinal cord" AND language_alias="spinal cord"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("spinal root", "spinal root");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="spinal root" AND language_alias="spinal root"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("peripheral nerve", "peripheral nerve");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="peripheral nerve" AND language_alias="peripheral nerve"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("optic pathway", "optic pathway");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="optic pathway" AND language_alias="optic pathway"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("auditory pathway", "auditory pathway");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="auditory pathway" AND language_alias="auditory pathway"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pituitary", "pituitary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="pituitary" AND language_alias="pituitary"), "9", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_location"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "14", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('frontal', 'Frontal', ''),
 ('parietal', 'Parietal', ''), 
 ('temporal', 'Temporal', ''),
 ('occipital', 'Occipital', ''), 
 ('thalamus and basal ganglia', 'Thalamus and Basal Ganglia', ''),
 ('brainstem', 'Brainstem', ''), 
 ('cerebellum', 'Cerebellum', ''),
 ('spinal cord', 'Spinal cord', ''), 
 ('spinal root', 'Spinal root', ''),
 ('peripheral nerve', 'Peripheral Nerve', ''), 
 ('optic pathway', 'Optic pathway', ''),
 ('pituitary', 'Pituitary', ''), 
 ('auditory pathway', 'Auditory pathway', ''),
 ('npttb cns location', 'CNS Location', '');
 
ALTER TABLE `sd_spe_tissues` 
ADD COLUMN `npttb_cns_location` VARCHAR(75) NULL DEFAULT NULL AFTER `npttb_tissue_type`;

ALTER TABLE `sd_spe_tissues_revs` 
ADD COLUMN `npttb_cns_location` VARCHAR(75) NULL DEFAULT NULL AFTER `npttb_tissue_type`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_cns_location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cns_location') , '0', '', '', '', 'npttb cns location', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_cns_location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cns_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb cns location' AND `language_tag`=''), '1', '443', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');
