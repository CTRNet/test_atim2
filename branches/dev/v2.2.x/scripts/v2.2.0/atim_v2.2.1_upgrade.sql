-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.1', NOW(), '2921');

ALTER TABLE users 
 DROP COLUMN last_visit;
 
UPDATE structure_formats SET `language_heading`='diagnosis' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM i18n WHERE id="if you browse further ahead, all matches of the current set will be used";
UPDATE i18n SET en = 'Cell Lysate' WHERE id = 'cell lysate';

REPLACE INTO i18n (id, en, fr) VALUES
("help_flag_active", 
 "Determines whether the account can be used to log into ATiM or not. Locked means that the account cannot be used.",
 "Détermine si le compte peut être utiliser pour se connecter à ATiM ou non. Bloqué signifie que le compte ne peut pas être utilisé."),
('aliquots spent times summary', 'Aliquot Spent Times Summary', 'Résumé des temps écoulés liés aux aliquots'),
('generate aliquots spent times summary','Generate Aliquot Spent Times Summary','Générer le résumé des temps écoulés liés aux aliquots'),
('calculation of different aliquots spent times',
'Summary gathering aliquot spent times like ''Collection to Storage Spent Time'', ''Creation to Storage Spent Time'', etc.',
'Résumé contenant des temps écoulés tel que ''Le temps entre la collection et l''entreposage'', etc.'),
('add participant','Add Participant','Créer participant'),
("batch init - number of submitted records too big", "The number of records submitted are too big to me managed in batch!",
"Le nombre de données soumises pour être traitées en lot est trop important!"),
("for any action you take (%s, %s, csv, etc.), all matches of the current set will be used",
 "For any action you take (%s, %s, CSV, etc.), all matches of the current set will be used",
 "Peu importe l'action que vous sélectionnez (%s, %s, CSV, etc.), tous les résultats de l'ensemble présent seront utilisés");


DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='preferences') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='User' AND `tablename`='users' AND `field`='flag_active' AND `language_label`='account status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='user_active') AND `language_help`='help_flag_active' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structures(`alias`) VALUES ('preferences_lock');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='preferences_lock'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='flag_active' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='user_active')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_flag_active' AND `language_label`='account status' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

DELETE FROM structure_formats 
WHERE structure_id = (SELECT id FROM structures WHERE alias='datamart_browsing_indexes')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='BrowsingResult' AND `tablename`='' AND `field`='browsing_structures_id' AND `language_label`='search start from');
DELETE FROM structure_fields WHERE  `model`='BrowsingResult' AND `tablename`='' AND `field`='browsing_structures_id' AND `language_label`='search start from';
DELETE FROM structure_value_domains WHERE  `domain_name`='display_name_from_datamasrtstructure';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'display_name_from_datamasrtstructure', 'open', '', 'Datamart.DatamartStructure::getDisplayNameFromId');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Datamart', 'BrowsingResult', '', 'browsing_structures_id', 'search start from', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='display_name_from_datamasrtstructure') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES
((SELECT id FROM structures WHERE alias='datamart_browsing_indexes'), (SELECT id FROM structure_fields WHERE `model`='BrowsingResult' AND `tablename`='' AND `field`='browsing_structures_id' AND `language_label`='search start from' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='display_name_from_datamasrtstructure') AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='datamart_browsing_indexes') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='BrowsingIndex' AND tablename='datamart_browsing_indexes' AND field='notes' AND type='textarea' AND structure_value_domain IS NULL );

SET @existing_field_id = (SELECT id FROM structure_fields WHERE field = 'creat_to_stor_spent_time_msg' AND model = 'generated');
SET @added_field_id_2 = (SELECT id FROM structure_fields WHERE field = 'coll_to_stor_spent_time_msg' AND model = 'generated');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT `structure_id`, @added_field_id_2, `display_column`, (`display_order` -1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`
FROM structure_formats WHERE structure_field_id = @existing_field_id);

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`) VALUES
(null, 'aliquots spent times summary', 'calculation of different aliquots spent times', 'report_aliquot_spent_times_defintion', 'aliquot_spent_times_report', 'index', 'aliquotSpentTimesCalulations');

INSERT INTO structures(`alias`) VALUES ('report_aliquot_spent_times_defintion');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_aliquot_spent_times_defintion'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND setting LIKE 'size=%' AND `structure_value_domain`  IS NULL  ), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('aliquot_spent_times_report');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND setting LIKE 'size=%' AND `structure_value_domain`  IS NULL  ), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', 
'0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), 
(SELECT id FROM structure_fields WHERE `model`='Generated' AND field = 'coll_to_stor_spent_time_msg'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', 
'0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), 
(SELECT id FROM structure_fields WHERE `model`='Generated' AND field = 'rec_to_stor_spent_time_msg'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', 
'0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), 
(SELECT id FROM structure_fields WHERE `model`='Generated' AND field = 'creat_to_stor_spent_time_msg'), 
'0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', 
'0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`)VALUES 
(NULL , (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 'generate aliquots spent times summary', CONCAT('datamart/reports/manageReport/',(SELECT id FROM datamart_reports WHERE name = 'aliquots spent times summary')), '1');

INSERT INTO `datamart_batch_processes` (`id`, `name`, `plugin`, `model`, `url`, `flag_active`) VALUES
(null, 'generate aliquots spent times summary', 'Inventorymanagement', 'AliquotMaster', CONCAT('datamart/reports/manageReport/',(SELECT id FROM datamart_reports WHERE name = 'spent times summary applied to aliquots')), 1),
(null, 'generate aliquots spent times summary', 'Inventorymanagement', 'ViewAliquot', CONCAT('datamart/reports/manageReport/',(SELECT id FROM datamart_reports WHERE name = 'spent times summary applied to aliquots')), 1);

UPDATE structure_fields SET `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='models'), type='select' WHERE `model`='Adhoc' AND `tablename`='datamart_adhoc' AND `field`='model' AND `type`='input' AND `structure_value_domain` IS NULL;

UPDATE structure_formats SET flag_addgrid_readonly=flag_addgrid, flag_editgrid_readonly=flag_editgrid
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='CopyCtrl');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `language_label`='aliquot type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `language_help`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_spent_times_report'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`=''), '0', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_spent_times_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='aliquot_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('spent_time_display_mode', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("mn", "minutes"),
('full', 'full');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="spent_time_display_mode"),  
(SELECT id FROM structure_permissible_values WHERE value="mn" AND language_alias="minutes"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="spent_time_display_mode"),  
(SELECT id FROM structure_permissible_values WHERE value="complete" AND language_alias="complete"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Datamart', '0', '', 'report_spent_time_display_mode', 'display option', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='spent_time_display_mode') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_aliquot_spent_times_defintion'), 
(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='report_spent_time_display_mode' AND `language_label`='display option' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='spent_time_display_mode')  AND `language_help`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

REPLACE INTO i18n (id, en, fr) VALUES
('display option','Display Option','Option d''affichage');



