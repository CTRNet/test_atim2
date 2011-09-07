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

UPDATE diagnosis_controls SET flag_active = 0;

UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_consent_version_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''consent version'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('consent version', '1', '40');
UPDATE structure_fields 
SET type = 'select',
setting = '',
structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="custom_consent_version_list")
WHERE model = 'ConsentMaster' AND field = 'form_version';

INSERT INTO `diagnosis_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph. diagnostic', 1, 'ld_lymph_dx_primaries', 'ld_lymph_dx_primaries', 0, 'ld lymph. diagnostic'),
(null, 'ld lymph. progression', 1, 'ld_lymph_dx_progressions', 'ld_lymph_dx_progressions', 0, 'ld lymph. progression');

DROP TABLE IF EXISTS `ld_lymph_dx_primaries`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_primaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `baseline_history_desc` text,
  `baseline_b_symptoms` char(1) DEFAULT '',
  `baseline_ecog` int(3) DEFAULT NULL,
  
  `tiss_histo_dx` text,  
  `bm_dx` varchar(20) DEFAULT '',  
  `bm_histo_dx` text,  
  `bm_histo_patho_nbr` varchar(20) DEFAULT '', 
  
  `nhl_stage_nbr` varchar(6) DEFAULT '',  
  `nhl_stage_alpha` varchar(6) DEFAULT '',  
  
  `cll_rai_stage` varchar(20) DEFAULT '',  
  
  `ipi` decimal(7,2) DEFAULT NULL,  
  `flipi` decimal(7,2) DEFAULT NULL,  
  `hd` decimal(7,2) DEFAULT NULL,  
  `mipi` decimal(7,2) DEFAULT NULL,  
  
  `pulmonary_comorbidity` char(1) DEFAULT '',
  `cardiac_comorbidity` char(1) DEFAULT '',
  `renal_comorbidity` char(1) DEFAULT '',
  `hepatic_comorbidity` char(1) DEFAULT '',
  `cns_comorbidity` char(1) DEFAULT '',
  `other_comorbidity` char(1) DEFAULT '',
  `comorbidities_precision` text,  
  
  `primary_hematologist` varchar(50) DEFAULT '',
    
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_dx_primaries`
  ADD CONSTRAINT `FK_ld_lymph_dx_primaries_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_dx_primaries_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_primaries_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  
  `baseline_history_desc` text,
  `baseline_b_symptoms` char(1) DEFAULT '',
  `baseline_ecog` int(3) DEFAULT NULL,
  
  `tiss_histo_dx` text,  
  `bm_dx` varchar(20) DEFAULT '',  
  `bm_histo_dx` text,  
  `bm_histo_patho_nbr` varchar(20) DEFAULT '', 
  
  `nhl_stage_nbr` varchar(6) DEFAULT '',  
  `nhl_stage_alpha` varchar(6) DEFAULT '',  
  
  `cll_rai_stage` varchar(20) DEFAULT '',  
  
  `ipi` decimal(7,2) DEFAULT NULL,  
  `flipi` decimal(7,2) DEFAULT NULL,  
  `hd` decimal(7,2) DEFAULT NULL,  
  `mipi` decimal(7,2) DEFAULT NULL,  
  
  `pulmonary_comorbidity` char(1) DEFAULT '',
  `cardiac_comorbidity` char(1) DEFAULT '',
  `renal_comorbidity` char(1) DEFAULT '',
  `hepatic_comorbidity` char(1) DEFAULT '',
  `cns_comorbidity` char(1) DEFAULT '',
  `other_comorbidity` char(1) DEFAULT '',
  `comorbidities_precision` text,  
  
  `primary_hematologist` varchar(50) DEFAULT '',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_primaries');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_primary number' AND `language_label`='primary_number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_survival time' AND `language_label`='survival time months' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_hematologist_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''hematologist'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('hematologist', '1', '50');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_0_to_4', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("0","0"),("1","1"),("2","2"),("3","3"),("4","4");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'primary_hematologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_hematologist_list') , '0', '', '', '', 'primary hematologist', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'baseline_history_desc', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'baseline history desc', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'baseline_b_symptoms', 'yes_no',  NULL , '0', '', '', '', 'baseline b symptoms', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'pulmonary_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'pulmonary comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'cardiac_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'cardiac comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'renal_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'renal comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'cns_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'cns comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'other_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'other comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'comorbidities_precision', 'input',  NULL , '0', 'size=10', '', '', 'comorbidities precision', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'hepatic_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'hepatic comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'baseline_ecog', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_0_to_4') , '0', '', '', '', 'baseline ecog', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='primary_hematologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_hematologist_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary hematologist' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='baseline_history_desc' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='baseline history desc' AND `language_tag`=''), '1', '30', 'baseline', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='baseline_b_symptoms' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline b symptoms' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='pulmonary_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pulmonary comorbidity' AND `language_tag`=''), '1', '40', 'comorbidities', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='cardiac_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cardiac comorbidity' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='renal_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='renal comorbidity' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='cns_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cns comorbidity' AND `language_tag`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='other_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other comorbidity' AND `language_tag`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='comorbidities_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='comorbidities precision' AND `language_tag`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='hepatic_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hepatic comorbidity' AND `language_tag`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='baseline_ecog' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_0_to_4')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline ecog' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_bone_marrow_dx', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("positive","positive"),("negative","negative"),("not diagnosed","not diagnosed");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_bone_marrow_dx"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_bone_marrow_dx"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_bone_marrow_dx"),  
(SELECT id FROM structure_permissible_values WHERE value="not diagnosed" AND language_alias="not diagnosed"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'tiss_histo_dx', 'textarea',  NULL , '0', 'rows=2,cols=30', '', '', 'tiss histo dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'bm_dx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx') , '0', '', '', '', 'bm dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'bm_histo_dx', 'textarea', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx') , '0', 'rows=2,cols=30', '', '', 'bm histo dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'bm_histo_patho_nbr', 'input',  NULL , '0', 'size=15', '', '', 'bm histo patho nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='tiss_histo_dx' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='tiss histo dx' AND `language_tag`=''), '2', '60', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='bm_dx' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bm dx' AND `language_tag`=''), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='bm_histo_dx' AND `type`='textarea' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx')  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='bm histo dx' AND `language_tag`=''), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='bm_histo_patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='bm histo patho nbr' AND `language_tag`=''), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET  `type`='textarea',  `setting`='rows=2,cols=30' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_primaries' AND field='comorbidities_precision' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_nhl_stage_nbr', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("I","I"),("II","II"),("III","III"),("IV","IV");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="I" AND language_alias="I"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="II" AND language_alias="II"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="III" AND language_alias="III"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV"), "4", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_nhl_stage_alpha', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("A","A"),("B","B"),("C","C");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_alpha"),  
(SELECT id FROM structure_permissible_values WHERE value="A" AND language_alias="A"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_alpha"),  
(SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="B"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_alpha"),  
(SELECT id FROM structure_permissible_values WHERE value="C" AND language_alias="C"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'nhl_stage_nbr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_nbr') , '0', '', '', '', 'nhl stage', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'nhl_stage_alpha', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_alpha') , '0', '', '', '', '', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'cll_rai_stage', 'input',  NULL , '0', 'size=5', '', '', 'cll rai stage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='nhl_stage_nbr' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_nbr')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nhl stage' AND `language_tag`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='nhl_stage_alpha' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_alpha')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='cll_rai_stage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cll rai stage' AND `language_tag`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'mipi', 'float',  NULL , '0', 'size=5', '', '', 'prognosis mipi', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'hd', 'float',  NULL , '0', 'size=5', '', '', 'prognosis hd', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'flipi', 'float',  NULL , '0', 'size=5', '', '', 'prognosis flipi', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_primaries', 'ipi', 'float',  NULL , '0', 'size=5', '', '', 'prognosis ipi', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='mipi' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis mipi' AND `language_tag`=''), '2', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='hd' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis hd' AND `language_tag`=''), '2', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='flipi' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis flipi' AND `language_tag`=''), '2', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='ipi' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis ipi' AND `language_tag`=''), '2', '80', 'prognosis', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_primaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_primaries' AND `field`='nhl_stage_nbr' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_nbr') AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES 
('A' , 'A'),
('B' , 'B'),
('baseline' , 'Baseline'),
('baseline b symptoms' , 'B Symptoms'),
('baseline ecog' , 'ECOG'),
('baseline history desc' , 'History'),
('bm dx' , 'Bone Marrow'),
('bm histo dx' , 'B.M. Histological Dx'),
('bm histo patho nbr' , 'Pathology Number'),
('C' , 'C'),
('cardiac comorbidity' , 'Cardiac'),
('cll rai stage' , 'CLL RAI'),
('cns comorbidity' , 'Central Nervous System'),
('comorbidities' , 'Comorbidities'),
('comorbidities precision' , 'Precision'),
('hepatic comorbidity' , 'Hepatic'),
('I' , 'I'),
('II' , 'II'),
('III' , 'III'),
('IV' , 'IV'),
('ld lymph. diagnostic' , 'LD Lymph. Diagnostic'),
('ld lymph. progression' , 'LD Lymph. Progression'),
('nhl stage' , 'NHL'),
('not diagnosed' , 'Not Diagnosed'),
('other comorbidity' , 'Other'),
('primary hematologist' , 'Primary Hematologist'),
('prognosis' , 'Prognosis'),
('prognosis flipi' , 'FLIPI'),
('prognosis hd' , 'HD'),
('prognosis ipi' , 'IPI'),
('prognosis mipi' , 'MIPI'),
('pulmonary comorbidity' , 'Pulmonary'),
('renal comorbidity' , 'Renal'),
('tiss histo dx' , 'Histological Dx');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("progression","progression");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="origin"),  
(SELECT id FROM structure_permissible_values WHERE value="progression" AND language_alias="progression"), "1", "1");

UPDATE structure_value_domains_permissible_values SET flag_active = '0'
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="origin")
AND structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values WHERE (value="progression" AND language_alias="progression") OR (value="primary" AND language_alias="primary"));

INSERT INTO i18n (id,en) VALUES 
("a progression should be linked to an existing diagnoses group", "A progression should be linked to an existing diagnoses group!"),
("the diagnoses group of a diagnosis can not be changed","The diagnoses group of a diagnosis can not be changed!"),
("a new diagnostic should be linked to a new diagnoses group","A new diagnostic should be linked to a new diagnoses group!"),
('all progression of the group should be deleted frist', 'All progression of the group should be deleted frist!');

CREATE TABLE IF NOT EXISTS `ld_lymph_dx_progressions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `site` varchar(100) DEFAULT '',  
  `trt_at_progression` varchar(50) DEFAULT '',  
  `stem_cell_transplant` char(1) DEFAULT '',  
  `stem_cell_transplant_date` date DEFAULT NULL,
  `stem_cell_transplant_date_accuracy` char(1) NOT NULL DEFAULT '',

  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_dx_progressions`
  ADD CONSTRAINT `FK_ld_lymph_dx_progressions_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_dx_progressions_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  
  `site` varchar(100) DEFAULT '',  
  `trt_at_progression` varchar(50) DEFAULT '',  
  `stem_cell_transplant` char(1) DEFAULT '',  
  `stem_cell_transplant_date` date DEFAULT NULL,
  `stem_cell_transplant_date_accuracy` char(1) NOT NULL DEFAULT '',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_progressions');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_primary number' AND `language_label`='primary_number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('digestive-anal','digestive-anal'),
