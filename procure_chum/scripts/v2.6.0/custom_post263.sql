
ALTER TABLE versions ADD COLUMN `site_branch_build_number` varchar(45) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Version', 'versions', 'site_branch_build_number', 'input-readonly',  NULL , '0', 'size=25', '', '', 'site build number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='versions'), (SELECT id FROM structure_fields WHERE `model`='Version' AND `tablename`='versions' AND `field`='site_branch_build_number' AND `type`='input-readonly' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='site build number' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('site build number','Site Version/Build','Site Version/Numéro Version');

UPDATE versions SET branch_build_number = '5805' WHERE version_number = '2.6.3';

-- 201408?? --------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) 
VALUES
('approximatif pellet volume ml','Approximate volume (ml) of pellet (for 50 mL volume)','Volume (ml) approximatif du culot (pour volume de 50 mL)');

-- 20140826 --------------------------------------------------------------------------------------------------------------------

-- Reports review

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'list all related diagnosis';

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='bank_activty_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='obtained_consents_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_datetime_range_definition') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- Procure Report

INSERT INTO structures(`alias`) VALUES ('procure_report_criteria_and_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_pre_op_hormono', 'yes_no',  NULL , '0', '', '', '', 'hormonotherapy', ''), 
('Datamart', '0', '', 'procure_pre_op_chemo', 'yes_no',  NULL , '0', '', '', '', 'chemotherapy ', ''), 
('Datamart', '0', '', 'procure_pre_op_radio', 'yes_no',  NULL , '0', '', '', '', 'radiotherapy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,class=range file' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_hormono' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hormonotherapy' AND `language_tag`=''), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_chemo' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemotherapy ' AND `language_tag`=''), '0', '10', 'pre-operative treatment', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_radio' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiotherapy' AND `language_tag`=''), '0', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='biopsy_pre_surgery_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of biopsy prior to surgery' AND `language_tag`=''), '0', '20', 'diagnostic information', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_total_ng_ml' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total ng/ml' AND `language_tag`=''), '0', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_free_ng_ml' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='free ng/ml' AND `language_tag`=''), '0', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='path_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='path report number' AND `language_tag`=''), '0', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '30', 'pathology report', '0', '1', 'report date', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_post_op_hormono', 'yes_no',  NULL , '0', '', '', '', 'hormonotherapy', ''), 
('Datamart', '0', '', 'procure_post_op_chemo', 'yes_no',  NULL , '0', '', '', '', 'chemotherapy ', ''), 
('Datamart', '0', '', 'procure_post_op_radio', 'yes_no',  NULL , '0', '', '', '', 'radiotherapy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_post_op_hormono' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hormonotherapy' AND `language_tag`=''), '0', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_post_op_chemo' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemotherapy ' AND `language_tag`=''), '0', '40', 'post-operative treatment', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_post_op_radio' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiotherapy' AND `language_tag`=''), '0', '42', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_vital status' AND `language_label`='vital status' AND `language_tag`=''), '0', '100', 'death (follow-up worksheet)', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_date of death' AND `language_label`='date of death' AND `language_tag`=''), '0', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_cause_of_death' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_cause_of_death')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cause of death' AND `language_tag`=''), '0', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET language_label = 'chemotherapy' WHERE language_label = 'chemotherapy ';
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='psa prior to surgery', `flag_override_tag`='1', `language_tag`='total ng/ml' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_total_ng_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='1', `language_tag`='free ng/ml' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_free_ng_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='1', `language_tag`='date' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='vital status' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_inaccurate_date_use', 'yes_no',  NULL , '0', '', '', '', 'inaccurate date use', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_inaccurate_date_use' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inaccurate date use' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_pre_op_psa_date', 'date',  NULL , '0', '', '', '', 'psa prior to surgery in atim', 'date');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_psa_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='psa prior to surgery in atim' AND `language_tag`='date'), '0', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='total_ngml' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='total ng/ml' AND `language_tag`=''), '0', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_label`='date',  `language_tag`='' WHERE model='0' AND tablename='' AND field='procure_pre_op_psa_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='psa prior to surgery in atim' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_psa_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`) VALUES
(null, 'procure summary', 'list diagnosis information plus all pre/post operative treatments', 'procure_report_criteria_and_result', 'procure_report_criteria_and_result', 'index', 'procureParticipantReport', 1, NULL, 0, NULL, 0, 4);
SET @control_id = (SELECT ID FROM datamart_reports WHERE name = 'procure summary');
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, 4, 'procure summary', CONCAT('/Datamart/Reports/manageReport/',@control_id), 1, '');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('procure summary','PROCURE Summary', 'Résumé PROCURE'),
('list diagnosis information plus all pre/post operative treatments', 'List diagnosis information plus all pre/post operative treatments', 'Liste les informations de diagnostic ainsi que tous les traitements pré et post opératoires'),
('at least one participant is linked to more than one diagnosis or pathology worksheet','At least one participant is linked to more than one diagnosis or pathology worksheet','Au moins un participant est lié à plus d''une fiche de diagnostic ou de pathologie'),
('pre-operative treatment','Pre-Operative Treatment (in ATiM)','Traitement préopératoire (dans ATiM)'),
('post-operative treatment','Post-Operative Treatment (in ATiM)','Traitement postopératoire (dans ATiM)'),
('diagnostic information', 'Diagnostic', 'Diagnostic'),
('pathology report', 'Pathology Report', 'Rapport de pathologie'),
('hormonotherapy', 'Hormonotherapy', 'Hormonothérapie'),
('radiotherapy', 'Radiotherapy', 'Radiothérapie'),
('inaccurate date use','Inaccurate date use','Utilisation de dates approcimatives'),
('psa prior to surgery in atim','PSA prior to surgery (in ATiM)','APS pré-chirurgie (in ATiM)'),
('at least one participant summary is based on inaccurate date','At least one participant summary is based on inaccurate date','Au moins un résumé de participant est basé sur des dates inéxactes');

-- PSA / APS cleanup

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('aps', 'PSA', 'APS'),
('at least one APS or treatment or clinical event is linked to that followup form', 'At least one PSA, treatment or clinical event is defined for htis followup form', 'Au moins un APS, traitement ou événement clinique est défini pour ce formulaire de suivi'),
('procure follow-up worksheet - aps', 'F1 - Follow-up Worksheet :: PSA', 'F1 - Fiche de suivi du patient :: APS');

UPDATE versions SET branch_build_number = '5868' WHERE version_number = '2.6.3';

-- 20141110 ---------------------------------------------------------------------------------------------------------------------------------------
-- CHANGE MEDICATION AND FOLLOWUP WORKSHEETS
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- TreatmentMaster

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='treatment form identification' AND `language_tag`=''), '1', '-5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_method' AND `language_label`='type' AND `language_tag`=''), '1', '-4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list')  AND `flag_confidential`='0'), '1', '1', '', '0', '0', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='date/start date' AND `language_tag`=''), '1', '-3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('the worksheet date has to be completed', 'The worksheet date has to be completed', 'La date du formulaire doit être saisie');

-- Tx :: Treatment

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_treatment_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='dosage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='followup_event_master_id' AND `language_label`='follow-up worksheet identification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-46' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `language_label`='date/start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_start_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='followup_event_master_id' AND `language_label`='follow-up worksheet identification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='followup_event_master_id' AND `language_label`='follow-up worksheet identification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_txd_followup_worksheet_treatments DROP FOREIGN KEY procure_txd_followup_worksheet_treatments_ibfk_2;
ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN followup_event_master_id;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN followup_event_master_id;
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Tx :: MedicationWorksheets

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_medications') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='id_confirmation_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_medications') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `language_label`='treatment form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='id_confirmation_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='id_confirmation_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
SET TreatmentMaster.start_date = TreatmentDetail.id_confirmation_date, TreatmentMaster.start_date_accuracy = TreatmentDetail.id_confirmation_date_accuracy
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id;
UPDATE treatment_masters_revs TreatmentMaster, procure_txd_medications TreatmentDetail
SET TreatmentMaster.start_date = TreatmentDetail.id_confirmation_date, TreatmentMaster.start_date_accuracy = TreatmentDetail.id_confirmation_date_accuracy
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id;
ALTER TABLE procure_txd_medications DROP COLUMN id_confirmation_date;
ALTER TABLE procure_txd_medications_revs DROP COLUMN id_confirmation_date;
INSERT INTO i18n (id,en,fr) 
VALUES 
("at least one of the studied interval date is inaccurate","At least one of the studied interval dates is inaccurate","Au moins une des dates de l'intervalle étudié n'est pas précise"),
("treatments list from %start% to %end%", "Treatments list from %start% to %end%", 'Liste des traitements du %start% au %end%'),
("treatments list after %start%", "Treatments list after %start%", 'Liste des traitements après le %start%'),
("treatments list before %end%", "Treatments list before %end%", 'Liste des traitements avant le %end%'),
("unable to limit treatments list to a dates interval", "Unable to limit treatments list to a dates interval", "Impossible de limiter la liste des traitements à un intervalle de dates");

-- Tx :: MedicationWorksheets :: Drug

