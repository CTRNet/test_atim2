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

UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='questionnaire' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='participant' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='urine' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='blood' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='annual_followup' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='contact_if_info_req' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='contact_if_discovery' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='study_other_diseases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='contact_if_disco_other_diseases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='other_contacts_if_die' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_reports SET form_alias_for_results='qc_nd_procure_consent_stats_report', form_type_for_results='index' WHERE name='PROCURE - consent report';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'period', 'input',  NULL , '0', '', '', '', 'period', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES
((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE model='0' AND field='period'), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_fields SET language_label 	= 'aliquot barcode' WHERE model = 'AliquotMaster' AND field = 'barcode';

UPDATE misc_identifier_controls SET flag_confidential = '0' WHERE misc_identifier_name NOT IN ('saint-luc id nbr', 'notre-dame id nbr', 'hotel-dieu id nbr', 'ramq nbr');

INSERT INTO i18n (id, en, fr) VALUES ('labo identifiers','''No Labo''','''No Labo''');

UPDATE structure_fields SET flag_confidential = '1' WHERE model = 'Participant' AND field IN ('first_name', 'last_name', 'date_of_birth', 'sardo_medical_record_number');

SET @domain_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'qc consent version');
DELETE FROM structure_permissible_values_customs WHERE control_id = @domain_id;
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`) VALUES
(@domain_id, '2008-10-02', '2008-10-02', '2008-10-02'),
(@domain_id, '2008-09-24', '2008-09-24', '2008-09-24'),
(@domain_id, '2008-06-26', '2008-06-26', '2008-06-26'),
(@domain_id, '2008-06-23', '2008-06-23', '2008-06-23'),
(@domain_id, '2008-03-23', '2008-03-23', '2008-03-23'),
(@domain_id, '2008-05-04', '2008-05-04', '2008-05-04'),
(@domain_id, '2008-04-05', '2008-04-05', '2008-04-05'),
(@domain_id, '2008-03-26', '2008-03-26', '2008-03-26'),
(@domain_id, '2007-10-25', '2007-10-25', '2007-10-25'),
(@domain_id, '2007-06-05', '2007-06-05', '2007-06-05'),
(@domain_id, '2007-05-23', '2007-05-23', '2007-05-23'),
(@domain_id, '2007-05-15', '2007-05-15', '2007-05-15'),
(@domain_id, '2007-05-05', '2007-05-05', '2007-05-05'),
(@domain_id, '2007-05-04', '2007-05-04', '2007-05-04'),
(@domain_id, '2007-04-04', '2007-04-04', '2007-04-04'),
(@domain_id, '2007-03-12', '2007-03-12', '2007-03-12'),
(@domain_id, '2006-08-05', '2006-08-05', '2006-08-05'),
(@domain_id, '2006-06-09', '2006-06-09', '2006-06-09'),
(@domain_id, '2006-05-26', '2006-05-26', '2006-05-26'),
(@domain_id, '2006-05-08', '2006-05-08', '2006-05-08'),
(@domain_id, '2006-05-07', '2006-05-07', '2006-05-07'),
(@domain_id, '2006-05-06', '2006-05-06', '2006-05-06'),
(@domain_id, '2006-02-26', '2006-02-26', '2006-02-26'),
(@domain_id, '2006-02-09', '2006-02-09', '2006-02-09'),
(@domain_id, '2006-02-01', '2006-02-01', '2006-02-01'),
(@domain_id, '2006-01-10', '2006-01-10', '2006-01-10'),
(@domain_id, '2005-10-27', '2005-10-27', '2005-10-27'),
(@domain_id, '2005-10-25', '2005-10-25', '2005-10-25'),
(@domain_id, '2005-07-27', '2005-07-27', '2005-07-27'),
(@domain_id, '2005-06-26', '2005-06-26', '2005-06-26'),
(@domain_id, '2005-05-26', '2005-05-26', '2005-05-26'),
(@domain_id, '2005-03-26', '2005-03-26', '2005-03-26'),
(@domain_id, '2005-01-26', '2005-01-26', '2005-01-26'),
(@domain_id, '2005-01-05', '2005-01-05', '2005-01-05'),
(@domain_id, '2004-12-14', '2004-12-14', '2004-12-14'),
(@domain_id, '2004-09-14', '2004-09-14', '2004-09-14'),
(@domain_id, '2004-07-15', '2004-07-15', '2004-07-15'),
(@domain_id, '2004-03-01', '2004-03-01', '2004-03-01'),
(@domain_id, '2003-12-03', '2003-12-03', '2003-12-03'),
(@domain_id, '2002-09-13', '2002-09-13', '2002-09-13'),
(@domain_id, '2002-04-08', '2002-04-08', '2002-04-08'),
(@domain_id, '2001-03-30', '2001-03-30', '2001-03-30'),
(@domain_id, '2000-04-20', '2000-04-20', '2000-04-20'),
(@domain_id, '2009-11-04', '2009-11-04', '2009-11-04'),
(@domain_id, '2010-03-04', '2010-03-04', '2010-03-04'),
(@domain_id, '2010-09-01', '2010-09-01', '2010-09-01'),
(@domain_id, '2007-09-01', '2007-09-01', '2007-09-01'),
(@domain_id, '2011-01-19', '2011-01-19', '2011-01-19');

SET @domain_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'qc visit label');
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`) VALUES
(@domain_id, 'V06', 'V06', 'V06');

