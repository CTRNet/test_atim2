-- ------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.1
--
-- For more information:
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -----------------------------------------------------------------------------------------------------------------------------------
--

-- -------------------------------------------------------------------------------------
-- Searching the RAMQ errors
-- -------------------------------------------------------------------------------------

INSERT INTO datamart_reports(
	`name`, 
	`description`, 
	`form_alias_for_search`, 
	`form_alias_for_results`, 
	`form_type_for_results`, 
	`function`, 
	`flag_active`, 
	`associated_datamart_structure_id`, 
	`limit_access_from_datamart_structrue_function`
	)
VALUES
	('Report the RAMQ problems',
	'Make a report by checking RAMQ',
	'qc_nd_ramq_search',
	'qc_nd_ramq_reports',
	'index',
	'participantIdentifiersRamqError',
	'1',
	(SELECT id FROM datamart_structures WHERE model = 'Participant'),
	0);


INSERT INTO structures(`alias`) VALUES ('qc_nd_ramq_search');

INSERT INTO structure_formats
	(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_search'), 
	(SELECT id FROM structure_fields WHERE `model`='Group' AND `tablename`='groups' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), 
	'1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ramq_reports');

INSERT INTO structure_fields
	(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
	('Datamart', '0', 'Paricipants', 'qc_nd_notes', 'input',  NULL , '0', 'size=30', '', '', 'notes', ''), 
	('Datamart', '0', '', 'qc_nd_ramq_generated', 'input',  NULL , '1', 'size=30', '', '', 'RAMQ generated', ''),
	('Datamart', '0', '', 'qc_nd_ramq', 'input',  NULL , '1', 'size=30', '', '', 'RAMQ', '');

INSERT INTO structure_formats
	(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '1', '1', '', '0', '1', 'first name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex')  AND `flag_confidential`='0'), '1', '7', '', '0', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '1', '3', '', '0', '1', 'last name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='help_date of birth' AND `language_label`='date of birth' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='Paricipants' AND `field`='qc_nd_notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_nd_ramq_generated' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ generated' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_nd_ramq' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	('Approximate date of birth', 'Approximate date of birth', 'Date de naissance approximative'),
	('RAMQ', 'RAMQ', 'RAMQ'),
	('RAMQ generated', 'Generated RAMQ', 'RAMQ générée'),
	('Problem in ramq', 'Problem in ramq', 'problème de ramq'),
	('Unknown date of birth', 'Unknown date of birth', 'Date de naissance inconnue'),
	('Undefined Sex', 'Undefined Sex', 'Sex non défini'),
	('Firstname missing', 'Firstname missing', 'Prénom manquant'),
	('Lastname missing', 'Lastname missing', 'Nom de famille manquant'),
	('Report the RAMQ problems', 'Report the RAMQ problems', 'Signalez les problèmes de la RAMQ'),
	('Make a report by checking RAMQ', 'Make a report by checking RAMQ', 'Faire un rapport en vérifiant la RAMQ');











