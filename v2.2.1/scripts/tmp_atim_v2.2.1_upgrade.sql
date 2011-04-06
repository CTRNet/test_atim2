-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.1 alpha', NOW(), '> 2838');

ALTER TABLE users 
 DROP COLUMN last_visit;
 
UPDATE structure_formats SET `language_heading`='diagnosis' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('add participant','Add Participant','Créer participant');

REPLACE INTO i18n (id, en, fr) VALUES
("help_flag_active", 
 "Determines whether the account can be used to log into ATiM or not. Locked means that the account cannot be used.",
 "Détermine si le compte peut être utiliser pour se connecter à ATiM ou non. Bloqué signifie que le compte ne peut pas être utilisé.");

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