SET @domain_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen supplier departments');
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`) VALUES
(@domain_id, 'day surgery', 'Day Surgery', 'Chirurgie d''un jour'),
(@domain_id, 'pacu', 'Post-Anesthesia Care Unit', 'Salle de réveil');

SET @domain_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'laboratory staff');
DELETE FROM structure_permissible_values_customs WHERE control_id = @domain_id;
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`) VALUES
(@domain_id, 'aurore pierrard','Aurore Pierrard','Aurore Pierrard'),
(@domain_id, 'chantale auger','Chantale Auger','Chantale Auger'),
(@domain_id, 'christine abaji','Christine Abaji','Christine Abaji'),
(@domain_id, 'emilio, johanne et phil','Émilio, Johanne et Phil','Émilio, Johanne et Phil'),
(@domain_id, 'hafida lounis','Hafida Lounis','Hafida Lounis'),
(@domain_id, 'isabelle letourneau','Isabelle Létourneau','Isabelle Létourneau'),
(@domain_id, 'jason madore','Jason Madore','Jason Madore'),
(@domain_id, 'jennifer kendall dupont','Jennifer Kendall Dupont','Jennifer Kendall Dupont'),
(@domain_id, 'jessica godin ethier','Jessica Godin Ethier','Jessica Godin Ethier'),
(@domain_id, 'josh levin','Josh Levin','Josh Levin'),
(@domain_id, 'julie desgagnes','Julie Desgagnés','Julie Desgagnés'),
(@domain_id, 'karine normandin','Karine Normandin','Karine Normandin'),
(@domain_id, 'kevin gu','Kevin Gu','Kevin Gu'),
(@domain_id, 'labo externe','Labo externe','Labo externe'),
(@domain_id, 'liliane meunier','Liliane Meunier','Liliane Meunier'),
(@domain_id, 'lise portelance','Lise Portelance','Lise Portelance'),
(@domain_id, 'louise champoux','Louise Champoux','Louise Champoux'),
(@domain_id, 'magdalena zietarska','Magdalena Zietarska','Magdalena Zietarska'),
(@domain_id, 'manon de ladurantaye','Manon de Ladurantaye','Manon de Ladurantaye'),
(@domain_id, 'marie-andree forget','Marie-Andrée Forget','Marie-Andrée Forget'),
(@domain_id, 'marie-josee milot','Marie-Josée Milot','Marie-Josée Milot'),
(@domain_id, 'marie-line puiffe','Marie-Line Puiffe','Marie-Line Puiffe'),
(@domain_id, 'marise roy','Marise Roy','Marise Roy'),
(@domain_id, 'matthew starek','Matthew Starek','Matthew Starek'),
(@domain_id, 'mona alam','Mona Alam','Mona Alam'),
(@domain_id, 'nathalie delvoye','Nathalie Delvoye','Nathalie Delvoye'),
(@domain_id, 'pathologie','Pathologie','Pathologie'),
(@domain_id, 'patrick kibangou bondza','Patrick Kibangou Bondza','Patrick Kibangou Bondza'),
(@domain_id, 'stephanie lepage','Stéphanie Lepage','Stéphanie Lepage'),
(@domain_id, 'urszula krzemien','Urszula Krzemien','Urszula Krzemien'),
(@domain_id, 'valerie forest','Valérie Forest','Valérie Forest'),
(@domain_id, 'veronique barres','Véronique Barr&eagrave;s','Véronique Barr&eagrave;s'),
(@domain_id, 'veronique ouellet','Véronique Ouellet','Véronique Ouellet'),
(@domain_id, 'yuan chang','Yuan Chang','Yuan Chang'),
(@domain_id, 'autre','Autre','Autre'),
(@domain_id, 'inconnue','Inconnue','Inconnue'),
(@domain_id, 'guillaume cardin','Guillaume Cardin','Guillaume Cardin'),
(@domain_id, 'teodora yaneva','Teodora Yaneva','Teodora Yaneva'),
(@domain_id, 'katia caceres','Katia Caceres','Katia Caceres'),
(@domain_id, 'carl-frederic duchatellier','Carl-Frédéric Duchatellier','Carl-Frédéric Duchatellier'),
(@domain_id, 'michael quinn','Michael Quinn','Michael Quinn'),
(@domain_id, 'louis cyr','Louis Cyr','Louis Cyr'),
(@domain_id, 'rayane el masri','Rayane El Masri','Rayane El Masri');

UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '50' WHERE name = 'laboratory staff';
UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '30' WHERE name = 'laboratory sites';
UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '30' WHERE name = 'specimen collection sites';
UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '40' WHERE name = 'specimen supplier departments';
UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '20' WHERE name = 'quality control tools';
UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '20' WHERE name = 'qc consent version';
UPDATE `structure_permissible_values_custom_controls` SET values_max_length = '20' WHERE name = 'qc visit label';

UPDATE event_controls SET detail_tablename = 'qc_nd_ed_all_procure_lifestyles', form_alias = 'qc_nd_ed_all_procure_lifestyle' 
WHERE event_type = 'procure';

ALTER TABLE participant_messages
	MODIFY `due_date` datetime DEFAULT NULL AFTER  `description`;
ALTER TABLE participant_messages_revs
	MODIFY `due_date` datetime DEFAULT NULL AFTER  `description`;
	
UPDATE structure_formats
SET `flag_add` = '0',
`flag_add_readonly` = '0', 
`flag_edit` = '0', 
`flag_edit_readonly` = '0', 
`flag_search` = '0', 
`flag_search_readonly` = '0', 
`flag_addgrid` = '0', 
`flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', 
`flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', 
`flag_batchedit_readonly` = '0', 
`flag_index` = '0', 
`flag_detail` = '0', 
`flag_summary` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE plugin = 'Inventorymanagement' AND field LIKE '%lab_book%');	
	
UPDATE menus SET flag_active = '0' WHERE use_link like '/labbook/%';

UPDATE structure_formats SET `flag_detail`='0',`flag_edit`='0',`flag_edit_readonly`='0'  WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='sample_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type'));
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='sample_code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='acquisition_label' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='identifier_value' AND type='input' AND structure_value_domain  IS NULL );

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES
((SELECT id FROM structures WHERE alias='in_stock_detail'), 
(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND field='aliquot_label'), 
'1', '1', '', '0', '', '0', '', '0', '', '0', '', '1', 'size=50', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_fields SET language_label = 'cell passage number' WHERE language_label like 'cell passage number ';

UPDATE sample_masters SET is_problematic = '1' WHERE is_problematic = 'yes';
UPDATE sample_masters SET is_problematic = '0' WHERE is_problematic != '1';

UPDATE sd_spe_bloods SET blood_type = 'heparin' WHERE blood_type = 'heparine';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'display_name_from_datamasrtstructure', 'open', '', 'Datamart.DatamartStructure::getDisplayNameFromId');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Datamart', 'BrowsingResult', '', 'browsing_structures_id', 'search start from', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='display_name_from_datamasrtstructure') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_browsing_indexes'), (SELECT id FROM structure_fields WHERE `model`='BrowsingResult' AND `tablename`='' AND `field`='browsing_structures_id' AND `language_label`='search start from' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='display_name_from_datamasrtstructure')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='datamart_browsing_indexes') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='BrowsingIndex' AND tablename='datamart_browsing_indexes' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );





