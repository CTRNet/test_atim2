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











select 'isis' as msg;
exit;












--Section to review -----------------------------------------------------------------------------------






TODO
----------------------------------------------------------------------------------------------------------
Added new relationsips into databrowser
Please flag inactive relationsips if required (see queries below). Don't forget Collection to Annotation, Treatment,Consent, etc if not requried.
SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_
o_2 = 1 OR ctrl.flag_active_2_to_1 = 1);
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');
Please flag inactive datamart structure functions if required (see queries below).
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_struct
res WHERE model IN ('Model1', 'Model2', 'Model...'));
Please change datamart_structures_relationships_en(and fr).png in appwebrootimgdataBrowser
----------------------------------------------------------------------------------------------------------







-- -------------------------------------------------------------------------------------------------------------------------
-- Disable sample type : saliva and csf
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(188, 190, 189, 192);







-- --------------------------------------------------------------------------------------------------------
-- Added new relationsips into databrowser
-- Please flag unactive relationsips if required.
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str
SET fct.flag_active = 0 
WHERE fct.datamart_structure_id = str.id AND str.model IN ('DiagnosisMaster', 'TreatmentMaster', 'FamilyHistory', 'SpecimenReviewMaster', 'TreatmentExtendMaster', 'AliquotReviewMaster');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster', 'TreatmentMaster', 'FamilyHistory', 'SpecimenReviewMaster', 'TreatmentExtendMaster', 'AliquotReviewMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster', 'TreatmentMaster', 'FamilyHistory', 'SpecimenReviewMaster', 'TreatmentExtendMaster', 'AliquotReviewMaster'));











-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '????' WHERE version_number = '2.6.0';
