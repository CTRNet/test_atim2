-- custom for 2.1.1

REPLACE INTO i18n (id, en, fr) VALUES
("core_installname", "ICM", "ICM"),
("core_appname", "ATiM - Advanced Tissue Management", "ATiM - Application de gestion avancée des tissus");

INSERT INTO datamart_reports(name, description, form_alias_for_search, form_alias_for_results, form_type_for_results, function, flag_active, created, created_by, modified, modified_by) VALUES
('PROCURE - consent report', "PROCURE consent's statistics", 'report_date_range_definition', "???", 'detail', 'procureConsentStat', 1, NOW(), 1, NOW(), 1); 

INSERT INTO structures(`alias`) VALUES ('qc_nd_part_id_summary');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'identifiers', 'textarea',  NULL , '0', '', '', '', 'labo identifiers', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_part_id_summary'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='identifiers' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='labo identifiers' AND `language_tag`=''), '10', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

