REPLACE i18n (id,en,fr) VALUES ('core_installname','LD - Lymphoma','LD - Lymphome');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lymphoma','Lymphoma','Lymphome');

-- ----------------------------------------------------------------------------------------
-- INVENTORY
-- ----------------------------------------------------------------------------------------

UPDATE banks SET name = 'Lymphoma', description = '' WHERE id = 1;
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty', '', 'value is required');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(152, 164, 181, 182, 180, 183, 184, 167, 170, 171, 169, 172, 187, 186, 185);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 23, 136, 25, 24, 4, 118, 6, 142, 143, 141, 144, 7, 130, 101, 140);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11, 33);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(44, 45);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12, 34);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_tissue_source_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''tissue source'')');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="custom_tissue_source_list")
WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('tissue source', '1', '40');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('spleen', 'Spleen', 'Rate', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue source')),
('extra nodal', 'Extra Nodal', 'Extra-Ganglionnaire', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue source')),
('lymph node', 'Lymph Node', 'Ganglion Lymphatique', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue source'));

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'is_problematic');

ALTER TABLE `sd_spe_tissues`
  ADD COLUMN `ld_lymph_tumor_percentage` decimal(5,2) DEFAULT NULL AFTER tissue_weight_unit;
ALTER TABLE `sd_spe_tissues_revs`
  ADD COLUMN `ld_lymph_tumor_percentage` decimal(5,2) DEFAULT NULL AFTER tissue_weight_unit; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'ld_lymph_tumor_percentage', 'float',  NULL , '0', 'size=5', '', '', 'ld lym tumor percentage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ld_lymph_tumor_percentage' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ld lym tumor percentage' AND `language_tag`=''), '1', '450', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('ld lym tumor percentage','Tumor %','% Tumeur');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("snap frozen","snap frozen");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="block_type"),  
(SELECT id FROM structure_permissible_values WHERE value="snap frozen" AND language_alias="snap frozen"), "1", "1");
INSERT INTO i18n (id,en,fr) VALUES ('snap frozen','Snap Frozen','''snap frozen''');

UPDATE aliquot_controls SET flag_active=false WHERE id IN(34, 35);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(35);
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(176, 177, 175, 178); 
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(36);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(43);

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field` IN ('pathology_reception_datetime'));

UPDATE structure_formats SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='acquisition_label');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='collection_datetime'), 'notEmpty', '', 'value is required');

ALTER TABLE sample_masters
  ADD COLUMN ld_lymph_specimen_number INT(7) NOT NULL AFTER sample_code;
ALTER TABLE sample_masters_revs
  ADD COLUMN ld_lymph_specimen_number INT(7) NOT NULL AFTER sample_code;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleMaster', 'sample_masters', 'ld_lymph_specimen_number', 'integer',  NULL , '0', 'size=6', '', '', 'specimen number', '');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='ld_lymph_specimen_number'), 'notEmpty', '', 'value is required');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('specimen number', 'Specimen #', 'Spécimen #'), 
('specimen number should be unique', 'Specimen number should be unique!', 'Le numéro du spécimen doit être unique!');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='320' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewSample', '', 'ld_lymph_specimen_number', 'input',  NULL , '0', 'size=6', '', '', 'specimen number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='ld_lymph_specimen_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '4', '', '0', '', '0', '', '0', '', '1', 'input', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category,
samp.ld_lymph_specimen_number

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;
INSERT INTO i18n (id,en,fr) VALUES ('the specimen number should be unique','The specimen number should be unique!','Le numéro de specimen doit être unique!');

UPDATE structure_fields SET language_label = 'aliquot barcode' WHERE field = 'barcode' AND model IN ('AliquotMaster', 'ViewAliquot');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('aliquot barcode', 'Label', 'Étiquette');
REPLACE INTO i18n (id,en,fr) VALUES ('aliquot barcode', 'Label', 'Étiquette');
UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'aliquot_label');

-- ----------------------------------------------------------------------------------------
-- SOP
-- ----------------------------------------------------------------------------------------

DELETE FROM sop_controls WHERE id != 2;
INSERT INTO `sop_controls` (`id`, `sop_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `flag_active`) 
VALUES
(null, 'LD', 'Lymphoma', 'sopd_inventory_alls', 'sopmasters,sopd_inventory_all', '', '', 1);

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='sop_master_id');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id' AND model like '%aliquot%');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id' AND model like '%collection%');









