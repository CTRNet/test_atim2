-- Run after v234 update

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(152, 164, 181, 182, 180, 183, 184, 167, 170, 171, 169, 172, 187, 186, 185);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 23, 136, 25, 24, 4, 118, 6, 142, 143, 141, 144, 7, 130, 101, 140);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11, 33);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(44, 45);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12, 34);

REPLACE i18n (id,en,fr) VALUES ('core_installname','LD - Lymphoma','LD - Lymphome');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lymphoma','Lymphoma','Lymphome');
UPDATE users SET flag_active = 1 where id = 1;
UPDATE banks SET name = 'Lymphoma', description = '' WHERE id = 1;

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty', '', 'value is required', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='sop_group' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='scope' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='purpose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='version' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='activated_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM sop_controls WHERE id != 2;
UPDATE sop_controls SET type = 'LD-Lymphoma';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_tissue_source_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''tissue source'')');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="custom_tissue_source_list")
WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list");

INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('tissue source', '1', '20');

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

REPLACE i18n (id,en,fr) VALUES('sample code', 'Sample System Code', 'Code système échantillon');

UPDATE structure_fields SET language_label = 'sample code' WHERE field = 'sample_code';

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_search_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id' AND model like '%aliquot%');

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
WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='sop_master_id');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `field` IN ('supplier_dept','reception_by'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field` IN ('pathology_reception_datetime'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field` IN ('creation_site','creation_by'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field` IN ('storage_datetime','in_stock_detail'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `field` IN ('temperature','temp_unit'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE '%ad_spec%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field` IN ('study_summary_id'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE '%ad_der%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field` IN ('study_summary_id'));
UPDATE structure_formats SET `flag_search`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field` IN ('current_volume'));

INSERT INTO i18n (id,en,fr)
VALUES 
('the submitted bank number already exists','The submitted Bank Number already exists!','Le numéro de banque existe déjà!'),
('hospital number','Hospital #','# Hospitalier'),
('RAMQ','RAMQ','RAMQ');

REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'Bank #', '# Banque');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id from structure_fields WHERE field IN ('middle_name','marital_status','language_preferred','race','title','cod_confirmation_source','secondary_cod_icd10_code'));

INSERT INTO `ldlymph`.`misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`) 
VALUES (NULL, 'hospital number', '', '1', '0', NULL, NULL, '1', '1');
INSERT INTO `ldlymph`.`misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`) 
VALUES (NULL, 'RAMQ', '', '1', '0', NULL, NULL, '1', '1');

UPDATE groups SET flag_show_confidential = 1 WHERE name = 'Administrators' ;

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph. consent', 1, 'cd_ld_lymphs', 'cd_nationals', 0, 'ld lymph. consent');

INSERT INTO structures(`alias`) VALUES ('cd_ld_lymphs');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ld_lymphs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='NULL' AND `language_help`='help_status_date' AND `language_label`='status date' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='cd_ld_lymphs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_form_version' AND `language_label`='form_version' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='cd_ld_lymphs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='help_reason_denied' AND `language_label`='reason denied or withdrawn' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ld_lymphs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_status' AND `language_label`='consent status' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='cd_ld_lymphs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE consent_controls SET flag_active = 0 WHERE controls_type != 'ld lymph. consent';

INSERT INTO i18n (id,en,fr)
VALUES ('ld lymph. consent','LD Lymph. Consent','LD lymph. consentement');




