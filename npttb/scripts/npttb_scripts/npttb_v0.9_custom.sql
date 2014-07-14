-- NPTTB Custom v0.9
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.9', '');
	
-- Eventum ID: 3070 - Disable inventory types
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(192, 102);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12);

-- Eventum ID: 3071 - Recurrence form duplicate field
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='npttb_final_path' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Eventum ID: 3072 - v5 Consent form update
ALTER TABLE `cd_npttb_consent_brain_bank` 
ADD COLUMN `npttb_use_cell_lines` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_form_type`;

ALTER TABLE `cd_npttb_consent_brain_bank_revs` 
ADD COLUMN `npttb_use_cell_lines` VARCHAR(45) NULL DEFAULT NULL AFTER `npttb_form_type`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_use_cell_lines', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help cell lines', 'npttb use cell lines', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_cell_lines' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help cell lines' AND `language_label`='npttb use cell lines' AND `language_tag`=''), '2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_1_store_samples_medical' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_2_conduct_research' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_3_share_samples_healthinfo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_4_contact_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_4_contact_relationship' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_4_contact_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_form_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_form_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_tissue' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_blood' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_urine' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_csf' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_bone_marrow' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('npttb use cell lines', 'Use for Cell Lines', ''),
('npttb help cell lines', 'Use a portion of your tissue sample(s) for culture and establishment of cell line(s) for research use.', '');

-- Add Assent field
ALTER TABLE `cd_npttb_consent_brain_bank` 
ADD COLUMN `npttb_assent_status` VARCHAR(45) NULL AFTER `npttb_use_bone_marrow`;
ALTER TABLE `cd_npttb_consent_brain_bank_revs` 
ADD COLUMN `npttb_assent_status` VARCHAR(45) NULL AFTER `npttb_use_bone_marrow`;

ALTER TABLE `cd_npttb_consent_brain_bank` 
ADD COLUMN `npttb_assent_date` DATE NULL DEFAULT NULL AFTER `cd_npttb_consent_brain_bank`;
ALTER TABLE `cd_npttb_consent_brain_bank_revs` 
ADD COLUMN `npttb_assent_date` DATE NULL DEFAULT NULL AFTER `cd_npttb_consent_brain_bank`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_assent_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'npttb assent status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_assent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb assent status' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_assent_date', 'date', NULL , '0', '', '', '', 'npttb assent date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_assent_date' AND `type`='date' AND `structure_value_domain` IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb assent date' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('npttb assent status', 'Assent Status', ''),
('npttb assent date', 'Date of Assent', '');

-- Move consent signed date
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Eventum ID: 3073 - Disable storage types
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='TMA-blc 23X15';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='TMA-blc 29X21';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='cupboard';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='room';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='incubator';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='fridge';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box';


