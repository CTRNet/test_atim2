-- -----------------------------------------------------------------------------------------------------------------------------------
-- Mirgation from v268 to v271
--
-- mysql -u root procurecusm --default-character-set=utf8 < atim_v2.7.0_upgrade.sql
-- mysql -u root procurecusm --default-character-set=utf8 < custom_pre271.sql
-- mysql -u root procurecusm --default-character-set=utf8 < atim_v2.7.1_upgrade.sql
-- mysql -u root procurecusm --default-character-set=utf8 < custom_post271.sql
-- mysql -u root procurecusm --default-character-set=utf8 < custom_post271_cusm.sql
--
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE banks SET name = 'PROCURE CUSM', description = '';
UPDATE banks_revs SET name = 'PROCURE CUSM', description = '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Bank', 'banks', 'procure_cusm_allow_transfer_to_central', 'checkbox',  NULL , '0', '', '', '', 'allow transfer to central', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='banks'), (SELECT id FROM structure_fields WHERE `model`='Bank' AND `tablename`='banks' AND `field`='procure_cusm_allow_transfer_to_central' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow transfer to central' AND `language_tag`=''), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '1');
INSERT INTO i18n (id,en,fr)
VALUES
('allow transfer to central', "Allow Transfer to Central", "Permettre transfert au central");
ALTER TABLE banks ADD COLUMN procure_cusm_allow_transfer_to_central tinyint(1) DEFAULT '0';
ALTER TABLE banks_revs ADD COLUMN procure_cusm_allow_transfer_to_central tinyint(1) DEFAULT '0';
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='banks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Bank' AND `tablename`='banks' AND `field`='procure_cusm_allow_transfer_to_central' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '7407' WHERE version_number = '2.7.1';
UPDATE versions SET site_branch_build_number = '7498' WHERE version_number = '2.7.1';