INSERT INTO `datamart_reports` ( `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) VALUES
('participant identifiers with collection dates', 'list all identifiers of selected participants with their collection dates', 'report_participant_identifiers_collection_criteria', 'report_participant_identifiers_collection_result', 'index', 'participantIdentifiersWithCollectionDateSummary', 1, 4, 0);


INSERT INTO structures(`alias`) VALUES ('report_participant_identifiers_collection_result');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'collection_datetime', 'datetime',  NULL , '1', '', '', '', 'inv_collection_datetime_defintion', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '0', '1', '', '0', '1', 'name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=30' AND `default`='' AND `language_help`='help_last_name' AND `language_label`='' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='BR_Nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='#BR' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='PR_Nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='#PR' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='hospital_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='hospital number' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inv_collection_datetime_defintion' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='Collection Date', `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');


INSERT INTO structures(`alias`) VALUES ('report_participant_identifiers_collection_criteria');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_criteria'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', 'clin_demographics', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=20,class=range file', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_collection_criteria'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '0', '2', '', '0', '1', 'Collection Date', '0', '', '1', 'inv_collection_datetime_defintion', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');



INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('participant identifiers with collection dates', '', 'Participant Identifiers with Collection Dates', 'Identifiants de participants avec les dates de collections');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('list all identifiers of selected participants with their collection dates', '', 'List all identifiers of selected participants with their collection dates', 'Liste tous les identifiants de participants sélectionnés avec leurs dates de collections');



INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('activate', '', 'Activate', 'Activer');


INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('deactivate', '', 'Deactivate', 'Désactiver');



INSERT INTO `datamart_structure_functions` ( `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
( 4, 'participant identifiers with collection dates report', CONCAT('/Datamart/Reports/manageReport/', COALESCE((
    (SELECT id FROM datamart_reports WHERE `name`='participant identifiers with collection dates' AND `function`= "participantIdentifiersWithCollectionDateSummary")
), '')), 1, '');