INSERT INTO treatment_controls (id, tx_method, disease_site, flag_active, detail_tablename, detail_form_alias, display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label, flag_use_for_ccl, treatment_extend_control_id) VALUES
(null, 'procure medication worksheet - drug', '', 1, 'procure_txd_medication_drugs', 'procure_txd_medication_drugs', 0, NULL, NULL, 'procure medication worksheet - drug', 0, NULL);
CREATE TABLE procure_txd_medication_drugs (
  dose varchar(50) DEFAULT NULL,
  duration varchar(50) DEFAULT NULL,
  drug_id int(11) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE procure_txd_medication_drugs_revs (
  dose varchar(50) DEFAULT NULL,
  duration varchar(50) DEFAULT NULL,
  drug_id int(11) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
ALTER TABLE `procure_txd_medication_drugs`
  ADD CONSTRAINT FK_procure_txd_medication_drugs_treatment_masters FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters (id),
  ADD CONSTRAINT FK_procure_txd_medication_drugs_drugs FOREIGN KEY (drug_id) REFERENCES drugs (id);
INSERT INTO i18n (id,en,fr) VALUES ('procure medication worksheet - drug', 'F1a - Medication Worksheet :: Drugs', 'F1a - Fiche des médicaments :: Médicaments');
INSERT INTO structures(`alias`) VALUES ('procure_txd_medication_drugs');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medication_drugs', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', 'help_drug_id', 'medication', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medication_drugs', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medication_drugs', 'duration', 'input',  NULL , '0', 'size=20', '', '', 'duration', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_medication_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medication_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medication_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='medication' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medication_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medication_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='duration' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='duration' AND `language_tag`=''), '1', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
SET @ctrl_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure medication worksheet - drug');
ALTER TABLE treatment_masters ADD COLUMN tmp_previous_treatment_extend_master_id int(11);
INSERT INTO treatment_masters (treatment_control_id, participant_id, procure_form_identification, 
created, created_by, modified, modified_by, deleted, tmp_previous_treatment_extend_master_id)
(SELECT @ctrl_id, TreatmentMaster.participant_id, 'TODO', 
TreatmentExtendMaster.created, TreatmentExtendMaster.created_by, TreatmentExtendMaster.modified, TreatmentExtendMaster.modified_by, TreatmentExtendMaster.deleted, TreatmentExtendMaster.id
FROM treatment_masters TreatmentMaster 
INNER JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentMaster.id = TreatmentExtendMaster.treatment_master_id
INNER JOIN procure_txe_medications TreatmentExtendDetail ON TreatmentExtendMaster.id = TreatmentExtendDetail.treatment_extend_master_id);
INSERT INTO procure_txd_medication_drugs (treatment_master_id, drug_id, duration, dose)
(SELECT TreatmentMaster.id, TreatmentExtendDetail.drug_id, TreatmentExtendDetail.duration, TreatmentExtendDetail.dose
FROM treatment_masters TreatmentMaster 
INNER JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentMaster.tmp_previous_treatment_extend_master_id = TreatmentExtendMaster.id
INNER JOIN procure_txe_medications TreatmentExtendDetail ON TreatmentExtendMaster.id = TreatmentExtendDetail.treatment_extend_master_id);
INSERT INTO treatment_masters_revs (id, treatment_control_id, participant_id, procure_form_identification, 
modified_by, version_created)
(SELECT TreatmentMaster.id, @ctrl_id, TreatmentMaster.participant_id, 'TODO', 
TreatmentExtendMaster.modified_by, TreatmentExtendMaster.version_created
FROM treatment_masters TreatmentMaster 
INNER JOIN treatment_extend_masters_revs TreatmentExtendMaster ON TreatmentMaster.tmp_previous_treatment_extend_master_id = TreatmentExtendMaster.id);
INSERT INTO procure_txd_medication_drugs_revs (dose, duration, drug_id, treatment_master_id, version_created)
(SELECT dose, duration, drug_id, TreatmentMaster.id, version_created
FROM treatment_masters TreatmentMaster 
INNER JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentMaster.tmp_previous_treatment_extend_master_id = TreatmentExtendMaster.id
INNER JOIN procure_txe_medications_revs TreatmentExtendDetail ON TreatmentExtendDetail.treatment_extend_master_id = TreatmentExtendMaster.id);
ALTER TABLE treatment_masters DROP COLUMN tmp_previous_treatment_extend_master_id;
UPDATE treatment_masters, participants SET procure_form_identification = CONCAT(participant_identifier, ' Vx -MEDx') WHERE  treatment_masters.participant_id = participants.id AND treatment_control_id = @ctrl_id AND procure_form_identification = 'TODO';
UPDATE treatment_masters_revs, participants SET procure_form_identification = CONCAT(participant_identifier, ' Vx -MEDx') WHERE  treatment_masters_revs.participant_id = participants.id AND treatment_control_id = @ctrl_id AND procure_form_identification = 'TODO';
DROP TABLE procure_txe_medications;
DROP TABLE procure_txe_medications_revs;
DELETE FROM treatment_extend_masters WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'procure_txe_medications');
DELETE FROM treatment_extend_masters_revs WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'procure_txe_medications');
UPDATE treatment_controls SET treatment_extend_control_id = null WHERE tx_method = 'procure medication worksheet';
DELETE FROM treatment_extend_controls WHERE detail_tablename = 'procure_txe_medications';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_medication_drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES ('open sale','Open Sale','Libre Service');

-- Event

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `field`='followup_event_master_id' AND `language_label`='follow-up worksheet identification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `field`='followup_event_master_id' AND `language_label`='follow-up worksheet identification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `field`='followup_event_master_id' AND `language_label`='follow-up worksheet identification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'procure_ed_%') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `language_label`='event form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_ed_clinical_followup_worksheet_aps DROP COLUMN followup_event_master_id;
ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs DROP COLUMN followup_event_master_id;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events DROP COLUMN followup_event_master_id;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs DROP COLUMN followup_event_master_id;
INSERT INTO i18n (id,en,fr) 
VALUES 
("%event% list from %start% to %end%", "%event% list from %start% to %end%", 'Liste des %event% du %start% au %end%'),
("%event% list after %start%", "%event% list after %start%", 'Liste des %event% après le %start%'),
("%event% list before %end%", "%event% list before %end%", 'Liste des %event% avant le %end%'),
("unable to limit data list to a dates interval", "Unable to limit data list to a dates interval", "Impossible de limiter la liste de données à un intervalle de dates");

-- Event :: Followup

UPDATE event_controls SET use_detail_form_for_index = '1' WHERE event_type = 'procure follow-up worksheet';
INSERT INTO i18n (id,en,fr) VALUES ('the visite date has to be completed', 'The visite date has to be completed', 'La date de la visite doit être saisie');

-- Remove Followup id confirmation date

SELECT Participant.participant_identifier AS "List of participants with 'Follow-up Visit Date' != 'Id Confirmation Date' (to correct because confirmation date field will be removed"
FROM participants Participant
INNER JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id
INNER JOIN procure_ed_clinical_followup_worksheets EventDetail ON EventDetail.event_master_id = EventMaster.id
WHERE EventMaster.deleted <> 1 AND EventMaster.event_date IS NOT NULL AND EventDetail.id_confirmation_date IS NOT NULL 
AND EventDetail.id_confirmation_date != EventMaster.event_date;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='id_confirmation_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='id_confirmation_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='id_confirmation_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_ed_clinical_followup_worksheets DROP COLUMN id_confirmation_date;
ALTER TABLE procure_ed_clinical_followup_worksheets_revs DROP COLUMN id_confirmation_date;

-- Change procure report name

UPDATE datamart_reports SET name = 'procure diagnosis and treatments summary' WHERE name = 'procure summary';
INSERT INTO i18n (id,en,fr) 
VALUES 
('procure diagnosis and treatments summary', 'PROCURE - Diagnosis & Treatments Summary', 'PROCURE - Résumé du diagnostic & traitments');

UPDATE versions SET branch_build_number = '5943' WHERE version_number = '2.6.3';

-- 20141120 ---------------------------------------------------------------------------------------------------------------------------------------
-- WORK ON Visit label and visit values of identification's form  + add missing statement of the previous commit
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Add missing statement in the previous release

ALTER TABLE procure_txd_medications DROP COLUMN id_confirmation_date_accuracy;
ALTER TABLE procure_txd_medications_revs DROP COLUMN id_confirmation_date_accuracy;
ALTER TABLE procure_ed_clinical_followup_worksheets DROP COLUMN id_confirmation_date_accuracy;
ALTER TABLE procure_ed_clinical_followup_worksheets_revs DROP COLUMN id_confirmation_date_accuracy;

