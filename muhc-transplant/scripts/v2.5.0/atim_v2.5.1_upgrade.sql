-- Run against a 2.5.0 installation
-- Read the printed messages carefully

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.5.1', NOW(), '4820');

SELECT IF(COUNT(*) > 0, "At least one row of structure_fields table contains a field linked to detail model with no plugin defintion.", "No error") AS 'structure_fields.plugin check msg' FROM structure_fields WHERE model LIKE '%Detail' AND (plugin LIKE '' OR plugin IS NULL);

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND `flag_index`='1';

UPDATE structure_formats SET `display_column`='1', `display_order`='10000' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='10000' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='sample_code');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_addgrid`='0', `flag_addgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');
UPDATE structure_fields SET language_label = 'parent sample' WHERE language_label = 'parent sample code';
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('cdna','cDNA','ADNc');

UPDATE structure_formats SET `language_heading`='realiquoting data' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquot_without_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='realiquoting data' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquot_with_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES 
('realiquoting data','Realiquoting','Réaliquotage'),
('realiquoting date','Date (Realiquoting)','Date (réaliquotage)');

-- CAP report field clean up (added to trunk)
-- Hepatocellular Carcinoma
REPLACE INTO i18n (id,en) VALUES
('lymph vascular large vessel invasion','Macroscopic Venous (Large Vessel) Invasion (V)'),
('lymph vascular small vessel invasion','Microscopic (Small Vessel) Invasion (L)');
UPDATE structure_formats SET language_heading = 'perineural invasion' WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_cap_report_hepatocellular_carcinomas') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'perineural_invasion');
-- Pancreas endo & exo
ALTER TABLE  `ed_cap_report_pancreasendos` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
ALTER TABLE  `ed_cap_report_pancreasendos_revs` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
ALTER TABLE  `ed_cap_report_pancreasexos` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
ALTER TABLE  `ed_cap_report_pancreasexos_revs` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
UPDATE structure_fields SET field = 'proximal_pancreatic_margin', language_label = 'proximal pancreatic margin' WHERE field = 'promimal_pancreatic_margin';
INSERT IGNORE INTO i18n (id,en) VALUE ('proximal pancreatic margin','Proximal Pancreatic Margin');

SELECT 'Add max_input_vars=5000; to your php.ini (see wiki Troubleshooting for more details)' AS 'serveur_configuration_msg';

UPDATE datamart_structures SET index_link='/InventoryManagement/SampleMasters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%/' WHERE model='ViewSample';
UPDATE datamart_structures SET index_link='/ClinicalAnnotation/Participants/profile/%%MiscIdentifier.participant_id%%' WHERE model='MiscIdentifier';
UPDATE menus SET use_link='/Order/Shipments/listall/%%Order.id%%/' WHERE use_link='/Order/shipments/listall/%%Order.id%%/';
UPDATE menus SET use_link='/Order/Shipments/detail/%%Order.id%%/' WHERE use_link='/Order/shipments/detail/%%Order.id%%/';
UPDATE structure_fields SET setting = 'url=/StorageLayout/StorageMasters/autocompleteLabel' WHERE setting ='url=/StorageLayout/storage_masters/autocompleteLabel';



