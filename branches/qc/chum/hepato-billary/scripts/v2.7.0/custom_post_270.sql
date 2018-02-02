-- Add notes into index view
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE `flag_detail`='1' AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE `flag_detail`='1' AND  structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Hepatic vein embolization
-- -----------------------------------------------------------------------------------------------------------------------------

INSERT INTO event_controls (event_group, event_type, flag_active, detail_form_alias,detail_tablename, databrowser_label)
VALUES
('medical_history', 'hepatic vein embolization medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history_pve', 'qc_hb_ed_hepatobiliary_medical_past_history_pves', 'medical_history|hepatic vein embolization medical past history');
INSERT INTO i18n (id,en, fr)
VALUES
('hepatic vein embolization medical past history', 'Hepatic Vein Embolization', '');

-- link a MiscIdentifier to a study.
-- -----------------------------------------------------------------------------------------------------------------------------

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
('study number', 1, 0, '', NULL, 0, 0, 0, 0, '', '', 1);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('study number', 'Study#', 'No. Étude');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Create PMT identifiers

SET @PMT_study_summary_id = (SELECT id FROM study_summaries WHERE deleted <> 1 AND title = 'PMT');
SET @study_misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'study number');
SET @cer_misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'CER#');
SET @system_user_id = (SELECT id FROM users WHERE username = 'system');
SET @system_date = (SELECT NOW() FROM users WHERE username = 'system');
UPDATE misc_identifiers
SET modified = @system_date, 
modified_by = @system_user_id, 
study_summary_id = @PMT_study_summary_id, 
misc_identifier_control_id = @study_misc_identifier_control_id,
identifier_value = REPLACE(identifier_value, 'PMT', '')
WHERE misc_identifier_control_id = @cer_misc_identifier_control_id
AND identifier_value LIKE 'PMT%'
AND deleted <> 1;
INSERT INTO misc_identifiers_revs
(id, identifier_value, misc_identifier_control_id, notes, participant_id, modified_by, version_created, tmp_deleted, flag_unique, study_summary_id)
(SELECT id, identifier_value, misc_identifier_control_id, notes, participant_id, modified_by, modified, tmp_deleted, flag_unique, study_summary_id
FROM misc_identifiers WHERE modified = @system_date AND modified_by = @system_user_id AND study_summary_id = @PMT_study_summary_id);

-- Create IVADO identifiers

SET @IVADO_study_summary_id = (SELECT id FROM study_summaries WHERE deleted <> 1 AND title = 'IVADO');
SET @study_misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'study number');
SET @cer_misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'CER#');
SET @system_user_id = (SELECT id FROM users WHERE username = 'system');
SET @system_date = (SELECT NOW() FROM users WHERE username = 'system');
UPDATE misc_identifiers
SET modified = @system_date, 
modified_by = @system_user_id, 
study_summary_id = @IVADO_study_summary_id, 
misc_identifier_control_id = @study_misc_identifier_control_id,
identifier_value = IF(identifier_value = 'IVADO#', 'N/D', REPLACE(identifier_value, 'IVADO#', ''))
WHERE misc_identifier_control_id = @cer_misc_identifier_control_id
AND identifier_value LIKE 'IVADO%'
AND deleted <> 1;
INSERT INTO misc_identifiers_revs
(id, identifier_value, misc_identifier_control_id, notes, participant_id, modified_by, version_created, tmp_deleted, flag_unique, study_summary_id)
(SELECT id, identifier_value, misc_identifier_control_id, notes, participant_id, modified_by, modified, tmp_deleted, flag_unique, study_summary_id
FROM misc_identifiers WHERE modified = @system_date AND modified_by = @system_user_id AND study_summary_id = @IVADO_study_summary_id);

-- Create IMAGIA identifiers

SET @IMAGIA_study_summary_id = (SELECT id FROM study_summaries WHERE deleted <> 1 AND title = 'IMAGIA');
SET @study_misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'study number');
SET @cer_misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'CER#');
SET @system_user_id = (SELECT id FROM users WHERE username = 'system');
SET @system_date = (SELECT NOW() FROM users WHERE username = 'system');
UPDATE misc_identifiers
SET modified = @system_date, 
modified_by = @system_user_id, 
study_summary_id = @IMAGIA_study_summary_id, 
misc_identifier_control_id = @study_misc_identifier_control_id,
identifier_value = REPLACE(identifier_value, 'IMAGIA#', '')
WHERE misc_identifier_control_id = @cer_misc_identifier_control_id
AND identifier_value LIKE 'IMAGIA%'
AND deleted <> 1;
INSERT INTO misc_identifiers_revs
(id, identifier_value, misc_identifier_control_id, notes, participant_id, modified_by, version_created, tmp_deleted, flag_unique, study_summary_id)
(SELECT id, identifier_value, misc_identifier_control_id, notes, participant_id, modified_by, modified, tmp_deleted, flag_unique, study_summary_id
FROM misc_identifiers WHERE modified = @system_date AND modified_by = @system_user_id AND study_summary_id = @IMAGIA_study_summary_id);