-- Move collection visite custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'collection visit');
DELETE FROM `structure_permissible_values_customs` WHERE  control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'collection visit';
UPDATE structure_value_domains SET source=NULL WHERE domain_name="procure_collection_visit";
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('V01','V01'),
('V02','V02'),
('V03','V03'),
('V04','V04'),
('V05','V05'),
('V06','V06'),
('V07','V07'),
('V08','V08'),
('V09','V09'),
('V10','V10'),
('V11','V11'),
('V12','V12'),
('V13','V13'),
('V14','V14'),
('V15','V15'),
('V16','V16'),
('V17','V17'),
('V18','V18'),
('V19','V19');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V01" AND language_alias="V01"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V02" AND language_alias="V02"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V03" AND language_alias="V03"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V04" AND language_alias="V04"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V05" AND language_alias="V05"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V06" AND language_alias="V06"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V07" AND language_alias="V07"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V08" AND language_alias="V08"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V09" AND language_alias="V09"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V10" AND language_alias="V10"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V11" AND language_alias="V11"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V12" AND language_alias="V12"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V13" AND language_alias="V13"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V14" AND language_alias="V14"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V15" AND language_alias="V15"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V16" AND language_alias="V16"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V17" AND language_alias="V17"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V18" AND language_alias="V18"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="V19" AND language_alias="V19"), "", "1");
INSERT INTO i18n (id,en,fr)
VALUES 
('V01','V01','V01'),
('V02','V02','V02'),
('V03','V03','V03'),
('V04','V04','V04'),
('V05','V05','V05'),
('V06','V06','V06'),
('V07','V07','V07'),
('V08','V08','V08'),
('V09','V09','V09'),
('V10','V10','V10'),
('V11','V11','V11'),
('V12','V12','V12'),
('V13','V13','V13'),
('V14','V14','V14'),
('V15','V15','V15'),
('V16','V16','V16'),
('V17','V17','V17'),
('V18','V18','V18'),
('V19','V19','V19');

SELECT id as collection_id, procure_visit AS "Wrong PROCURE Visite format" FROM collections WHERE procure_visit not regexp('^V((0[1-9])|(1[0-9]))$') AND deleted <> 1;

-- Check form identification

-- SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM event_masters EventMaster
-- INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -PST[0-9]+$' 
-- AND deleted <> 1 AND EventControl.event_type = 'procure pathology report'
-- UNION ALL
-- SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM event_masters EventMaster
-- INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -FBP[0-9]+$' 
-- AND deleted <> 1 AND EventControl.event_type = 'procure diagnostic information worksheet'
-- UNION ALL
-- SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM event_masters EventMaster
-- INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -QUE[0-9]+$' 
-- AND deleted <> 1 AND EventControl.event_type = 'procure questionnaire administration worksheet'
-- UNION ALL
-- SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM event_masters EventMaster
-- INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -FSP[0-9]+$' 
-- AND deleted <> 1 AND EventControl.event_type = 'procure follow-up worksheet'
-- UNION ALL
-- SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM event_masters EventMaster
-- INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ Vx -FSPx$' 
-- AND deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');

-- SELECT participant_id, id AS consent_master_id, procure_form_identification as 'Wrong procure_form_identification' 
-- FROM consent_masters 
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -CSF[0-9x]+$' AND deleted <> 1;

-- SELECT TreatmentMaster.participant_id, TreatmentMaster.id AS treatment_master_id, TreatmentControl.tx_method, TreatmentMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM treatment_masters TreatmentMaster
-- INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -MED[0-9]+$' AND deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet'
-- UNION ALL 
-- SELECT TreatmentMaster.participant_id, TreatmentMaster.id AS treatment_master_id, TreatmentControl.tx_method, TreatmentMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM treatment_masters TreatmentMaster
-- INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ Vx -FSPx$' AND deleted <> 1 AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment'
-- UNION ALL 
-- SELECT TreatmentMaster.participant_id, TreatmentMaster.id AS treatment_master_id, TreatmentControl.tx_method, TreatmentMaster.procure_form_identification as 'Wrong procure_form_identification' 
-- FROM treatment_masters TreatmentMaster
-- INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
-- WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ Vx -MEDx$' AND deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet - drug';

-- 20141120 ---------------------------------------------------------------------------------------------------------------------------------------
-- Add PROCURE Follow-up report
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Create followup report

UPDATE datamart_reports SET 
function = 'procureDiagnosisAndTreatmentReports',
form_alias_for_results = 'procure_diagnosis_and_treatments_report_result'
WHERE name = 'procure diagnosis and treatments summary';
INSERT INTO structures(`alias`) VALUES ('procure_diagnosis_and_treatments_report_result');
SET @criteria_str_id = (SELECT id FROM structures WHERE alias='procure_report_criteria_and_result');
SET @result_str_id = (SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT @result_str_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`
FROM structure_formats WHERE structure_id = @criteria_str_id AND flag_index = '1');
DELETE FROM structure_formats WHERE structure_id = @criteria_str_id AND flag_search != '1';
INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`) VALUES
(null, 'procure followup summary', 'procure followup summary description', 'procure_report_criteria_and_result', 'procure_followups_report_result', 'index', 'procureFollowUpReports', 1, NULL, 0, NULL, 0, 4);
INSERT INTO i18n (id,en,fr) 
VALUES 
('procure followup summary', 'PROCURE - Patients Followup Summary', 'PROCURE - Résumé des suivis de patients'),
('procure followup summary description', 
'Display the Follow-up Worksheet Identification Codes plus the visites dates plus all specimens collected. All information will be grouped by visit.', 
'Affiche le code d''identification des fiches de suivi, les dates de visite ainsi que tous les spécimens collectés. Les informations seront regroupées par visite.');
INSERT INTO structures(`alias`) VALUES ('procure_followups_report_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_02_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_03_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_04_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_05_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_06_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_07_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_08_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_09_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_10_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_11_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_12_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_13_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_14_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_15_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_16_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_17_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_18_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_19_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_20_procure_form_identification', 'input',  NULL , '0', 'size=30', '', '', 'event form identification', ''), 
('Datamart', '0', '', 'procure_01_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_02_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_03_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_04_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_05_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_06_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_07_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_08_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_09_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_10_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_11_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_12_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_13_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_14_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_15_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_16_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_17_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_18_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_19_event_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_20_event_date', 'date',  NULL , '0', '', '', '', 'date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,class=range file' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_procure_form_identification'), '0', '10', 'V01', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_procure_form_identification'), '0', '20', 'V02', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_procure_form_identification'), '0', '30', 'V03', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_procure_form_identification'), '0', '40', 'V04', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_procure_form_identification'), '0', '50', 'V05', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_procure_form_identification'), '0', '60', 'V06', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_procure_form_identification'), '0', '70', 'V07', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_procure_form_identification'), '0', '80', 'V08', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_procure_form_identification'), '0', '90', 'V09', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_procure_form_identification'), '0', '100', 'V10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_procure_form_identification'), '0', '110', 'V11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_procure_form_identification'), '0', '120', 'V12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_procure_form_identification'), '0', '130', 'V13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_procure_form_identification'), '0', '140', 'V14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_procure_form_identification'), '0', '150', 'V15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_procure_form_identification'), '0', '160', 'V16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_procure_form_identification'), '0', '170', 'V17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_procure_form_identification'), '0', '180', 'V18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_procure_form_identification'), '0', '190', 'V19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_20_procure_form_identification'), '0', '200', 'V20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_event_date'), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_event_date'), '0', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_event_date'), '0', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_event_date'), '0', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_event_date'), '0', '51', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_event_date'), '0', '61', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_event_date'), '0', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_event_date'), '0', '81', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_event_date'), '0', '91', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_event_date'), '0', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_event_date'), '0', '111', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_event_date'), '0', '121', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_event_date'), '0', '131', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_event_date'), '0', '141', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_event_date'), '0', '151', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_event_date'), '0', '161', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_event_date'), '0', '171', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_event_date'), '0', '181', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_event_date'), '0', '191', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_20_event_date'), '0', '201', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET language_label = 'visite date' WHERE field like 'procure_%_event_date';

INSERT INTO i18n (id,en,fr)
VALUES 
('at least one patient is linked to more than one followup worksheet for the same visit', 'At least one patient is linked to more than one followup worksheet for the same visit', "Au moins un patient plus d'un formulaire de visite pour la même visite"),
('at least one procure form identification format is not supported', 'At least one procure form identification format is not supported', "Au moins un format de formulaire procure n'est pas supporté");
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_02_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_03_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_04_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_05_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_06_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_07_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_08_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_09_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_10_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_11_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_12_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_13_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_14_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_15_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_16_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_17_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_18_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_19_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 
('Datamart', '0', '', 'procure_20_paxgene_collected', 'yes_no',  NULL , '0', '', '', '', 'paxgene', ''), 

