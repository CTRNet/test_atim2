-- ------------------------------------------------------
-- ATiM v2.6.6 Upgrade Script
-- version: 2.6.6
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('content','Content','Contenu');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lines','Lines','Lignes');
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update system table deleting unused fields (created, etc) or changing unnecessary fields default value
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_reports 
  DROP COLUMN created, 
  DROP COLUMN created_by, 
  DROP COLUMN modified, 
  DROP COLUMN modified_by;
ALTER TABLE pages 
  DROP COLUMN created, 
  DROP COLUMN created_by, 
  DROP COLUMN modified, 
  DROP COLUMN modified_by;
ALTER TABLE structure_validations
 MODIFY `language_message` text DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #2702 create batch process to add one internal use to many aliquots
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Change edit aliquot in batch to be consistent

UPDATE i18n SET en = 'New (Selection Label)' WHERE en = 'New (selection label)';
UPDATE structure_fields SET  `type`='checkbox' WHERE model='FunctionManagement' AND tablename='' AND field='remove_in_stock_detail' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='checkbox' WHERE model='FunctionManagement' AND tablename='' AND field='remove_study_summary_id' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='checkbox' WHERE model='FunctionManagement' AND tablename='' AND field='remove_sop_master_id' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_type`='1', `type`='checkbox' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `language_label`='aliquot in stock' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='yes - available' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `language_help`='aliquot_in_stock_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'in_stock', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') , '0', '', '', 'aliquot_in_stock_help', 'aliquot in stock', 'new value');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`='new value'), '0', '400', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('all changes will be applied to the all','All changes will be applied to the all.','Toutes les modifications seront appliquées à l''ensemble'),
("keep the 'new value' field empty to not change data and use the 'erase/remove' checkbox to erase the data",
"Keep the 'New Value' field empty to not change data and use the 'Erase/Remove' checkbox to erase the data.",
"Garder le champ 'nouvelle valeur' vide pour ne pas modifier les données et utilisez la case 'Éffacer/Enlever 'pour effacer les données.");

-- Add in stock detail 

SET @flag_Active = (SELECT flag_active FROM datamart_structure_functions WHERE label = 'create uses/events (aliquot specific)');
UPDATE datamart_structure_functions SET flag_active = @flag_Active WHERE label = 'create use/event (applied to all)';
INSERT INTO structures(`alias`) VALUES ('aliq_in_stock_details_for_use_in_batch_process');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`='new value'), '1', '400', 'aliquots data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  AND `flag_confidential`='0'), '1', '500', '', '0', '0', '', '1', 'new value', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_in_stock_detail' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='or delete data'), '1', '501', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '701', '', '0', '0', '', '1', 'new storage selection label', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '702', '', '0', '0', '', '1', 'or remove', '0', '', '1', 'checkbox', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process');
INSERT INTO i18n (id,en,fr) VALUES ('aliquots data','Aliquots Data', 'Données des aliquots');

UPDATE structure_fields SET language_tag = 'or erase data' WHERE language_tag = 'or delete data' AND field LIKE 'remove_%';
INSERT INTO i18n (id,en,fr) VALUES ('or erase data', 'Or Erase Data', 'Ou effacer les données'); 














-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.6', NOW(),'???','n/a');