-- Create study consent
-- -----------------------------------------------------------------------------------------------------------------------------

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'study consent', 1, 'consent_masters_study', 'cd_nationals', 0, 'study consent');
INSERT INTO i18n (id,en,fr) VALUES ('study consent', 'Sudy Consent', 'Consentement d''étude');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_consent_study_summary_id'), 'notBlank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Create PMT consent obtained

SET @PMT_study_summary_id = (SELECT id FROM study_summaries WHERE deleted <> 1 AND title = 'PMT');
SET @study_consent_control_id = (SELECT id FROM consent_controls WHERE controls_type = 'study consent');
SET @system_user_id = (SELECT id FROM users WHERE username = 'system');
SET @system_date = (SELECT NOW() FROM users WHERE username = 'system');
INSERT INTO consent_masters (`consent_status`, `status_date`, `consent_signed_date`, `notes`, 
`participant_id`, `consent_control_id`, `study_summary_id`, 
`consent_signed_date_accuracy`, `status_date_accuracy`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT 'obtained', NULL, NULL, '', 
participant_id, @study_consent_control_id, @PMT_study_summary_id, 
'', '', @system_date, @system_date, @system_user_id, @system_user_id
FROM misc_identifiers WHERE study_summary_id = @PMT_study_summary_id);
INSERT INTO cd_nationals (`consent_master_id`) (SELECT id FROM consent_masters WHERE consent_control_id = @study_consent_control_id AND study_summary_id = @PMT_study_summary_id AND modified = @system_date AND modified_by = @system_user_id);
INSERT INTO consent_masters_revs (`participant_id`, `consent_control_id`, `consent_status`, `status_date`, `consent_signed_date`, `notes`, `study_summary_id`, `consent_signed_date_accuracy`, `status_date_accuracy`, `modified_by`, `id`, `version_created`)
(SELECT `participant_id`, `consent_control_id`, `consent_status`, `status_date`, `consent_signed_date`, `notes`, `study_summary_id`, `consent_signed_date_accuracy`, `status_date_accuracy`, `created_by`, `id`, `created` 
FROM consent_masters WHERE consent_control_id = @study_consent_control_id AND study_summary_id = @PMT_study_summary_id AND modified = @system_date AND modified_by = @system_user_id);
INSERT INTO cd_nationals_revs (`consent_master_id`, `version_created`)
(SELECT id, created 
FROM consent_masters WHERE consent_control_id = @study_consent_control_id AND study_summary_id = @PMT_study_summary_id AND modified = @system_date AND modified_by = @system_user_id);
UPDATE structure_formats SET `display_column`='0', `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');

-- Study
-- -----------------------------------------------------------------------------------------------------------------------------

ALTER TABLE `study_summaries` 
  ADD COLUMN `qc_hb_contact` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_hb_code` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_hb_institution` varchar(100) DEFAULT NULL,
  ADD COLUMN `qc_hb_ethical_approved` char(1) DEFAULT '',
  ADD COLUMN `qc_hb_ethical_approval_file_name` varchar(500) DEFAULT NULL,
  ADD COLUMN `qc_hb_mta_data_sharing_approved` char(1) DEFAULT '',
  ADD COLUMN `qc_hb_mta_data_sharing_approved_file_name` varchar(500) DEFAULT NULL,
  ADD COLUMN `qc_hb_pubmed_ids` text,
  ADD COLUMN `qc_hb_status` varchar(100) DEFAULT NULL;
ALTER TABLE `study_summaries_revs` 
  ADD COLUMN `qc_hb_contact` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_hb_code` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_hb_institution` varchar(100) DEFAULT NULL,
  ADD COLUMN `qc_hb_ethical_approved` char(1) DEFAULT '',
  ADD COLUMN `qc_hb_ethical_approval_file_name` varchar(500) DEFAULT NULL,
  ADD COLUMN `qc_hb_mta_data_sharing_approved` char(1) DEFAULT '',
  ADD COLUMN `qc_hb_mta_data_sharing_approved_file_name` varchar(500) DEFAULT NULL,
  ADD COLUMN `qc_hb_pubmed_ids` text,
  ADD COLUMN `qc_hb_status` varchar(100) DEFAULT NULL;  
UPDATE structure_permissible_values_custom_controls SET name = 'Institutions & Laboratories' WHERE name = 'Orders Institutions';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Institutions & Laboratories')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('Orders Institutions')";
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_hb_study_status', "StructurePermissibleValuesCustom::getCustomDropdown('Study Status')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Study Status', 1, 100, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Study Status');
SET @system_user_id = (SELECT id FROM users WHERE username = 'system');
SET @system_date = (SELECT NOW() FROM users WHERE username = 'system');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("pending", "Pending", 'En attente', '1', @control_id, @system_date, @system_date,@system_user_id, @system_user_id),
("approved", "Approved", 'Approuvée', '1', @control_id, @system_date, @system_date,@system_user_id, @system_user_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_hb_contact', 'input',  NULL , '0', '', '', '', 'contact', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_code', 'input',  NULL , '0', '', '', '', 'code', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='orders_institution') , '0', '', '', '', 'laboratory / institution', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_ethical_approved', 'yes_no',  NULL , '0', '', '', '', 'ethic', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_ethical_approval_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_mta_data_sharing_approved', 'yes_no',  NULL , '0', '', '', '', 'mta data sharing', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_mta_data_sharing_approved_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_pubmed_ids', 'textarea',  NULL , '0', 'cols=40,rows=1', '', '', 'pubmed ids', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_hb_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_study_status') , '0', '', '', '', 'status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_contact' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laboratory / institution' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_ethical_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethic' AND `language_tag`=''), '2', '1', 'approval', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_ethical_approval_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_mta_data_sharing_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta data sharing' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_mta_data_sharing_approved_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_pubmed_ids' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=1' AND `default`='' AND `language_help`='' AND `language_label`='pubmed ids' AND `language_tag`=''), '2', '20', 'literature', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_hb_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_study_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr)
VALUES
('literature','Literature','Literature'),
('pubmed ids','PubMed IDs','PubMed IDs');
INSERT INTO i18n (id,en,fr) 
VALUES
('approval', 'Approval', 'Approbation'),
('ethic', 'Ethic', 'éthique'),
('file name', 'File Name', 'Nom du fichier'),
('mta data sharing', 'MTA Data Sharing', 'Partage de matériels et de données');
INSERT INTO i18n (id,en,fr) VALUES ('laboratory / institution','Laboratory/Institution','Laboratoire/Institution');

-- Study Investigators

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators');
UPDATE structure_fields SET  `language_label`='name',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='last_name' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='email');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_hb_researchers', "StructurePermissibleValuesCustom::getCustomDropdown('Researchers')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Researchers', 1, 50, 'inventory');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_researchers') ,  `setting`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='last_name';
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='last_name'), 'notBlank', '');

-- Study Fundings

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_hb_study_fundings', "StructurePermissibleValuesCustom::getCustomDropdown('Study Fundings')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Study Fundings', 1, 50, 'study / project');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_study_fundings') ,  `setting`='' WHERE model='StudyFunding' AND tablename='study_fundings' AND field='study_sponsor' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='study_sponsor');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='study_sponsor'), 'notBlank', '');

-- Order
-- -----------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Order', 'orders', 'contact', 'input',  NULL , '0', '', '', 'the contact\'s name at the ordering institution', 'contact', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='contact' AND `type`='input' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='contact' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact') AND `flag_confidential`='0');
ALTER TABLE orders ADD COLUMN qc_hb_researcher VARCHAR(50) DEFAULT NULL;
ALTER TABLE orders_revs ADD COLUMN qc_hb_researcher VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Order', 'orders', 'qc_hb_researcher', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_researchers') , '0', '', '', '', 'researcher', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orders'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='qc_hb_researcher' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_researchers')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='researcher' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('researcher', 'Researcher', '');
SELECT id AS '###ERROR### An order already existst - Migration script has been created considering that no order exists' FROM orders;
UPDATE structure_formats SET `flag_override_label`='1', language_label = 'study / project' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- datamart_browsing_controls
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
PDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');

-- datamart_structure_functions 
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'SpecimenReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaBlock' AND label = 'create tma slide';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'create participant message (applied to all)';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add tma slide use';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlideUse' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';

-- Disable sample types:
-- -----------------------------------------------------------------------------------------------------------------------------

-- Xenograf + protein

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(187, 191, 193);

-- cord blood and nail

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(196, 213);

-- Treatment
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET use_detail_form_for_index = '1' WHERE flag_active = 1 AND disease_site NOT IN ('liver', 'pancreas');
UPDATE treatment_controls SET use_addgrid = '1' WHERE flag_active = 1 AND disease_site NOT IN ('liver', 'pancreas') AND treatment_extend_control_id IS NULL;

INSERT INTO structures(`alias`) VALUES ('qc_hb_txd_surgery_for_index');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='principal_surgery' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='principal surgery' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='associated_surgery_1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='associated surgery 1' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='associated_surgery_2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='associated surgery 2' AND `language_tag`=''), '1', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='associated_surgery_3' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='associated surgery 3' AND `language_tag`=''), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='local_treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='local treatment' AND `language_tag`=''), '1', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='type_of_local_treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_type_of_local_treatment')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of local treatment' AND `language_tag`=''), '1', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='other_organ_resection_1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other organ resection 1' AND `language_tag`=''), '1', '18', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='other_organ_resection_2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other organ resection 2' AND `language_tag`=''), '1', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='other_organ_resection_3' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other organ resection 3' AND `language_tag`=''), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='surgeon' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgeon' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='laparoscopy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion_diagnostic')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laparoscopy' AND `language_tag`=''), '1', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='operative_bleeding' AND `type`='integer_positive' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='operative bleeding' AND `language_tag`=''), '1', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='transfusions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transfusions' AND `language_tag`=''), '1', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='rbc_units' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='rbc units' AND `language_tag`=''), '1', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='plasma_units' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='plasma units' AND `language_tag`=''), '1', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='platelets_units' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='platelets units' AND `language_tag`=''), '1', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='drainage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drainage' AND `language_tag`=''), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='biological_glue' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biological glue' AND `language_tag`=''), '1', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='operative_ultrasound_ous' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='operative ultrasound ous' AND `language_tag`=''), '1', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='survival_time_in_months' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='survival time in months' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='cell_saver' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cell_saver' AND `language_tag`=''), '1', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_hb_operative_pathological_report' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='operative pathological report' AND `language_tag`=''), '1', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_hb_pathological_report_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='no.'), '1', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='phlebotomy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phlebotomy' AND `language_tag`=''), '1', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='gastric_tube_duration_in_days' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='gastric tube duration in days' AND `language_tag`=''), '2', '33', 'gastric tube', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='simultaneous_primary_resection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='simultaneous primary resection' AND `language_tag`=''), '2', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_for_index'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '2', '100', 'other', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Scan Request Number
-- -----------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'request_nbr', 'input',  NULL , '0', 'size=15', '', '', 'request number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_imaging_dateNSummary'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='request_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='request number' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  ADD COLUMN request_nbr VARCHAR(100) DEFAULT NULL;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  ADD COLUMN request_nbr VARCHAR(100) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_fibroscans', 'request_nbr', 'input',  NULL , '0', 'size=15', '', '', 'request number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_fibroscans'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_fibroscans'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_fibroscans' AND `field`='request_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='request number' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
ALTER TABLE qc_hb_ed_hepatobilary_fibroscans
  ADD COLUMN request_nbr VARCHAR(100) DEFAULT NULL;
ALTER TABLE qc_hb_ed_hepatobilary_fibroscans_revs
  ADD COLUMN request_nbr VARCHAR(100) DEFAULT NULL;

-- Database Tables Clean Up
-- -----------------------------------------------------------------------------------------------------------------------------

ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history_hepatitis` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history_hepatitis_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_txd_surgery_livers` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_txd_surgery_livers_revs` 
 	DROP COLUMN deleted_by; 	
ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history_cirrhoses` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history_cirrhoses_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_barcelonas` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_barcelonas_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_charlsons` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_charlsons_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_child_pughs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_child_pughs_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_clips` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_clips_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_fongs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_fongs_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_gretchs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_gretchs_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_melds` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_melds_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_okudas` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_ed_score_okudas_revs` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_txd_surgery_pancreas` 
 	DROP COLUMN deleted_by;
ALTER TABLE `qc_hb_txd_surgery_pancreas_revs` 
 	DROP COLUMN deleted_by;

DROP TABLE IF EXISTS misc_identifiers_to_delete;

ALTER TABLE ed_cap_report_gallbladders_revs MODIFY distance_of_invasive_carcinoma_from_closest_margin_mm decimal(5,1) DEFAULT NULL;







-----------------------------------------------------------------

je m'apercois que lorsque je veux créer un re-aliquoting à partir de tube de cellules, 
il n'y a pas de possibilité de soustraire le nombre de cellule utilisé car ATiM note 
seulement le volume utilisé mais pour les cellule c'est préférable de fonctionner en soustrayant 
le nbre de cellule car on re-aliquote toujours dans 1 ml de milieu lescellules restantes. Peux-tu faire quèquechose ?  
PAS FAIT





creaer numero de pax.







-- --------------------------------------------------------------------------------------------------------
-- VERSION
-- --------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = 'xxx' WHERE version_number = '2.7.0';
