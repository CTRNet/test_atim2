
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- End of custom_post267 script
-- (To limit the load of v268.* scripts for migration to v2.8)
-- ----------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('finish date (if applicable)','Finish Date (if applicable)','Date de fin (si applicable)'),
('last completed drug treatment', 'Last Completed Drug/Medication (Defined as finished)', 'Derniere prise de médicament complétée (définie comme terminé)'),
('ongoing drug treatment', 'Ongoing Drug/Medication (Defined as unfinished)', 'Médicament en cours (défini comme non-terminé)');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_next_followup_finish_date', 'date',  NULL , '0', '', '', '', 'finish date (if applicable)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_next_followup_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_next_followup_finish_date'), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE versions SET branch_build_number = '6513' WHERE version_number = '2.6.7';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Clean up cusm fields
-- ----------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE procure_ed_lab_pathologies 
  CHANGE cusm_marg_ext_seminal_vesicles_right cusm_deprecated_marg_ext_seminal_vesicles_right tinyint(1) DEFAULT '0',
  CHANGE cusm_marg_ext_seminal_vesicles_left cusm_deprecated_marg_ext_seminal_vesicles_left tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_right_anterior cusm_deprecated_e_p_ext_apex_right_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_left_anterior cusm_deprecated_e_p_ext_apex_left_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_right_posterior cusm_deprecated_e_p_ext_apex_right_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_left_posterior cusm_deprecated_e_p_ext_apex_left_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_right_anterior cusm_deprecated_e_p_ext_base_right_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_left_anterior cusm_deprecated_e_p_ext_base_left_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_right_posterior cusm_deprecated_e_p_ext_base_right_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_left_posterior cusm_deprecated_e_p_ext_base_left_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_seminal_vesicles_right cusm_deprecated_e_p_ext_seminal_vesicles_right tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_seminal_vesicles_left cusm_deprecated_e_p_ext_seminal_vesicles_left tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs
  CHANGE cusm_marg_ext_seminal_vesicles_right cusm_deprecated_marg_ext_seminal_vesicles_right tinyint(1) DEFAULT '0',
  CHANGE cusm_marg_ext_seminal_vesicles_left cusm_deprecated_marg_ext_seminal_vesicles_left tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_right_anterior cusm_deprecated_e_p_ext_apex_right_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_left_anterior cusm_deprecated_e_p_ext_apex_left_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_right_posterior cusm_deprecated_e_p_ext_apex_right_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_apex_left_posterior cusm_deprecated_e_p_ext_apex_left_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_right_anterior cusm_deprecated_e_p_ext_base_right_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_left_anterior cusm_deprecated_e_p_ext_base_left_anterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_right_posterior cusm_deprecated_e_p_ext_base_right_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_base_left_posterior cusm_deprecated_e_p_ext_base_left_posterior tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_seminal_vesicles_right cusm_deprecated_e_p_ext_seminal_vesicles_right tinyint(1) DEFAULT '0',
  CHANGE cusm_e_p_ext_seminal_vesicles_left cusm_deprecated_e_p_ext_seminal_vesicles_left tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_anterior' AND `language_label`='apex anterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_anterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_posterior' AND `language_label`='apex posterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_posterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_anterior' AND `language_label`='base anterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_anterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_posterior' AND `language_label`='base posterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_posterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_seminal_vesicles_left' AND `language_label`='' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_seminal_vesicles_right' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_left' AND `language_label`='seminal vesicles' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_right' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_anterior' AND `language_label`='apex anterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_anterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_posterior' AND `language_label`='apex posterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_posterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_anterior' AND `language_label`='base anterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_anterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_posterior' AND `language_label`='base posterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_posterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_seminal_vesicles_left' AND `language_label`='' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_seminal_vesicles_right' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_left' AND `language_label`='seminal vesicles' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_right' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_anterior' AND `language_label`='apex anterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_anterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_posterior' AND `language_label`='apex posterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_posterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_anterior' AND `language_label`='base anterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_anterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_posterior' AND `language_label`='base posterior' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_posterior' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_seminal_vesicles_left' AND `language_label`='' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_seminal_vesicles_right' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_left' AND `language_label`='seminal vesicles' AND `language_tag`='left' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_right' AND `language_label`='' AND `language_tag`='right' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

UPDATE structure_fields 
SET `language_label`='protocol (cusm field)' 
WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='procure_cusm_protocol' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('protocol (cusm field)', 'Protocol (MUHC field)', 'Protocole (Champ CUSM)');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Study and Order
-- ----------------------------------------------------------------------------------------------------------------------------------------

SELECT 'Change groups permissions to access both Order & Study' AS '###TODO###';
UPDATE menus SET flag_active = 1 WHERE use_link = '/Study/StudySummaries/search/';
UPDATE menus SET flag_active = 1 WHERE use_link = '/Order/Orders/search/';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6741' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6744' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- 2017-12-00
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Code to export a full dump for central server
-- Could be not used if we get agreement to do it automatically
-- -------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES(
	"Download data", 
	"Download data", 
	"Télécharger les données");

-- Code to import processing site data
-- -------------------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('returned to bank','Returned To Bank','Retourné à la banque',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from bank','Received From Bank','Recu de la banque',  '1', @control_id, NOW(), NOW(), 1, 1);

-- Created/Collected_by_bank field

UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- Create Missing Storage

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(39, 'rack20 (5X4)', 'position', 'integer', 20, NULL, NULL, NULL, 5, 4, 0, 0, 1, 0, 0, 1, '', 'std_racks', 'custom#storage types#rack20 (5X4)', 1),
(40, 'box100 1A-10J', 'column', 'integer', 10, 'row', 'alphabetical', 10, 0, 0, 0, 0, 0, 0, 0, 1, '', 'std_boxs', 'custom#storage types#box100 1A-10J', 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('rack20 (5X4)' ,'Rack 20 (5X4)', 'Râtelier 20 (5X4)', '1', @control_id, NOW(), '1', NOW(), '1'),
('box100 1A-10J' ,'Box100 1A-10J', 'Boîte100 1A-10J', '1', @control_id, NOW(), '1', NOW(), '1');