('digestive-appendix','digestive-appendix'),
('digestive-bile ducts','digestive-bile ducts'),
('digestive-colonic','digestive-colonic'),
('digestive-esophageal','digestive-esophageal'),
('digestive-gallbladder','digestive-gallbladder'),
('digestive-liver','digestive-liver'),
('digestive-pancreas','digestive-pancreas'),
('digestive-rectal','digestive-rectal'),
('digestive-small intestine','digestive-small intestine'),
('digestive-stomach','digestive-stomach'),
('digestive-other digestive','digestive-other digestive'),
('thoracic-lung','thoracic-lung'),
('thoracic-mesothelioma','thoracic-mesothelioma'),
('thoracic-other thoracic','thoracic-other thoracic'),
('ophthalmic-eye','ophthalmic-eye'),
('ophthalmic-other eye','ophthalmic-other eye'),
('breast-breast','breast-breast'),
('female genital-cervical','female genital-cervical'),
('female genital-endometrium','female genital-endometrium'),
('female genital-fallopian tube','female genital-fallopian tube'),
('female genital-gestational trophoblastic neoplasia','female genital-gestational trophoblastic neoplasia'),
('female genital-ovary','female genital-ovary'),
('female genital-peritoneal','female genital-peritoneal'),
('female genital-uterine','female genital-uterine'),
('female genital-vulva','female genital-vulva'),
('female genital-vagina','female genital-vagina'),
('female genital-other female genital','female genital-other female genital'),
('head & neck-larynx','head & neck-larynx'),
('head & neck-nasal cavity and sinuses','head & neck-nasal cavity and sinuses'),
('head & neck-lip and oral cavity','head & neck-lip and oral cavity'),
('head & neck-pharynx','head & neck-pharynx'),
('head & neck-thyroid','head & neck-thyroid'),
('head & neck-salivary glands','head & neck-salivary glands'),
('head & neck-other head & neck','head & neck-other head & neck'),
('haematological-leukemia','haematological-leukemia'),
('haematological-lymphoma','haematological-lymphoma'),
('haematological-hodgkin''s disease','haematological-hodgkin''s disease'),
('haematological-non-hodgkin''s lymphomas','haematological-non-hodgkin''s lymphomas'),
('haematological-other haematological','haematological-other haematological'),
('skin-melanoma','skin-melanoma'),
('skin-non melanomas','skin-non melanomas'),
('skin-other skin','skin-other skin'),
('urinary tract-bladder','urinary tract-bladder'),
('urinary tract-renal pelvis and ureter','urinary tract-renal pelvis and ureter'),
('urinary tract-kidney','urinary tract-kidney'),
('urinary tract-urethra','urinary tract-urethra'),
('urinary tract-other urinary tract','urinary tract-other urinary tract'),
('central nervous system-brain','central nervous system-brain'),
('central nervous system-spinal cord','central nervous system-spinal cord'),
('central nervous system-other central nervous system','central nervous system-other central nervous system'),
('musculoskeletal sites-soft tissue sarcoma','musculoskeletal sites-soft tissue sarcoma'),
('musculoskeletal sites-bone','musculoskeletal sites-bone'),
('musculoskeletal sites-other bone','musculoskeletal sites-other bone'),
('other-primary unknown','other-primary unknown'),
('other-gross metastatic disease','other-gross metastatic disease');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ld_lymph_tumour_site', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="breast-breast" AND language_alias="breast-breast"), "1", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-brain" AND language_alias="central nervous system-brain"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-spinal cord" AND language_alias="central nervous system-spinal cord"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-other central nervous system" AND language_alias="central nervous system-other central nervous system"), "12", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-anal" AND language_alias="digestive-anal"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-appendix" AND language_alias="digestive-appendix"), "22", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-bile ducts" AND language_alias="digestive-bile ducts"), "23", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-colonic" AND language_alias="digestive-colonic"), "24", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-esophageal" AND language_alias="digestive-esophageal"), "25", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-gallbladder" AND language_alias="digestive-gallbladder"), "26", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-liver" AND language_alias="digestive-liver"), "27", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-pancreas" AND language_alias="digestive-pancreas"), "28", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-rectal" AND language_alias="digestive-rectal"), "29", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-small intestine" AND language_alias="digestive-small intestine"), "30", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-stomach" AND language_alias="digestive-stomach"), "31", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-other digestive" AND language_alias="digestive-other digestive"), "32", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-cervical" AND language_alias="female genital-cervical"), "40", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-endometrium" AND language_alias="female genital-endometrium"), "41", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-fallopian tube" AND language_alias="female genital-fallopian tube"), "42", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-gestational trophoblastic neoplasia" AND language_alias="female genital-gestational trophoblastic neoplasia"), "43", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-ovary" AND language_alias="female genital-ovary"), "44", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-peritoneal" AND language_alias="female genital-peritoneal"), "45", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-uterine" AND language_alias="female genital-uterine"), "46", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vulva" AND language_alias="female genital-vulva"), "47", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vagina" AND language_alias="female genital-vagina"), "48", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-other female genital" AND language_alias="female genital-other female genital"), "49", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-leukemia" AND language_alias="haematological-leukemia"), "60", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-lymphoma" AND language_alias="haematological-lymphoma"), "61", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-non-hodgkin's lymphomas" AND language_alias="haematological-non-hodgkin's lymphomas"), "62", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-hodgkin's disease" AND language_alias="haematological-hodgkin's disease"), "63", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-other haematological" AND language_alias="haematological-other haematological"), "64", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-larynx" AND language_alias="head & neck-larynx"), "70", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-lip and oral cavity" AND language_alias="head & neck-lip and oral cavity"), "71", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-nasal cavity and sinuses" AND language_alias="head & neck-nasal cavity and sinuses"), "72", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-pharynx" AND language_alias="head & neck-pharynx"), "73", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-salivary glands" AND language_alias="head & neck-salivary glands"), "74", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-thyroid" AND language_alias="head & neck-thyroid"), "75", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-other head & neck" AND language_alias="head & neck-other head & neck"), "76", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-bone" AND language_alias="musculoskeletal sites-bone"), "80", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-soft tissue sarcoma" AND language_alias="musculoskeletal sites-soft tissue sarcoma"), "81", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-other bone" AND language_alias="musculoskeletal sites-other bone"), "82", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-eye" AND language_alias="ophthalmic-eye"), "116", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-other eye" AND language_alias="ophthalmic-other eye"), "117", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-melanoma" AND language_alias="skin-melanoma"), "121", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-non melanomas" AND language_alias="skin-non melanomas"), "122", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-other skin" AND language_alias="skin-other skin"), "123", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-lung" AND language_alias="thoracic-lung"), "133", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-mesothelioma" AND language_alias="thoracic-mesothelioma"), "134", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-other thoracic" AND language_alias="thoracic-other thoracic"), "135", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-bladder" AND language_alias="urinary tract-bladder"), "144", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-kidney" AND language_alias="urinary tract-kidney"), "145", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-renal pelvis and ureter" AND language_alias="urinary tract-renal pelvis and ureter"), "146", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-urethra" AND language_alias="urinary tract-urethra"), "147", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-other urinary tract" AND language_alias="urinary tract-other urinary tract"), "148", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-primary unknown" AND language_alias="other-primary unknown"), "255", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-gross metastatic disease" AND language_alias="other-gross metastatic disease"), "256", "1");

