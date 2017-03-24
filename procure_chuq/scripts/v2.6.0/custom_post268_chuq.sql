
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- End of script custom_post267.sql
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
-- 
-- ----------------------------------------------------------------------------------------------------------------------------------------






























UPDATE versions SET site_branch_build_number = '????' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;
