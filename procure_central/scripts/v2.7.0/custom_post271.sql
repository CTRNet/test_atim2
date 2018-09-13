-- -------------------------------------------------------------------------------------
-- MODIFIED SCRIPT FOR ATiM CENTRAL
-- -------------------------------------------------------------------------------------
--
-- To execute after 
--    - atim_procure_central_full_installation_v271_revs_7299_7339_7345.sql
--    - atim_v2.7.1_upgrade.sql
--
-- @author Nicolas Luc
-- @date 2018-09-07
-- -------------------------------------------------------------------------------------
 
 -- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7339' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Anonymize local database fields 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- study_summaries
-- ---------------

--  Renmoved unusefull queries on study_summaries

UPDATE structure_fields SET language_label = 'committee_convenience_ps1' WHERE field = 'procure_site_ethics_committee_convenience_ps1';
UPDATE structure_fields SET language_label = 'committee_convenience_ps4' WHERE field = 'procure_site_ethics_committee_convenience_ps4';
UPDATE structure_fields SET language_label = 'committee_convenience_ps2' WHERE field = 'procure_site_ethics_committee_convenience_ps2';
UPDATE structure_fields SET language_label = 'committee_convenience_ps3' WHERE field = 'procure_site_ethics_committee_convenience_ps3';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('committee_convenience_ps1', 'PS1', 'PS1'),
('committee_convenience_ps2', 'PS2', 'PS2'),
('committee_convenience_ps3', 'PS3', 'PS3'),
('committee_convenience_ps4', 'PS4', 'PS4');

-- procure_cd_sigantures & consent_controls
-- ----------------------------------------
-- Uncomment line that could not be applied on local installation

-- Linked to PS1 fields

--  Renmoved unusefull queries on study_summaries

-- Linked to PS2 fields

--  Renmoved unusefull queries on study_summaries
  
-- Linked to PS4 fields

--  Renmoved unusefull queries on study_summaries

UPDATE versions SET branch_build_number = '7347' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7389' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7403' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7411' WHERE version_number = '2.7.1';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_pbmc_storage_datetime', 'datetime',  NULL , '0', '', '', '', '', 'storage');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pbmc_storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='storage'), '3', '601', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_date_at_minus_80', 'date',  NULL , '0', '', '', '', 'pbmc date at -80', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_date_at_minus_80' AND `type`='date' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_date_at_minus_80' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'procure_serum_storage_datetime', 'datetime',  NULL , '0', '', '', '', '', 'storage');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_serum_storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='storage'), '3', '600', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE versions SET branch_build_number = '7415' WHERE version_number = '2.7.1';