INSERT INTO i18n (id,en) VALUES 
('digestive-anal','Digestive - Anal'),
('digestive-appendix','Digestive - Appendix'),
('digestive-bile ducts','Digestive - Bile Ducts'),
('digestive-colonic','Digestive - Colonic'),
('digestive-esophageal','Digestive - Esophageal'),
('digestive-gallbladder','Digestive - Gallbladder'),
('digestive-liver','Digestive - Liver'),
('digestive-pancreas','Digestive - Pancreas'),
('digestive-rectal','Digestive - Rectal'),
('digestive-small intestine','Digestive - Small Intestine'),
('digestive-stomach','Digestive - Stomach'),
('digestive-other digestive','Digestive - Other Digestive'),
('thoracic-lung','Thoracic - Lung'),
('thoracic-mesothelioma','Thoracic - Mesothelioma'),
('thoracic-other thoracic','Thoracic - Other Thoracic'),
('ophthalmic-eye','Ophthalmic - Eye'),
('ophthalmic-other eye','Ophthalmic - Other Eye'),
('breast-breast','Breast - Breast'),
('female genital-cervical','Female Genital - Cervical'),
('female genital-endometrium','Female Genital - Endometrium'),
('female genital-fallopian tube','Female Genital - Fallopian Tube'),
('female genital-gestational trophoblastic neoplasia','Female Genital - Gestational Trophoblastic Neoplasia'),
('female genital-ovary','Female Genital - Ovary'),
('female genital-peritoneal','Female Genital - Peritoneal'),
('female genital-uterine','Female Genital - Uterine'),
('female genital-vulva','Female Genital - Vulva'),
('female genital-vagina','Female Genital - Vagina'),
('female genital-other female genital','Female Genital - Other Female Genital'),
('head & neck-larynx','Head & Neck - Larynx'),
('head & neck-nasal cavity and sinuses','Head & Neck - Nasal Cavity and Sinuses'),
('head & neck-lip and oral cavity','Head & Neck - Lip and Oral Cavity'),
('head & neck-pharynx','Head & Neck - Pharynx'),
('head & neck-thyroid','Head & Neck - Thyroid'),
('head & neck-salivary glands','Head & Neck - Salivary Glands'),
('head & neck-other head & neck','Head & Neck - Other Head & Neck'),
('haematological-leukemia','Haematological - Leukemia'),
('haematological-lymphoma','Haematological - Lymphoma'),
('haematological-hodgkin''s disease','Haematological - Hodgkin''s Disease'),
('haematological-non-hodgkin''s lymphomas','Haematological - Non-Hodgkin''s Lymphomas'),
('haematological-other haematological','Haematological-Other Haematological'),
('skin-melanoma','Skin - Melanoma'),
('skin-non melanomas','Skin - Non Melanomas'),
('skin-other skin','Skin - Other Skin'),
('urinary tract-bladder','Urinary Tract - Bladder'),
('urinary tract-renal pelvis and ureter','Urinary Tract - Renal Pelvis and Ureter'),
('urinary tract-kidney','Urinary Tract - Kidney'),
('urinary tract-urethra','Urinary Tract - Urethra'),
('urinary tract-other urinary tract','Urinary Tract - Other Urinary Tract'),
('central nervous system-brain','Central Nervous System - Brain'),
('central nervous system-spinal cord','Central Nervous System - Spinal Cord'),
('central nervous system-other central nervous system','Central Nervous System - Other Central Nervous System'),
('musculoskeletal sites-soft tissue sarcoma','Musculoskeletal Sites - Soft Tissue Sarcoma'),
('musculoskeletal sites-bone','Musculoskeletal Sites - Bone'),
('musculoskeletal sites-other bone','Musculoskeletal Sites - Other Bone'),
('other-primary unknown','Other - Primary Unknown'),
('other-gross metastatic disease','Other - Gross Metastatic Disease');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_trt_at_progression', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''treatment at progression'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('treatment at progression', '1', '50');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_tumour_site') , '0', '', '', '', 'site', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'trt_at_progression', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_trt_at_progression') , '0', '', '', '', 'trt at progression', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'stem_cell_transplant', 'yes_no',  NULL , '0', '', '', '', 'stem cell transplant', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'stem_cell_transplant_date', 'date',  NULL , '0', '', '', '', 'stem cell transplant date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_tumour_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='trt_at_progression' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_trt_at_progression')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='trt at progression' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='stem_cell_transplant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stem cell transplant' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='stem_cell_transplant_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stem cell transplant date' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('site','Site'),
('trt at progression','Treatment at Progression'),
('stem cell transplant','Stem Cell Transplant'),
('stem cell transplant date','SCT Date'),
('sct','SCT');

