-- -----------------------------------------------------------------------------------------------------------------------------------
-- Fix bug detected on some SGBD
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_masters MODIFY storage_coord_x varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters MODIFY storage_coord_y varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY storage_coord_x varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY storage_coord_y varchar(11) DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Display of both TMA data and slide data in slide creation in batch
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE `language_heading` = 'tma block' AND structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='slide' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='0', `display_order`='-5' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='-4' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue # 3295 : Set all foreign key datamart_structure_id to int(10) 
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_batch_sets MODIFY `datamart_structure_id` int(10) unsigned NOT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue # 3116 : Add Participant Message in batch + change 'task list' to be custom list
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Participant Message Types\')" WHERE domain_name = 'message_type';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Participant Message Types', 1, 20, 'clinical - message');
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains_permissible_values AS svdpv 
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id
LEFT JOIN i18n ON spv.value = i18n.id
WHERE svd.domain_name="message_type" AND flag_active = 1);
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="message_type");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - message", "clinical - message");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - message" AND language_alias="clinical - message"), "0", "1");
INSERT INTO i18n (id,en,fr) 
VALUES
('clinical - message', 'Clinical - Message','Clinique - Message');

SELECT "Created funtion 'Create message (applied to all)'. Run following query to activate the function." AS '### MESSAGE ###'
UNION ALL
SELECT "UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';" AS '### MESSAGE ###';
INSERT INTO `datamart_structure_functions` (`datamart_structure_id`, `label`, `link`, `flag_active`) 
(SELECT id, 'create participant message (applied to all)', '/ClinicalAnnotation/ParticipantMessages/add\/', 0 FROM datamart_structures WHERE model IN ('Participant'));
INSERT IGNORE INTO i18n (id,en,fr) VALUES
('create participant message (applied to all)', 'Create message (applied to all)', 'Créer message (applicabl à tous)'),
('you are about to create a message for %d participant(s)', 'You are about to create a message for %d participant(s)', 'Vous êtes sur le point de créer un message pour %d participants'),
('at least one participant should be selected', 'At least one participant should be selected', 'Au moins un participant devrait être sélectionné');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3283: Be able to search storages that contain TMA slide into the databrowser 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('tma_blocks');
INSERT INTO structure_value_domains (domain_name, source)
VALUES
('tma_block_storage_types_from_control_id', 'StorageLayout.StorageControl::getTmaBlockStorageTypePermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaBlock', '', 'code', 'input',  NULL , '0', 'size=30', '', 'storage_code_help', 'storage code', ''), 
('StorageLayout', 'TmaBlock', '', 'storage_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tma_block_storage_types_from_control_id') , '0', '', '', '', 'storage type', ''), 
('StorageLayout', 'TmaBlock', '', 'short_label', 'input',  NULL , '0', 'size=6', '', 'stor_short_label_defintion', 'storage short label', ''), 
('StorageLayout', 'TmaBlock', '', 'selection_label', 'input',  NULL , '0', 'size=20,url=/storagelayout/storage_masters/autoComplete/', '', 'stor_selection_label_defintion', 'storage selection label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='storage_code_help' AND `language_label`='storage code' AND `language_tag`=''), '1', '100', 'system data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_block_storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,url=/storagelayout/storage_masters/autoComplete/' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage selection label' AND `language_tag`=''), '0', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

SET @flag_active = (SELECT IF(count(*) = 0, 0, 1) AS flag FROM storage_controls WHERE is_tma_block = 1 AND flag_active = 1);

DELETE FROM datamart_browsing_controls WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaSlide'));
DELETE FROM datamart_browsing_controls WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaSlide'));
INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) VALUES
(null, 'StorageLayout', 'TmaBlock', (SELECT id FROM structures WHERE alias = 'tma_blocks'), NULL, 'tma blocks (sub-set of storage for databrowser)', '', '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/', '');
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), (SELECT id FROM datamart_structures WHERE model = 'TmaBlock'), @flag_active, @flag_active, 'storage_master_id'),
((SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), (SELECT id FROM datamart_structures WHERE model = 'ViewStorageMaster'), @flag_active, @flag_active, 'storage_master_id'),
((SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), (SELECT id FROM datamart_structures WHERE model = 'TmaBlock'), @flag_active, @flag_active, 'tma_block_storage_master_id'),
((SELECT id FROM datamart_structures WHERE model = 'TmaBlock'), (SELECT id FROM datamart_structures WHERE model = 'ViewStorageMaster'), @flag_active, @flag_active, 'parent_id');

UPDATE datamart_structures SET display_name = 'tma blocks (storages sub-set)' WHERE model = 'TmaBlock';

INSERT INTO i18n (id,en,fr) VALUES ('tma blocks (storages sub-set)', 'Storages (TMA Blocks only)', "Entreposages (Blocs de TMA exclusivement)");

UPDATE datamart_structure_functions SET datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') WHERE label = 'create tma slide';

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("TmaBlock", "tma blocks");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="models"), (SELECT id FROM structure_permissible_values WHERE value="TmaBlock" AND language_alias="tma blocks"), "0", "1");

INSERT INTO i18n (id,en,fr) VALUES ('tma blocks', 'TMA Blocks', "Blocs de TMA");

SELECT "Updated 'Databrowser Relationship Diagram' to add TMA blocks to TMA slides relationship. To customize." AS '### MESSAGE ###';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.6.7', NOW(),'6430','n/a');
