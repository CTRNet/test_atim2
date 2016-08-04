UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6466' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_next_followup_report_criteria'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '1', 'prostate bank no lab', '0', '', '0', '', '0', '', '1', 'size=20,class=range file', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE versions SET site_branch_build_number = '6514' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;