('Datamart', '0', '', 'procure_01_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_02_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_03_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_04_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_05_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_06_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_07_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_08_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_09_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_10_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_11_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_12_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_13_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_14_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_15_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_16_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_17_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_18_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_19_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 
('Datamart', '0', '', 'procure_20_k2_EDTA_collected', 'yes_no',  NULL , '0', '', '', '', 'k2-EDTA', ''), 

('Datamart', '0', '', 'procure_01_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_02_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_03_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_04_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_05_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_06_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_07_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_08_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_09_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_10_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_11_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_12_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_13_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_14_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_15_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_16_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_17_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_18_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_19_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 
('Datamart', '0', '', 'procure_20_serum_collected', 'yes_no',  NULL , '0', '', '', '', 'serum', ''), 		

('Datamart', '0', '', 'procure_01_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_02_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_03_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_04_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_05_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_06_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_07_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_08_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_09_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_10_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_11_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_12_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_13_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_14_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_15_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_16_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_17_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_18_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_19_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('Datamart', '0', '', 'procure_20_urine_collected', 'yes_no',  NULL , '0', '', '', '', 'urine', '');	

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_paxgene_collected'), '0', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_paxgene_collected'), '0', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_paxgene_collected'), '0', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_paxgene_collected'), '0', '42', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_paxgene_collected'), '0', '52', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_paxgene_collected'), '0', '62', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_paxgene_collected'), '0', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_paxgene_collected'), '0', '82', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_paxgene_collected'), '0', '92', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_paxgene_collected'), '0', '102', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_paxgene_collected'), '0', '112', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_paxgene_collected'), '0', '122', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_paxgene_collected'), '0', '132', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_paxgene_collected'), '0', '142', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_paxgene_collected'), '0', '152', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_paxgene_collected'), '0', '162', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_paxgene_collected'), '0', '172', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_paxgene_collected'), '0', '182', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_paxgene_collected'), '0', '192', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_20_paxgene_collected'), '0', '202', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
		
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_serum_collected'), '0', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_serum_collected'), '0', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_serum_collected'), '0', '33', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_serum_collected'), '0', '43', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_serum_collected'), '0', '53', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_serum_collected'), '0', '63', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_serum_collected'), '0', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_serum_collected'), '0', '83', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_serum_collected'), '0', '93', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_serum_collected'), '0', '103', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_serum_collected'), '0', '113', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_serum_collected'), '0', '123', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_serum_collected'), '0', '133', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_serum_collected'), '0', '143', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_serum_collected'), '0', '153', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_serum_collected'), '0', '163', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_serum_collected'), '0', '173', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_serum_collected'), '0', '183', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_serum_collected'), '0', '193', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_20_serum_collected'), '0', '203', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
		
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_k2_EDTA_collected'), '0', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_k2_EDTA_collected'), '0', '24', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_k2_EDTA_collected'), '0', '34', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_k2_EDTA_collected'), '0', '44', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_k2_EDTA_collected'), '0', '54', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_k2_EDTA_collected'), '0', '64', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_k2_EDTA_collected'), '0', '74', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_k2_EDTA_collected'), '0', '84', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_k2_EDTA_collected'), '0', '94', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_k2_EDTA_collected'), '0', '104', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_k2_EDTA_collected'), '0', '114', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_k2_EDTA_collected'), '0', '124', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_k2_EDTA_collected'), '0', '134', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_k2_EDTA_collected'), '0', '144', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_k2_EDTA_collected'), '0', '154', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_k2_EDTA_collected'), '0', '164', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_k2_EDTA_collected'), '0', '174', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_k2_EDTA_collected'), '0', '184', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_k2_EDTA_collected'), '0', '194', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_20_k2_EDTA_collected'), '0', '204', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
			
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_urine_collected'), '0', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_urine_collected'), '0', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_urine_collected'), '0', '35', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_urine_collected'), '0', '45', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_urine_collected'), '0', '55', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_urine_collected'), '0', '65', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_urine_collected'), '0', '75', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_urine_collected'), '0', '85', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_urine_collected'), '0', '95', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_urine_collected'), '0', '105', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_urine_collected'), '0', '115', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_urine_collected'), '0', '125', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_urine_collected'), '0', '135', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_urine_collected'), '0', '145', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_urine_collected'), '0', '155', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_urine_collected'), '0', '165', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_urine_collected'), '0', '175', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_urine_collected'), '0', '185', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_urine_collected'), '0', '195', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_20_urine_collected'), '0', '205', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
		
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND (`field` = 'procure_20_event_date' OR `field` = 'procure_20_procure_form_identification' OR `field`LIKE 'procure_20_%_collected'));
DELETE FROM structure_fields WHERE `plugin`='Datamart' AND `model`='0' AND (`field` = 'procure_20_event_date'  OR `field` = 'procure_20_procure_form_identification' OR `field`LIKE 'procure_20_%_collected');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_tissue_collected', 'yes_no',  NULL , '0', '', '', '', 'tissue', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_01_tissue_collected' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue' AND `language_tag`=''), '0', '16', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- 20141120 ---------------------------------------------------------------------------------------------------------------------------------------
-- Add PROCURE Aliquots Summary
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Create followup report

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`) VALUES
(null, 'procure aliquots summary', 'procure aliquots summary description', 'procure_report_criteria_and_result', 'procure_aliquots_report_result', 'index', 'procureAliquotsReports', 1, NULL, 0, NULL, 0, 4);
INSERT INTO i18n (id,en,fr) 
VALUES 
('procure aliquots summary', 'PROCURE - In Stock Aliquots Summary', 'PROCURE - Résumé des aliquots disponibles'),
('procure aliquots summary description', 
'Display the counts of ''In Stock'' aliquots grouped by visit and aliquot type.', 
'Affiche les nombres d''aliquots ''En Stock'' regroupés par visite et type d''aliquot.');

INSERT INTO structures(`alias`) VALUES ('procure_aliquots_report_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_02_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_03_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_04_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_05_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_06_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_07_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_08_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_09_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_10_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_11_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_12_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_13_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_14_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_15_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_16_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_17_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_18_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),
('Datamart', '0', '', 'procure_19_FRZ', 'integer',  NULL , '0', '', '', '', 'procure_label_FRZ', ''),

('Datamart', '0', '', 'procure_01_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_02_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_03_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_04_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_05_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_06_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_07_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_08_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_09_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_10_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_11_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_12_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_13_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_14_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_15_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_16_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_17_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_18_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),
('Datamart', '0', '', 'procure_19_Paraffin', 'integer',  NULL , '0', '', '', '', 'procure_label_Paraffin', ''),

('Datamart', '0', '', 'procure_01_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_02_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_03_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_04_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_05_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_06_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_07_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_08_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_09_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_10_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_11_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_12_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_13_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_14_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_15_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_16_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_17_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_18_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),
('Datamart', '0', '', 'procure_19_SER', 'integer',  NULL , '0', '', '', '', 'procure_label_SER', ''),

('Datamart', '0', '', 'procure_01_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_02_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_03_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_04_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_05_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_06_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_07_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_08_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_09_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_10_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_11_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_12_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_13_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_14_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_15_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_16_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_17_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_18_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),
('Datamart', '0', '', 'procure_19_PLA', 'integer',  NULL , '0', '', '', '', 'procure_label_PLA', ''),

('Datamart', '0', '', 'procure_01_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_02_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_03_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_04_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_05_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_06_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_07_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_08_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_09_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_10_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_11_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_12_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_13_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_14_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_15_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_16_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_17_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_18_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),
('Datamart', '0', '', 'procure_19_BFC', 'integer',  NULL , '0', '', '', '', 'procure_label_BFC', ''),

('Datamart', '0', '', 'procure_01_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_02_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_03_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_04_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_05_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_06_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_07_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_08_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_09_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_10_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_11_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_12_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_13_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_14_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_15_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_16_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_17_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_18_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),
('Datamart', '0', '', 'procure_19_WHT', 'integer',  NULL , '0', '', '', '', 'procure_label_WHT', ''),

('Datamart', '0', '', 'procure_01_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_02_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_03_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_04_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_05_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_06_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_07_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_08_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_09_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_10_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_11_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_12_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_13_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_14_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_15_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_16_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_17_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_18_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),
('Datamart', '0', '', 'procure_19_URN', 'integer',  NULL , '0', '', '', '', 'procure_label_URN', ''),

('Datamart', '0', '', 'procure_01_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_02_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_03_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_04_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_05_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_06_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_07_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_08_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_09_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_10_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_11_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_12_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_13_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_14_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_15_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_16_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_17_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_18_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),
('Datamart', '0', '', 'procure_19_RNA', 'integer',  NULL , '0', '', '', '', 'procure_label_RNA', ''),

('Datamart', '0', '', 'procure_01_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_02_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_03_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_04_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_05_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_06_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_07_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_08_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_09_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_10_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_11_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_12_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_13_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_14_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_15_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_16_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_17_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_18_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', ''),
('Datamart', '0', '', 'procure_19_DNA', 'integer',  NULL , '0', '', '', '', 'procure_label_DNA', '');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,class=range file' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_FRZ'), '0', '51', 'V01', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_Paraffin'), '0', '52', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_SER'), '0', '53', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_PLA'), '0', '54', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_BFC'), '0', '55', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_WHT'), '0', '56', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_URN'), '0', '57', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_RNA'), '0', '58', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_DNA'), '0', '59', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_SER'), '0', '61', 'V02', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_PLA'), '0', '62', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_BFC'), '0', '63', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_WHT'), '0', '64', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_URN'), '0', '65', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_RNA'), '0', '66', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_DNA'), '0', '67', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_SER'), '0', '71', 'V03', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_PLA'), '0', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_BFC'), '0', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_WHT'), '0', '74', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_URN'), '0', '75', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_RNA'), '0', '76', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_DNA'), '0', '77', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_SER'), '0', '81', 'V04', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_PLA'), '0', '82', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_BFC'), '0', '83', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_WHT'), '0', '84', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_URN'), '0', '85', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_RNA'), '0', '86', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_DNA'), '0', '87', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_SER'), '0', '91', 'V05', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_PLA'), '0', '92', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_BFC'), '0', '93', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_WHT'), '0', '94', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_URN'), '0', '95', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_RNA'), '0', '96', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_DNA'), '0', '97', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_SER'), '0', '101', 'V06', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_PLA'), '0', '102', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_BFC'), '0', '103', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_WHT'), '0', '104', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_URN'), '0', '105', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_RNA'), '0', '106', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_DNA'), '0', '107', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_SER'), '0', '111', 'V07', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_PLA'), '0', '112', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_BFC'), '0', '113', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_WHT'), '0', '114', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_URN'), '0', '115', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_RNA'), '0', '116', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_DNA'), '0', '117', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_SER'), '0', '121', 'V08', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_PLA'), '0', '122', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_BFC'), '0', '123', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_WHT'), '0', '124', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_URN'), '0', '125', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_RNA'), '0', '126', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_DNA'), '0', '127', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_SER'), '0', '131', 'V09', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_PLA'), '0', '132', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_BFC'), '0', '133', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_WHT'), '0', '134', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_URN'), '0', '135', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_RNA'), '0', '136', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_DNA'), '0', '137', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_SER'), '0', '141', 'V10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_PLA'), '0', '142', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_BFC'), '0', '143', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_WHT'), '0', '144', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_URN'), '0', '145', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_RNA'), '0', '146', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_DNA'), '0', '147', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_SER'), '0', '151', 'V11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_PLA'), '0', '152', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_BFC'), '0', '153', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_WHT'), '0', '154', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_URN'), '0', '155', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_RNA'), '0', '156', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_DNA'), '0', '157', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_SER'), '0', '161', 'V12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_PLA'), '0', '162', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_BFC'), '0', '163', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_WHT'), '0', '164', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_URN'), '0', '165', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_RNA'), '0', '166', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_DNA'), '0', '167', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_SER'), '0', '181', 'V13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_PLA'), '0', '182', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_BFC'), '0', '183', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_WHT'), '0', '184', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_URN'), '0', '185', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_RNA'), '0', '186', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_DNA'), '0', '187', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_SER'), '0', '191', 'V14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_PLA'), '0', '192', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_BFC'), '0', '193', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_WHT'), '0', '194', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_URN'), '0', '195', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_RNA'), '0', '196', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_DNA'), '0', '197', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_SER'), '0', '201', 'V15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_PLA'), '0', '202', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_BFC'), '0', '203', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_WHT'), '0', '204', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_URN'), '0', '205', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_RNA'), '0', '206', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_DNA'), '0', '207', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_SER'), '0', '211', 'V16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_PLA'), '0', '212', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_BFC'), '0', '213', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_WHT'), '0', '214', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_URN'), '0', '215', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_RNA'), '0', '216', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_DNA'), '0', '217', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_SER'), '0', '221', 'V17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_PLA'), '0', '222', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_BFC'), '0', '223', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_WHT'), '0', '224', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_URN'), '0', '225', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_RNA'), '0', '226', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_DNA'), '0', '227', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_SER'), '0', '231', 'V18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_PLA'), '0', '232', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_BFC'), '0', '233', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_WHT'), '0', '234', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_URN'), '0', '235', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_RNA'), '0', '236', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_DNA'), '0', '237', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),


((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_SER'), '0', '241', 'V19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_PLA'), '0', '242', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_BFC'), '0', '243', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_WHT'), '0', '244', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_URN'), '0', '245', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_RNA'), '0', '246', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_DNA'), '0', '247', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_02_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_03_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_04_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_05_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_06_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_07_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_08_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_09_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_10_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_11_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_12_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_13_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_14_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_15_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_16_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_17_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_18_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', ''),
('Datamart', '0', '', 'procure_19_RNB', 'integer',  NULL , '0', '', '', '', 'procure_label_RNB', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_RNB'), '0', '54', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_RNB'), '0', '62', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_RNB'), '0', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_RNB'), '0', '82', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_RNB'), '0', '92', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_RNB'), '0', '102', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_RNB'), '0', '112', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_RNB'), '0', '122', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_RNB'), '0', '132', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_RNB'), '0', '142', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_RNB'), '0', '152', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_RNB'), '0', '162', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_RNB'), '0', '182', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_RNB'), '0', '192', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_RNB'), '0', '202', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_RNB'), '0', '212', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_RNB'), '0', '222', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_RNB'), '0', '232', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_RNB'), '0', '242', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO i18n (id,en,fr) 
VALUES
('procure_label_FRZ','FRZ','FRZ'),
('procure_label_Paraffin','Paraffin','Paraffin'),
('procure_label_SER','SER','SER'),
('procure_label_RNB','RNB','RNB'),
('procure_label_PLA','PLA','PLA'),
('procure_label_BFC','BFC','BFC'),
('procure_label_WHT','WHT','WHT'),
('procure_label_URN','URN','URN'),
('procure_label_RNA','RNA','RNA'),
('procure_label_DNA','DNA','DNA');

REPLACE INTO i18n (id,en,fr) VALUES ('inaccurate date use','Inaccurate date use','Utilisation de dates approximatives');

UPDATE versions SET branch_build_number = '5950' WHERE version_number = '2.6.3';

-- 201411?? ---------------------------------------------------------------------------------------------------------------------------------------
-- Fix Bug
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- CHANGE datamart_browsing_results

ALTER TABLE datamart_browsing_results MODIFY  id_csv longtext NOT NULL;

-- Add refrigeration date

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'procure_refrigeration_time', 'time',  NULL , '0', '', '', '', 'refrigeration time', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='procure_refrigeration_time' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='refrigeration time' AND `language_tag`=''), '0', '502', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('refrigeration time','Refrigeration/Ice Time','Heure de réfrigération/glace');
ALTER TABLE specimen_details ADD COLUMN `procure_refrigeration_time` time DEFAULT NULL;
ALTER TABLE specimen_details_revs ADD COLUMN `procure_refrigeration_time` time DEFAULT NULL;

-- Change Questionnaire Version List

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('questionnaire version')" WHERE domain_name = 'procure_questionnaire_version';

-- i18n procure medication worksheet - drug

REPLACE INTO i18n (id,en,fr) VALUES ('procure medication worksheet - drug', 'F1a - Medication Worksheet :: Drugs', 'F1a - Fiche des médicaments :: Molécules/Médicaments');

-- Change field for questionnaire defined as complete

ALTER TABLE procure_ed_lifestyle_quest_admin_worksheets ADD COLUMN complete char(1) DEFAULT '';
ALTER TABLE procure_ed_lifestyle_quest_admin_worksheets_revs ADD COLUMN complete char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'complete', 'yes_no',  NULL , '0', '', '', '', 'complete', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='complete' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complete' AND `language_tag`=''), '1', '36', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
DELETE FROM i18n WHERE id = 'complete';
INSERT INTO i18n (id,en,fr) VALUES ('complete', 'Complete', 'Complet');
SELECT verification_result AS 'unmigrated verification_result' FROM procure_ed_lifestyle_quest_admin_worksheets WHERE verification_result NOT IN ('', 'complete', 'incomplete');
UPDATE procure_ed_lifestyle_quest_admin_worksheets SET complete = 'y' WHERE verification_result = 'complete';
UPDATE procure_ed_lifestyle_quest_admin_worksheets SET complete = 'n' WHERE verification_result = 'incomplete';
UPDATE procure_ed_lifestyle_quest_admin_worksheets_revs SET complete = 'y' WHERE verification_result = 'complete';
UPDATE procure_ed_lifestyle_quest_admin_worksheets_revs SET complete = 'n' WHERE verification_result = 'incomplete';
ALTER TABLE procure_ed_lifestyle_quest_admin_worksheets DROP COLUMN verification_result;
ALTER TABLE procure_ed_lifestyle_quest_admin_worksheets_revs DROP COLUMN verification_result;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Questionnaire verification result');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'Questionnaire verification result';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='verification_result' AND `language_label`='result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_verification_result') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='verification_result' AND `language_label`='result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_verification_result') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='verification_result' AND `language_label`='result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_verification_result') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_value_domains WHERE domain_name = 'procure_questionnaire_verification_result';

-- Add copy/past control on add treatment in batch form

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '3', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0');

-- Change dosage to posologie in i18n and form

DELETE FROM i18n WHERE id =  'dosage';
INSERT INTO i18n (id,en,fr) VALUES ('dosage','Dosage','Posologie');
UPDATE structure_fields SET  `language_label`='dosage' WHERE model='TreatmentDetail' AND tablename='procure_txd_medication_drugs' AND field='dose' AND `type`='input' AND structure_value_domain  IS NULL ;

-- Add curitherapy

SELECT 'WARNING: Added curitherapy to treatment list' as '### MESSAGE ###';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup medical treatment types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('curietherapy','Curietherapy','Curiethérapie',  '1', @control_id, NOW(), NOW(), 1, 1);

-- Add hormonotherapy and chemotherapy to drug list

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="0" WHERE svd.domain_name='procure_drug_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="prostate" AND language_alias="prostate");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), (SELECT id FROM structure_permissible_values WHERE value="chemotherapy" AND language_alias="chemotherapy"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("hormonotherapy", "hormonotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), (SELECT id FROM structure_permissible_values WHERE value="hormonotherapy" AND language_alias="hormonotherapy"), "1", "1");
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='type'), 'notEmpty');
SELECT id, generic_name AS 'drug generic_name with no type' FROM drugs where type IS NULL OR type = '';
INSERT INTO structure_value_domains (domain_name, source) 
VALUES
('procure_medication_list', 'Drug.Drug::getMedicationPermissibleValues'),
('procure_treatment_drug_list', 'Drug.Drug::getTreatmentDrugPermissibleValues');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_medication_list')  WHERE model='TreatmentDetail' AND tablename='procure_txd_medication_drugs' AND field='drug_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list');
ALTER TABLE procure_txd_followup_worksheet_treatments ADD COLUMN drug_id int(11) DEFAULT NULL;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs ADD COLUMN drug_id int(11) DEFAULT NULL;
ALTER TABLE procure_txd_followup_worksheet_treatments ADD CONSTRAINT FK_procure_txd_followup_worksheet_treatments_drugs FOREIGN KEY (drug_id) REFERENCES drugs (id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list') , '0', '', '', '', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('the type of the selected drug does not match the selected treatment type', 'The type of the selected drug does not match the selected treatment type', 'Le type du médicament sélectionné ne correspond pas au type du traitement sélectionné');

-- version

UPDATE versions SET branch_build_number = '5964' WHERE version_number = '2.6.3';

-- Add treatment site for radiotherapy

ALTER TABLE procure_txd_followup_worksheet_treatments ADD COLUMN treatment_site varchar(100) DEFAULT NULL;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs ADD COLUMN treatment_site varchar(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_treatment_site', "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment site\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Treatment site', 'clinical - treatment', '100');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'treatment_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment site');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('prostate bed','Prostate Bed','Loge prostatique',  '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO i18n (id,en,fr) VALUES ('no site has to be associated to the selected treatment type', 'No site has to be associated to the selected treatment type','Aucun site ne doit être défini pour le type du traitement sélectionné');

UPDATE versions SET branch_build_number = '5973' WHERE version_number = '2.6.3';

-- 2014-12-08

-- changed cart completed date to datetime

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_whatman_papers', 'procure_card_completed_datetime', 'datetime',  NULL , '0', '', '', '', 'card completed at', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='card completed at' AND `language_tag`=''), '1', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0', '0');
ALTER TABLE ad_whatman_papers ADD COLUMN procure_card_completed_datetime DATETIME DEFAULT NULL;
ALTER TABLE ad_whatman_papers_revs ADD COLUMN procure_card_completed_datetime DATETIME DEFAULT NULL;
ALTER TABLE ad_whatman_papers ADD COLUMN procure_card_completed_datetime_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE ad_whatman_papers_revs ADD COLUMN procure_card_completed_datetime_accuracy char(1) NOT NULL DEFAULT '';
SELECT 'TODO: Changed cart completed time to datetime. Whatman paper initial storage datetime should be empty. Validate before to go live.' AS '### MESSAGE ###'; 
SELECT 'Unable to set procure_card_completed_datetime' AS '### MESSAGE ###', SpecimenDetail.sample_master_id, AliquotMaster.barcode, SpecimenDetail.reception_datetime, SpecimenDetail.reception_datetime_accuracy, AliquotDetail.procure_card_completed_at, AliquotDetail.procure_card_completed_datetime
FROM sample_masters SampleMaster
INNEr JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN ad_whatman_papers AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
WHERE AliquotMaster.deleted <> 1
AND AliquotDetail.procure_card_completed_at IS NOT NULL AND AliquotDetail.procure_card_completed_at NOT LIKE ''
AND (SpecimenDetail.reception_datetime_accuracy NOT IN ('c','i','h') OR SpecimenDetail.reception_datetime IS NULL OR SpecimenDetail.reception_datetime LIKE '');
UPDATE sample_masters SampleMaster, specimen_details SpecimenDetail, aliquot_masters AliquotMaster, ad_whatman_papers AliquotDetail
SET AliquotDetail.procure_card_completed_datetime = CONCAT(SUBSTR(SpecimenDetail.reception_datetime,1,10), ' ', AliquotDetail.procure_card_completed_at), AliquotDetail.procure_card_completed_datetime_accuracy = 'c'
WHERE SpecimenDetail.sample_master_id = SampleMaster.id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotDetail.aliquot_master_id = AliquotMaster.id
AND AliquotMaster.deleted <> 1
AND AliquotDetail.procure_card_completed_at IS NOT NULL AND AliquotDetail.procure_card_completed_at NOT LIKE ''
AND SpecimenDetail.reception_datetime_accuracy IN ('c','i','h') AND SpecimenDetail.reception_datetime IS NOT NULL AND SpecimenDetail.reception_datetime NOT LIKE '';
UPDATE sample_masters SampleMaster, specimen_details SpecimenDetail, aliquot_masters AliquotMaster, ad_whatman_papers_revs AliquotDetail
SET AliquotDetail.procure_card_completed_datetime = CONCAT(SUBSTR(SpecimenDetail.reception_datetime,1,10), ' ', AliquotDetail.procure_card_completed_at), AliquotDetail.procure_card_completed_datetime_accuracy = 'c'
WHERE SpecimenDetail.sample_master_id = SampleMaster.id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotDetail.aliquot_master_id = AliquotMaster.id
AND AliquotMaster.deleted <> 1
AND AliquotDetail.procure_card_completed_at IS NOT NULL AND AliquotDetail.procure_card_completed_at NOT LIKE ''
AND SpecimenDetail.reception_datetime_accuracy IN ('c','i','h') AND SpecimenDetail.reception_datetime IS NOT NULL AND SpecimenDetail.reception_datetime NOT LIKE '';
SELECT 'Time of whatman paper card not mirgated. To complete manually (Field replaced by date time).' AS '### MESSAGE ###', AliquotMaster.id, AliquotMaster.barcode, procure_card_completed_at
FROM aliquot_masters AliquotMaster
INNER JOIN ad_whatman_papers AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
WHERE procure_card_completed_at IS NOT NULL AND procure_card_completed_at NOT LIKE ''
AND (procure_card_completed_datetime IS NULL OR procure_card_completed_datetime LIKE '')
AND AliquotMaster.deleted <> 1;
ALTER TABLE ad_whatman_papers DROP COLUMN procure_card_completed_at;
ALTER TABLE ad_whatman_papers_revs DROP COLUMN procure_card_completed_at;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_at' AND `language_label`='card completed at' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_at' AND `language_label`='card completed at' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='procure_card_completed_at' AND `language_label`='card completed at' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('no storage datetime has to be completed for whatman paper',"No 'Initial Storage Date' has to be completed for whatman paper",'Aucune date initiale d''entreposage ne doit être saisie pour un papier whatman');

-- Add field study to drugs....

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Drug', 'Drug', 'drugs', 'procure_study', 'yes_no',  NULL , '0', '', 'y', '', 'study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='drugs'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='procure_study' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='y' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE drugs ADD COLUMN procure_study char(1) default '';
ALTER TABLE drugs_revs ADD COLUMN procure_study char(1) default '';
UPDATE structure_fields SET  `default`='n' WHERE model='Drug' AND tablename='drugs' AND field='procure_study' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr) VALUES ('the type of a used drug can not be changed', 'The type of a already used drug can not be changed', 'Le type d''un médicament déjà utilisé ne peut être changé');
UPDATE structure_fields SET language_label = 'clinical study or experimental treatment' WHERE field = 'procure_study' AND model = 'Drug';
INSERT INTO i18n (id,en,fr) VALUES ('clinical study or experimental treatment', 'Clinical Study/Experimental Treatment', 'Étude clinique/Traitement expérimental');
ALTER TABLE drugs MODIFY procure_study tinyint(1) DEFAULT '0';
ALTER TABLE drugs_revs MODIFY procure_study tinyint(1) DEFAULT '0';
UPDATE structure_fields SET  `type`='checkbox',  `default`='' WHERE model='Drug' AND tablename='drugs' AND field='procure_study' AND `type`='yes_no' AND structure_value_domain  IS NULL ;

-- ADD bcr

ALTER TABLE procure_ed_clinical_followup_worksheet_aps ADD COLUMN biochemical_relapse char(1) default '';
ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs ADD COLUMN biochemical_relapse char(1) default '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_aps', 'biochemical_relapse', 'yes_no',  NULL , '0', '', '', '', 'biochemical relapse', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_aps'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='biochemical_relapse' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biochemical relapse' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('biochemical relapse','Biochemical Relapse','Récidive biochimique');  
UPDATE structure_fields SET  `language_help`='procure_ed_followup_worksheet_aps_help' WHERE model='EventDetail' AND tablename='procure_ed_clinical_followup_worksheet_aps' AND field='biochemical_relapse' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr) VALUES ('procure_ed_followup_worksheet_aps_help', 'Superior or equal to 0.2ng/ml', 'Supérieure ou égale à 0,2 ng / ml');

-- Add scan result

ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events ADD COLUMN results VARCHAR(50) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs ADD COLUMN results VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_followup_exam_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'Exam Results\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Exam Results', 'clinical - annotation', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Exam Results');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive','Positif',  '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative','Négatif',  '1', @control_id, NOW(), NOW(), 1, 1),
('suspicious','Suspicious','Suspect',  '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_results') , '0', '', '', '', 'result', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Add scan site

ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events ADD COLUMN sites VARCHAR(100) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs ADD COLUMN sites VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_followup_exam_sites', "StructurePermissibleValuesCustom::getCustomDropdown(\'Exam Sites\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Exam Sites', 'clinical - annotation', '100');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'sites', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_sites') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='sites' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' ), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='results' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_results') AND `flag_confidential`='0');

-- Remove curitherapy

SELECT 'Curietherapy to remove. Should be replaced by radio-brachy. See: ' , participant_id, treatment_master_id FROM treatment_masters INNER JOIN procure_txd_followup_worksheet_treatments ON id = treatment_master_id WHERE deleted <> 1 AND treatment_type = 'curietherapy';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup medical treatment types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value = 'curietherapy';

-- Add prostatectomy

SELECT 'WARNING: Added prostatectomy to treatment list' as '### MESSAGE ###';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup medical treatment types');
-- INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
-- VALUES
-- ('prostatectomy','Prostatectomy','Prostatectomie',  '1', @control_id, NOW(), NOW(), 1, 1);

-- Treatment type to remove

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='type (to remove)' WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field='type' AND `type`='input' AND structure_value_domain  IS NULL ;
SELECT 'WARNING: Treatment type (text field renamed to [type (to remove)]) should not be used anymore. User has to complete field [type] (drop down list) created in v251.' AS '### MESSAGE ###'
UNION ALL
SELECT 'WARNING: Field [type (to remove)] should now be removed.' AS '### MESSAGE ###'
UNION ALL
SELECT 'TODO 1: Check data have been correctly migrated to [type] field and add clean up if required (use following query to list data).' AS '### MESSAGE ###'
UNION ALL
SELECT "SELECT DISTINCT TreatmentDetail.treatment_type, TreatmentDetail.type, Drug.type, Drug.generic_name FROM treatment_masters TreatmentMaster INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id WHERE TreatmentMaster.deleted <> 1 ORDER by TreatmentDetail.treatment_type, TreatmentDetail.type;" AS '### MESSAGE ###'
UNION ALL
SELECT 'TODO 2: Then remove old field renamed to [type (to remove)] running follwing queries (already included into custom_post263.2.sql).' AS '### MESSAGE ###'
UNION ALL
SELECT "DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');" AS '### MESSAGE ###'
UNION ALL
SELECT "DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));" AS '### MESSAGE ###'
UNION ALL
SELECT "DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');" AS '### MESSAGE ###'
UNION ALL
SELECT "ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;" AS '### MESSAGE ###'
UNION ALL
SELECT "ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;" AS '### MESSAGE ###';

-- Add radio precision

ALTER TABLE procure_txd_followup_worksheet_treatments ADD COLUMN radiotherpay_precision varchar(50) default null;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs ADD COLUMN radiotherpay_precision varchar(50) default null;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_radiotherpay_precision', "StructurePermissibleValuesCustom::getCustomDropdown(\'Radiotherapy Precisions\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Radiotherapy Precisions', 'clinical - treatment', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Precisions');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('brachy','Brachy','Curiethérapie',  '1', @control_id, NOW(), NOW(), 1, 1),
('curative','Curative','Curatif',  '1', @control_id, NOW(), NOW(), 1, 1),
('palliative','Palliative','Palliatif',  '1', @control_id, NOW(), NOW(), 1, 1),
('adjuvant','Adjuvant','Adjuvant',  '1', @control_id, NOW(), NOW(), 1, 1),
('salvage','Salvage','De rattrapage',  '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'radiotherpay_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_radiotherpay_precision') , '0', '', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='radiotherpay_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_radiotherpay_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('no precision has to be associated to the selected treatment type', 'No precision has to be associated to the selected treatment type','Aucun précision ne doit être défini pour le type du traitement sélectionné');

-- Add other cancer treatment 

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`) 
VALUES
(null, 'other tumor treatment', '', 1, 'procure_txd_other_tumor_treatments', 'procure_txd_other_tumor_treatment', 0, NULL, NULL, 'other tumor treatment', 0, NULL);
INSERT INTO i18n (id,en,fr) VALUES ('other tumor treatment', 'Other Tumor Treatment', 'Traitement d''autres tumeurs');
CREATE TABLE IF NOT EXISTS `procure_txd_other_tumor_treatments` (
  `treatment_master_id` int(11) NOT NULL,
  `treatment_type` varchar(50) DEFAULT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `procure_txd_other_tumor_treatments_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `treatment_type` varchar(50) DEFAULT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;
ALTER TABLE `procure_txd_other_tumor_treatments`
  ADD CONSTRAINT `procure_txd_other_tumor_treatments_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('procure_txd_other_tumor_treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_other_tumor_sites', "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Tumor Sites\')"),
('procure_other_tumor_treatment_types', "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Tumor Treatment Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Other Tumor Sites', 'clinical - treatment', '100'),
('Other Tumor Treatment Types', 'clinical - treatment', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Tumor Treatment Types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('chemotherapy','Chemotherapy','Chimiothérapie',  '1', @control_id, NOW(), NOW(), 1, 1),
('radiotherapy','Radiotherapy','Radiothérapie',  '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Tumor Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('breast - breast', 'Breast - Breast', 'Sein - Sein',  '1', @control_id, NOW(), NOW(), 1, 1),
('central nervous system - brain', 'Central Nervous System - Brain', 'Système Nerveux Central - Cerveau',  '1', @control_id, NOW(), NOW(), 1, 1),
('central nervous system - other central nervous system', 'Central Nervous System - Other', 'Système Nerveux Central - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('central nervous system - spinal cord', 'Central Nervous System - Spinal Cord', 'Système Nerveux Central - Moelle épinière',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - anal', 'Digestive - Anal', 'Appareil digestif - Anal',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - appendix', 'Digestive - Appendix', 'Appareil digestif - Appendice',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - bile ducts', 'Digestive - Bile Ducts', 'Appareil digestif - Voies biliaires',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - colorectal', 'Digestive - Colorectal', 'Appareil digestif - Colorectal',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - esophageal', 'Digestive - Esophageal', 'Appareil digestif - Oesophage',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - gallbladder', 'Digestive - Gallbladder', 'Appareil digestif - Vésicule biliaire',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - liver', 'Digestive - Liver', 'Appareil digestif - Foie',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - other digestive', 'Digestive - Other', 'Appareil digestif - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - pancreas', 'Digestive - Pancreas', 'Appareil digestif - Pancréas',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - small intestine', 'Digestive - Small Intestine', 'Appareil digestif - Intestin grêle',  '1', @control_id, NOW(), NOW(), 1, 1),
('digestive - stomach', 'Digestive - Stomach', 'Appareil digestif - Estomac',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - cervical', 'Female Genital - Cervical', 'Appareil génital féminin - Col de l''utérus',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - endometrium', 'Female Genital - Endometrium', 'Appareil génital féminin - Endomètre',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - fallopian tube', 'Female Genital - Fallopian Tube', 'Appareil génital féminin - Trompes de Fallope',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - gestational trophoblastic neoplasia', 'Female Genital - Gestational Trophoblastic Neoplasia', 'Appareil génital féminin - Néoplasie trophoblastique gestationnelle',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - other female genital', 'Female Genital - Other', 'Appareil génital féminin - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - ovary', 'Female Genital - Ovary', 'Appareil génital féminin - Ovaire',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - peritoneal', 'Female Genital - Peritoneal', 'Appareil génital féminin - Péritoine',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - uterine', 'Female Genital - Uterine', 'Appareil génital féminin - Utérin',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - vagina', 'Female Genital - Vagina', 'Appareil génital féminin - Vagin',  '1', @control_id, NOW(), NOW(), 1, 1),
('female genital - vulva', 'Female Genital - Vulva', 'Appareil génital féminin - Vulve',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - hodgkin''s disease', 'Haematological - Hodgkin''s Disease', 'Hématologie - Maladie de Hodgkin',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - leukemia', 'Haematological - Leukemia', 'Hématologie - Leucémie',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - lymphoma', 'Haematological - Lymphoma', 'Hématologie - Lymphome',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - non-hodgkin''s lymphomas', 'Haematological - Non-Hodgkin''s Lymphomas', 'Hématologie - Lymphome Non-hodgkinien',  '1', @control_id, NOW(), NOW(), 1, 1),
('haematological - other haematological', 'Haematological - Other', 'Hématologie - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - larynx', 'Head & Neck - Larynx', 'Tête & Cou - Larynx',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - lip and oral cavity', 'Head & Neck - Lip and Oral Cavity', 'Tête & Cou - Lèvres et la cavité buccale',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - nasal cavity and sinuses', 'Head & Neck - Nasal Cavity and Sinuses', 'Tête & Cou - Cavité nasale et sinus',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - other head & neck', 'Head & Neck - Other', 'Tête & Cou - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - pharynx', 'Head & Neck - Pharynx', 'Tête & Cou - Pharynx',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - salivary glands', 'Head & Neck - Salivary Glands', 'Tête & Cou - Glandes salivaires',  '1', @control_id, NOW(), NOW(), 1, 1),
('head & neck - thyroid', 'Head & Neck - Thyroid', 'Tête & Cou - Thyroïde',  '1', @control_id, NOW(), NOW(), 1, 1),
('male genital - other male genital', 'Male Genital - Other', 'Appareil génital masculin - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('male genital - penis', 'Male Genital - Penis', 'Appareil génital masculin - Pénis',  '1', @control_id, NOW(), NOW(), 1, 1),
('male genital - testis', 'Male Genital - Testis', 'Appareil génital masculin - Testicule',  '1', @control_id, NOW(), NOW(), 1, 1),
('musculoskeletal sites - bone', 'Musculoskeletal Sites - Bone', 'Sites musculo-squelettiques - Os',  '1', @control_id, NOW(), NOW(), 1, 1),
('musculoskeletal sites - other bone', 'Musculoskeletal Sites - Other Bone', 'Sites musculo-squelettiques - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('musculoskeletal sites - soft tissue sarcoma', 'Musculoskeletal Sites - Soft Tissue Sarcoma', 'Sites musculo-squelettiques - Sarcome des tissus mous',  '1', @control_id, NOW(), NOW(), 1, 1),
('ophthalmic - eye', 'Ophthalmic - Eye', 'Ophtalmique - Yeux',  '1', @control_id, NOW(), NOW(), 1, 1),
('ophthalmic - other eye', 'Ophthalmic - Other', 'Ophtalmique - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('other - gross metastatic disease', 'Other - Gross Metastatic Disease', '',  '1', @control_id, NOW(), NOW(), 1, 1),
('other - primary unknown', 'Other - Primary Unknown', 'Autre - Primaire inconnu',  '1', @control_id, NOW(), NOW(), 1, 1),
('skin - melanoma', 'Skin - Melanoma', 'Peau - Melanome',  '1', @control_id, NOW(), NOW(), 1, 1),
('skin - non melanomas', 'Skin - Non Melanomas', 'Peau - Autre que Melanome',  '1', @control_id, NOW(), NOW(), 1, 1),
('skin - other skin', 'Skin - Other', 'Peau - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('thoracic - lung', 'Thoracic - Lung', 'Thoracique - Poumon',  '1', @control_id, NOW(), NOW(), 1, 1),
('thoracic - mesothelioma', 'Thoracic - Mesothelioma', 'Thoracique - Mésothéliome',  '1', @control_id, NOW(), NOW(), 1, 1),
('thoracic - other thoracic', 'Thoracic - Other', 'Thoracique - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - bladder', 'Urinary Tract - Bladder', 'Voies urinaires - Vessie',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - kidney', 'Urinary Tract - Kidney', 'Voies urinaires - Rein',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - other urinary tract', 'Urinary Tract - Other', 'Voies urinaires - Autre',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - renal pelvis and ureter', 'Urinary Tract - Renal Pelvis and Ureter', 'Voies urinaires - Bassinet et uretère',  '1', @control_id, NOW(), NOW(), 1, 1),
('urinary tract - urethra', 'Urinary Tract - Urethra', 'Voies urinaires - Urètre',  '1', @control_id, NOW(), NOW(), 1, 1);		
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_other_tumor_treatments', 'treatment_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_treatment_types') , '0', '', '', '', 'treatment type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_other_tumor_treatments', 'tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_other_tumor_treatments' AND `field`='treatment_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_treatment_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment type' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_other_tumor_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_other_tumor_treatments' AND `field`='tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='procure_txd_other_tumor_treatments' AND `field`='treatment_type'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `tablename`='procure_txd_other_tumor_treatments' AND `field`='tumor_site'), 'notEmpty');

-- Change recurrence site to check boxes

ALTER TABLE procure_ed_clinical_followup_worksheets
  ADD COLUMN clinical_recurrence_site_bones tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_liver tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_lungs tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_others tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_clinical_followup_worksheets_revs
  ADD COLUMN clinical_recurrence_site_bones tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_liver tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_lungs tinyint(1) DEFAULT '0',
  ADD COLUMN clinical_recurrence_site_others tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_bones', 'checkbox',  NULL , '0', '', '', '', 'bone metastasis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_liver', 'checkbox',  NULL , '0', '', '', '', 'liver metastasis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_lungs', 'checkbox',  NULL , '0', '', '', '', 'lung metastasis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site_others', 'checkbox',  NULL , '0', '', '', '', 'other metastasis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_bones' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bone metastasis' AND `language_tag`=''), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_liver' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver metastasis' AND `language_tag`=''), '1', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_lungs' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lung metastasis' AND `language_tag`=''), '1', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site_others' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other metastasis' AND `language_tag`=''), '1', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_bones = '1' WHERE clinical_recurrence_site = 'bones';
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_liver = '1' WHERE clinical_recurrence_site = 'liver';
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_lungs = '1' WHERE clinical_recurrence_site = 'lungs';
UPDATE procure_ed_clinical_followup_worksheets SET clinical_recurrence_site_others = '1' WHERE clinical_recurrence_site = 'others';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_bones = '1' WHERE clinical_recurrence_site = 'bones';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_liver = '1' WHERE clinical_recurrence_site = 'liver';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_lungs = '1' WHERE clinical_recurrence_site = 'lungs';
UPDATE procure_ed_clinical_followup_worksheets_revs SET clinical_recurrence_site_others = '1' WHERE clinical_recurrence_site = 'others';
ALTER TABLE procure_ed_clinical_followup_worksheets DROP COLUMN clinical_recurrence_site;
ALTER TABLE procure_ed_clinical_followup_worksheets_revs DROP COLUMN clinical_recurrence_site;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `language_label`='site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `language_label`='site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `language_label`='site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup clinical recurrence sites');
SELECT value AS 'procure followup clinical recurrence sites unmigrated: to clean up' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value not IN ('liver', 'lungs', 'bones', 'others');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'procure followup clinical recurrence sites';
INSERT INTO i18n (id,en,fr) 
VALUES
('liver metastasis', 'Liver Metastasis', 'Métastase au Foie'),
('lung metastasis', 'Lung Metastasis', 'Métastase aux poumons'),
('bone metastasis', 'Bone Metastasis', 'Métastase aux os'),
('other metastasis', 'Others Metastasis', 'Autres métastases');

-- Change follow-up report

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_01_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_02_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_03_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_04_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_05_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_06_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_07_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_08_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_09_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_10_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_11_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_12_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_13_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_14_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_15_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_16_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_17_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_18_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', ''),
('Datamart', '0', '', 'procure_19_first_collection_date', 'date',  NULL , '0', '', '', '', 'date', '');	
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_01_first_collection_date'), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_02_first_collection_date'), '0', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_03_first_collection_date'), '0', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_04_first_collection_date'), '0', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_05_first_collection_date'), '0', '51', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_06_first_collection_date'), '0', '61', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_07_first_collection_date'), '0', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_08_first_collection_date'), '0', '81', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_09_first_collection_date'), '0', '91', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_10_first_collection_date'), '0', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_11_first_collection_date'), '0', '111', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_12_first_collection_date'), '0', '121', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_13_first_collection_date'), '0', '131', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_14_first_collection_date'), '0', '141', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_15_first_collection_date'), '0', '151', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_16_first_collection_date'), '0', '161', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_17_first_collection_date'), '0', '171', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_18_first_collection_date'), '0', '181', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='procure_19_first_collection_date'), '0', '191', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET language_label = 'first collection date' WHERE field like 'procure_%_first_collection_date';
INSERT INTO i18n (id,en,fr) VALUES ('first collection date', '1st Col. Date', '1ere date de col.');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_followup_worksheets_nbr', 'input',  NULL , '0', 'size=3', '', '', 'follow-up worksheets number', ''), 
('Datamart', '0', '', 'procure_number_of_visit_with_collection', 'input',  NULL , '0', 'size=3', '', '', 'number of visit with collection', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_followup_worksheets_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='follow-up worksheets number' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_number_of_visit_with_collection' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='number of visit with collection' AND `language_tag`=''), '0', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_label`='follow-up worksheet' WHERE model='0' AND tablename='' AND field='procure_followup_worksheets_nbr' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='collection' WHERE model='0' AND tablename='' AND field='procure_number_of_visit_with_collection' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='number of visits with' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_followup_worksheets_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('follow-up worksheet', 'Follow-up Worksheet', 'Fiche de suivi'),
('number of visits with', 'Nbr. of Visits With', 'Nbr. de visites avec');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_prostatectomy_date', 'date',  NULL , '0', '', '', '', 'prostatectomy', ''), 
('Datamart', '0', '', 'procure_last_collection_date', 'date',  NULL , '0', '', '', '', 'last collection date', ''), 
('Datamart', '0', '', 'procure_time_from_last_collection_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time from last collection (months)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_prostatectomy_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prostatectomy' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_last_collection_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last collection date' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_time_from_last_collection_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='time from last collection (months)' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_label`='date' WHERE model='0' AND tablename='' AND field='procure_last_collection_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='last collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_last_collection_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('last collection','Last Collection','Dernière collection'),('time from last collection (months)','Time past (months)','Temps écoulé (mois)');

-- version

UPDATE versions SET branch_build_number = '5981' WHERE version_number = '2.6.3';