UPDATE structure_fields SET  `language_label`='sct' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_progressions' AND field='stem_cell_transplant' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='stem cell transplant' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='stem_cell_transplant' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "100", "1");

UPDATE event_controls SET flag_active = 0;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'follow up', 1, 'ld_lymph_followup', 'ed_all_clinical_followups', 0, 'clinical|ld lymph.|follow up');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_followup');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='vital_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='vital_status_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='vital status' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'p/e and imaging', 1, 'ld_lymph_ed_imagings', 'ld_lymph_ed_imagings', 0, 'clinical|ld lymph.|p/e and imaging');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_imagings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL DEFAULT '0',
  
  `nodules_nbr` int(4) DEFAULT null,  
  `largest_tumor_diam_cm` decimal(7,2) DEFAULT null,  
  `nbr_of_extranodal_sites` int(4) DEFAULT null,  
  `extranodal_sites_list` text,    
  `imaging_type` varchar(10) DEFAULT null,   
  `imaging_type_other` varchar(50) DEFAULT null,   
  
  `lymph_node_for_petsuv_waldeyers_ring` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_cervical_left` char(1) DEFAULT '',    
  `lymph_node_for_petsuv_cervical_right` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_mediastinal` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_axillary_left` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_axillary_right` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_spleen` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_mesenteric` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_para_aortic_left` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_para_aortic_right` char(1) DEFAULT '',    
  `lymph_node_for_petsuv_linguinal_left` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_linguinal_right` char(1) DEFAULT '',    
  `lymph_node_for_petsuv_other` char(1) DEFAULT '',  
  `initial_pet_suv_max` int(4) DEFAULT null,    

  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_ed_imagings`
  ADD CONSTRAINT `FK_ld_lymph_ed_imagings_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_imagings_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  
  `lymph_node_for_petsuv_waldeyers_ring` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_cervical_left` char(1) DEFAULT '',    
  `lymph_node_for_petsuv_cervical_right` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_mediastinal` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_axillary_left` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_axillary_right` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_spleen` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_mesenteric` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_para_aortic_left` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_para_aortic_right` char(1) DEFAULT '',    
  `lymph_node_for_petsuv_linguinal_left` char(1) DEFAULT '',        
  `lymph_node_for_petsuv_linguinal_right` char(1) DEFAULT '',    
  `lymph_node_for_petsuv_other` char(1) DEFAULT '',  
  `initial_pet_suv_max` int(4) DEFAULT null,  
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_imagings');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_imaging_type', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("CT","CT"),("PET","PET"),("US","US"),("CXR","CXR"),("other","other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="CT" AND language_alias="CT"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="PET" AND language_alias="PET"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="US" AND language_alias="US"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="CXR" AND language_alias="CXR"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "5", "1");

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'ld_lymph_ed_imagings');
DELETE FROM structure_fields WHERE tablename = 'ld_lymph_ed_imagings';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'nodules_nbr', 'integer',  NULL , '0', 'size=3', '', '', 'nbr of nodules', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'largest_tumor_diam_cm', 'float',  NULL , '0', 'size=3', '', '', 'largest tumor diam cm', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'extranodal_sites_list', 'textarea',  NULL , '0', 'rows=2,cols=30', '', '', 'extranodal sites list', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'imaging_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_imaging_type') , '0', '', '', '', 'imaging type', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'imaging_type_other', 'input',  NULL , '0', 'size=10', '', '', 'imaging type other', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_waldeyers_ring', 'yes_no',  NULL , '0', '', '', '', 'lymph node waldeyers ring', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_cervical_left', 'yes_no',  NULL , '0', '', '', '', 'lymph node cervical left', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_cervical_right', 'yes_no',  NULL , '0', '', '', '', 'lymph node cervical right', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_mediastinal', 'yes_no',  NULL , '0', '', '', '', 'lymph node mediastinal', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_axillary_left', 'yes_no',  NULL , '0', '', '', '', 'lymph node axillary left', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_axillary_right', 'yes_no',  NULL , '0', '', '', '', 'lymph node axillary right', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_spleen', 'yes_no',  NULL , '0', '', '', '', 'lymph node spleen', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_mesenteric', 'yes_no',  NULL , '0', '', '', '', 'lymph node mesenteric', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_para_aortic_left', 'yes_no',  NULL , '0', '', '', '', 'lymph node para aortic left', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_para_aortic_right', 'yes_no',  NULL , '0', '', '', '', 'lymph node para aortic right', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_linguinal_left', 'yes_no',  NULL , '0', '', '', '', 'lymph node linguinal left', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_linguinal_right', 'yes_no',  NULL , '0', '', '', '', 'lymph node linguinal right', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_other', 'yes_no',  NULL , '0', '', '', '', 'lymph node other', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'initial_pet_suv_max', 'integer',  NULL , '0', '', '', '', 'initial pet suv max', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='nodules_nbr' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='nbr of nodules' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='largest_tumor_diam_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='largest tumor diam cm' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='extranodal_sites_list' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='extranodal sites list' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_imaging_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='imaging type' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='imaging type other' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_waldeyers_ring' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node waldeyers ring' AND `language_tag`=''), '2', '30', 'score', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_cervical_left' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node cervical left' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_cervical_right' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node cervical right' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_mediastinal' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node mediastinal' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_axillary_left' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node axillary left' AND `language_tag`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_axillary_right' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node axillary right' AND `language_tag`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_spleen' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node spleen' AND `language_tag`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_mesenteric' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node mesenteric' AND `language_tag`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_para_aortic_left' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node para aortic left' AND `language_tag`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_para_aortic_right' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node para aortic right' AND `language_tag`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_linguinal_left' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node linguinal left' AND `language_tag`=''), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_linguinal_right' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node linguinal right' AND `language_tag`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_other' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node other' AND `language_tag`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='initial_pet_suv_max' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='initial pet suv max' AND `language_tag`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('CT' ,'CT'),
('CXR' ,'CXR'),
('extranodal sites list' ,'Extranodal Sites List'),
('imaging type' ,'Imaging Type'),
('imaging type other' ,'Other precision'),
('initial pet suv max' ,'Initial PET SUV: max'),
('largest tumor diam cm' ,'Largest Tumor diameter (cm)'),
('ld lymph.' ,'LD Lymph.'),
('lymph node axillary left' ,'Axillary - Left'),
('lymph node axillary right' ,'Axillary - Right'),
('lymph node cervical left' ,'Cervical - Left'),
('lymph node cervical right' ,'Cervical - Right'),
('lymph node linguinal left' ,'Linguinal - Left'),
('lymph node linguinal right' ,'Linguinal - Right'),
('lymph node mediastinal' ,'Mediastinal'),
('lymph node mesenteric' ,'Mesenteric'),
('lymph node other' ,'Other'),
('lymph node para aortic left' ,'Para Aortic - Left'),
('lymph node para aortic right' ,'Para Aortic - Right'),
('lymph node spleen' ,'Spleen'),
('lymph node waldeyers ring' ,'Waldeyer''s Ring'),
('nbr of nodules' ,'Nbr of Nodules'),
('p/e and imaging' ,'P/E and Imaging'),
('PET' ,'PET'),
('progression' ,'Progression'),
('US' ,'US');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='event_summary'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `field`='event_type'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  WHERE model='EventControl' AND tablename='event_controls' AND field='disease_site' AND `type`='input' AND structure_value_domain  IS NULL ;