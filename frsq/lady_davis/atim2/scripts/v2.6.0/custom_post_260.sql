-- --------------------------------------------------------------------------------------------------------
-- 'Participant Identifiers' demo report
-- --------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'RAMQ', 'input',  NULL , '1', 'size=20', '', '', 'RAMQ', ''), 
('Datamart', '0', '', 'JGH', 'input',  NULL , '1', 'size=20', '', '', 'JGH #', ''), 
('Datamart', '0', '', 'Sardo', 'input',  NULL , '0', 'size=20', '', '', 'Sardo #', ''), 
('Datamart', '0', '', 'Q_Q_CROC_03', 'input',  NULL , '0', 'size=20', '', '', 'Q-CROC-03', ''), 
('Datamart', '0', '', 'Breast_bank', 'input',  NULL , '0', 'size=20', '', '', 'Breast bank #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='RAMQ' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ' AND `language_tag`=''), '0', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='JGH' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='JGH #' AND `language_tag`=''), '0', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='Sardo' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='Sardo #' AND `language_tag`=''), '0', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='Q_Q_CROC_03' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='Q-CROC-03' AND `language_tag`=''), '0', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='Breast_bank' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='Breast bank #' AND `language_tag`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='BR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='PR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='hospital_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_fields SET field = 'Q_CROC_03' WHERE field = 'Q_Q_CROC_03';

-- -------------------------------------------------------------------------------------------------------------------------
-- txe_radiations
-- -------------------------------------------------------------------------------------------------------------------------

DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

-- -------------------------------------------------------------------------------------------------------------------------
-- structure_permissible_values_custom_controls
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET category = 'clinical - consent' WHERE name = 'Consent : Form language';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Collection : Blood type precision';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Collection : Tissue type precision';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Extraction : Method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Extraction : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Type';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Source';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Blood : Type';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Tumor location';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Storage method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory - quality control' WHERE name = 'Quality Ctrl : Type';

-- -------------------------------------------------------------------------------------------------------------------------
-- Path Review
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------
-- Disable sample type : saliva and csf
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(181, 183, 182, 185);

-- -------------------------------------------------------------------------------------------------------------------------
-- Event
-- -------------------------------------------------------------------------------------------------------------------------

update event_controls SET disease_site = '' WHERE flag_active = 1;

-- -------------------------------------------------------------------------------------------------------------------------
-- Treatment
-- -------------------------------------------------------------------------------------------------------------------------

update treatment_controls SET disease_site = '' WHERE flag_active = 1;

-- -------------------------------------------------------------------------------------------------------------------------
-- CLINICAL COLLECTION LINK
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

































-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '????' WHERE version_number = '2.6.0';
