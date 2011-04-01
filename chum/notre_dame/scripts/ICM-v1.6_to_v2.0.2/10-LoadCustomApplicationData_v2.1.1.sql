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
(@domain_id, 'veronique barres','Véronique Barr&egrave;s','Véronique Barr&egrave;s'),
(@domain_id, 'veronique ouellet','Véronique Ouellet','Véronique Ouellet'),
(@domain_id, 'yuan chang','Yuan Chang','Yuan Chang'),
(@domain_id, 'autre','Autre','Autre'),
(@domain_id, 'alexis poisson','Alexis Poisson','Alexis Poisson'),
(@domain_id, 'hubert fleury','Hubert Fleury','Hubert Fleury'),
(@domain_id, 'inconnue','Inconnue','Inconnue'),
(@domain_id, 'cecile lepage','Cecile Lepage','Cecile Lepage'),
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

UPDATE realiquotings SET realiquoted_by = 'jennifer kendall dupont' WHERE realiquoted_by LIKE 'jennifer kendall%';

UPDATE aliquot_internal_uses SET used_by = 'marie-line puiffe' WHERE use_details LIKE '% by Marie-Line%';
UPDATE aliquot_internal_uses SET used_by = 'lise portelance' WHERE use_details LIKE '% by Lise%';
UPDATE aliquot_internal_uses SET used_by = 'stephanie lepage' WHERE use_details LIKE '% by Stéphanie%';
UPDATE aliquot_internal_uses SET used_by = 'manon de ladurantaye' WHERE use_details LIKE '% by Manon%';
UPDATE aliquot_internal_uses SET used_by = 'marise roy' WHERE use_details LIKE '% by Marise%';
UPDATE aliquot_internal_uses SET used_by = 'matthew starek' WHERE use_details LIKE '% by Matthew%';
UPDATE aliquot_internal_uses SET used_by = 'karine normandin' WHERE use_details LIKE '% by Karine%';
UPDATE aliquot_internal_uses SET used_by = 'jennifer kendall dupont' WHERE use_details LIKE '% by Jennifer%';
UPDATE aliquot_internal_uses SET used_by = 'veronique barres' WHERE use_details LIKE '% by Véronique Barres%';
UPDATE aliquot_internal_uses SET used_by = 'veronique ouellet' WHERE use_details LIKE '% by Véronique Ouellet%';
UPDATE aliquot_internal_uses SET used_by = 'chantale auger' WHERE use_details LIKE '% by Chantale%';
UPDATE aliquot_internal_uses SET used_by = 'jessica godin ethier' WHERE use_details LIKE '% by Jessica%';
UPDATE aliquot_internal_uses SET used_by = 'pathologie' WHERE use_details LIKE '% by Pathologie%';
UPDATE aliquot_internal_uses SET used_by = 'liliane meunier' WHERE use_details LIKE '% by Liliane%';
UPDATE aliquot_internal_uses SET used_by = 'patrick kibangou bondza' WHERE use_details LIKE '% by Patrick%';
UPDATE aliquot_internal_uses SET used_by = 'marie-andree forget' WHERE use_details LIKE '% by Marie-Andrée%';
UPDATE aliquot_internal_uses SET used_by = 'julie desgagnes' WHERE use_details LIKE '% by Julie Desgagnés%';
UPDATE aliquot_internal_uses SET used_by = 'autre' WHERE use_details LIKE '% by Autre%';
UPDATE aliquot_internal_uses SET used_by = 'inconnue' WHERE use_details LIKE '% by Inconnue%';

UPDATE aliquot_internal_uses SET used_by = 'aurore pierrard' WHERE use_details LIKE '% by Aurore%';
UPDATE aliquot_internal_uses SET used_by = 'yuan chang' WHERE use_details LIKE '% by Yuan%';
UPDATE aliquot_internal_uses SET used_by = 'magdalena zietarska' WHERE use_details LIKE '% by Magdalena%';

UPDATE aliquot_internal_uses SET used_by = 'jennifer kendall dupont' WHERE use_details LIKE '%Jennifer%';
UPDATE aliquot_internal_uses SET used_by = 'cecile lepage' WHERE use_details LIKE '%par Cecile%';

UPDATE aliquot_internal_uses SET used_by = 'jennifer kendall dupont' WHERE use_details LIKE '%Jenifer%';
UPDATE aliquot_internal_uses SET used_by = 'patrick kibangou bondza' WHERE use_details LIKE '%Patrick%';
UPDATE aliquot_internal_uses SET used_by = 'manon de ladurantaye' WHERE use_details LIKE '%Manon%';
UPDATE aliquot_internal_uses SET used_by = 'liliane meunier' WHERE use_details LIKE '%Liliane%';
UPDATE aliquot_internal_uses SET used_by = 'karine normandin' WHERE use_details LIKE '%Karine%';
UPDATE aliquot_internal_uses SET used_by = 'michael quinn' WHERE use_details LIKE '%Michael Quinn%';
UPDATE aliquot_internal_uses SET used_by = 'rayane el masri' WHERE use_details LIKE '%Rayane%';
UPDATE aliquot_internal_uses SET used_by = 'alexis poisson' WHERE use_details LIKE '%Alexis Poisson%';
UPDATE aliquot_internal_uses SET used_by = 'hubert fleury' WHERE use_details LIKE '%Hubert%';
UPDATE aliquot_internal_uses SET used_by = 'magdalena zietarska' WHERE use_details LIKE '%Magadalena Zietarska%';

SET @domain_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'quality control tools');
DELETE FROM structure_permissible_values_customs WHERE control_id = @domain_id;
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`) VALUES
(@domain_id, 'beckman','Beckman','Beckman'),
(@domain_id, 'bioanalyzer 1','BioAnalyzer 1','BioAnalyzer 1'),
(@domain_id, 'nanodrop','Nanodrop','Nanodrop'),
(@domain_id, 'pharmacia','Pharmacia','Pharmacia');

DROP VIEW IF EXISTS view_aliquot_uses;
CREATE VIEW view_aliquot_uses AS 

SELECT 
CONCAT(source.id, 1) AS id,
aliq.id AS aliquot_master_id,
'sample derivative creation' AS use_definition, 
CONCAT(samp.sample_label, ' [',samp.sample_code, ']') AS use_code,
'' AS use_details,
source.used_volume,
aliq.aliquot_volume_unit,
der.creation_datetime AS use_datetime,
der.creation_by AS used_by,
source.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllSourceAliquots|',samp.collection_id ,'|',samp.id) AS detail_url,
samp2.id AS sample_master_id,
samp2.collection_id AS collection_id
FROM source_aliquots AS source
INNER JOIN sample_masters AS samp ON samp.id = source.sample_master_id  AND samp.deleted != 1
INNER JOIN derivative_details AS der ON samp.id = der.sample_master_id  AND der.deleted != 1
INNER JOIN aliquot_masters AS aliq ON aliq.id = source.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp2 ON samp2.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE source.deleted != 1

UNION ALL

SELECT 
CONCAT(realiq.id, 2) AS id,
aliq.id AS aliquot_master_id,
'realiquoted to' AS use_definition, 
CONCAT(child.aliquot_label, ' [',child.barcode, ']') AS use_code,
'' AS use_details,
realiq.parent_used_volume AS used_volume,
aliq.aliquot_volume_unit,
realiq.realiquoting_datetime AS use_datetime,
realiq.realiquoted_by AS used_by,
realiq.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllRealiquotedParents|',child.collection_id,'|',child.sample_master_id,'|',child.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM realiquotings AS realiq
INNER JOIN aliquot_masters AS aliq ON aliq.id = realiq.parent_aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_masters AS child ON child.id = realiq.child_aliquot_master_id AND child.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE realiq.deleted != 1

UNION ALL

SELECT 
CONCAT(tested.id, 3) AS id,
aliq.id AS aliquot_master_id,
'quality control' AS use_definition, 
qc.qc_code AS use_code,
'' AS use_details,
tested.used_volume,
aliq.aliquot_volume_unit,
qc.date AS use_datetime,
qc.run_by AS used_by,
tested.created,
CONCAT('|inventorymanagement|quality_ctrls|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',qc.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM quality_ctrl_tested_aliquots AS tested
INNER JOIN aliquot_masters AS aliq ON aliq.id = tested.aliquot_master_id AND aliq.deleted != 1
INNER JOIN quality_ctrls AS qc ON qc.id = tested.quality_ctrl_id AND qc.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE tested.deleted != 1

UNION ALL

SELECT 
CONCAT(item.id, 4) AS id,
aliq.id AS aliquot_master_id,
'aliquot shipment' AS use_definition, 
sh.shipment_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
sh.datetime_shipped AS use_datetime,
sh.shipped_by AS used_by,
sh.created,
CONCAT('|order|shipments|detail|',sh.order_id,'|',sh.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM order_items AS item
INNER JOIN aliquot_masters AS aliq ON aliq.id = item.aliquot_master_id AND aliq.deleted != 1
INNER JOIN shipments AS sh ON sh.id = item.shipment_id AND sh.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE item.deleted != 1

UNION ALL

SELECT 
CONCAT(alr.id, 5) AS id,
aliq.id AS aliquot_master_id,
'specimen review' AS use_definition, 
spr.review_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
spr.review_date AS use_datetime,
'' AS used_by,
alr.created,
CONCAT('|inventorymanagement|specimen_reviews|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',spr.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_review_masters AS alr
INNER JOIN aliquot_masters AS aliq ON aliq.id = alr.aliquot_master_id AND aliq.deleted != 1
INNER JOIN specimen_review_masters AS spr ON spr.id = alr.specimen_review_master_id AND spr.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE alr.deleted != 1

UNION ALL

SELECT 
CONCAT(aluse.id, 6) AS id,
aliq.id AS aliquot_master_id,
'internal use' AS use_definition, 
aluse.use_code,
aluse.use_details,
aluse.used_volume,
aliq.aliquot_volume_unit,
aluse.use_datetime,
aluse.used_by,
aluse.created,
CONCAT('|inventorymanagement|aliquot_masters|detailAliquotInternalUse|',aliq.id,'|',aluse.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_internal_uses AS aluse
INNER JOIN aliquot_masters AS aliq ON aliq.id = aluse.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE aluse.deleted != 1;

UPDATE structure_formats SET `display_order`='0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'sd_%') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND field='sample_code');
UPDATE structure_formats SET `display_order`='1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'sd_%') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND field='sample_label');

UPDATE structure_formats SET `display_order`='999'
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'aliquot_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND field='stored_by');
UPDATE structure_formats SET `display_order` = '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'aliquot_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND field='barcode' AND type = 'input');
UPDATE structure_formats SET `display_order` = '2000'
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND field='created');

UPDATE derivative_details SET creation_by = 'marie-line puiffe' WHERE creation_by LIKE '% by Marie-Line%';
UPDATE aliquot_internal_uses SET used_by = 'lise portelance' WHERE use_details LIKE '% by Lise%';
UPDATE aliquot_internal_uses SET used_by = 'stephanie lepage' WHERE use_details LIKE '% by Stéphanie%';
UPDATE aliquot_internal_uses SET used_by = 'manon de ladurantaye' WHERE use_details LIKE '% by Manon%';
UPDATE aliquot_internal_uses SET used_by = 'marise roy' WHERE use_details LIKE '% by Marise%';
UPDATE aliquot_internal_uses SET used_by = 'matthew starek' WHERE use_details LIKE '% by Matthew%';
UPDATE aliquot_internal_uses SET used_by = 'karine normandin' WHERE use_details LIKE '% by Karine%';
UPDATE aliquot_internal_uses SET used_by = 'jennifer kendall dupont' WHERE use_details LIKE '% by Jennifer%';
UPDATE aliquot_internal_uses SET used_by = 'veronique barres' WHERE use_details LIKE '% by Véronique Barres%';
UPDATE aliquot_internal_uses SET used_by = 'veronique ouellet' WHERE use_details LIKE '% by Véronique Ouellet%';
UPDATE aliquot_internal_uses SET used_by = 'chantale auger' WHERE use_details LIKE '% by Chantale%';
UPDATE aliquot_internal_uses SET used_by = 'jessica godin ethier' WHERE use_details LIKE '% by Jessica%';
UPDATE aliquot_internal_uses SET used_by = 'pathologie' WHERE use_details LIKE '% by Pathologie%';
UPDATE aliquot_internal_uses SET used_by = 'liliane meunier' WHERE use_details LIKE '% by Liliane%';
UPDATE aliquot_internal_uses SET used_by = 'patrick kibangou bondza' WHERE use_details LIKE '% by Patrick%';
UPDATE aliquot_internal_uses SET used_by = 'marie-andree forget' WHERE use_details LIKE '% by Marie-Andrée%';
UPDATE aliquot_internal_uses SET used_by = 'julie desgagnes' WHERE use_details LIKE '% by Julie Desgagnés%';
UPDATE aliquot_internal_uses SET used_by = 'autre' WHERE use_details LIKE '% by Autre%';
UPDATE aliquot_internal_uses SET used_by = 'inconnue' WHERE use_details LIKE '% by Inconnue%';

UPDATE aliquot_internal_uses SET used_by = 'aurore pierrard' WHERE use_details LIKE '% by Aurore%';
UPDATE aliquot_internal_uses SET used_by = 'yuan chang' WHERE use_details LIKE '% by Yuan%';
UPDATE aliquot_internal_uses SET used_by = 'magdalena zietarska' WHERE use_details LIKE '% by Magdalena%';

UPDATE aliquot_internal_uses SET used_by = 'jennifer kendall dupont' WHERE use_details LIKE '%Jennifer%';
UPDATE aliquot_internal_uses SET used_by = 'cecile lepage' WHERE use_details LIKE '%par Cecile%';

UPDATE aliquot_internal_uses SET used_by = 'jennifer kendall dupont' WHERE use_details LIKE '%Jenifer%';
UPDATE aliquot_internal_uses SET used_by = 'patrick kibangou bondza' WHERE use_details LIKE '%Patrick%';
UPDATE aliquot_internal_uses SET used_by = 'manon de ladurantaye' WHERE use_details LIKE '%Manon%';
UPDATE aliquot_internal_uses SET used_by = 'liliane meunier' WHERE use_details LIKE '%Liliane%';
UPDATE aliquot_internal_uses SET used_by = 'karine normandin' WHERE use_details LIKE '%Karine%';
UPDATE aliquot_internal_uses SET used_by = 'michael quinn' WHERE use_details LIKE '%Michael Quinn%';
UPDATE aliquot_internal_uses SET used_by = 'rayane el masri' WHERE use_details LIKE '%Rayane%';
UPDATE aliquot_internal_uses SET used_by = 'alexis poisson' WHERE use_details LIKE '%Alexis Poisson%';
UPDATE aliquot_internal_uses SET used_by = 'hubert fleury' WHERE use_details LIKE '%Hubert%';
UPDATE aliquot_internal_uses SET used_by = 'magdalena zietarska' WHERE use_details LIKE '%Magadalena Zietarska%';

UPDATE derivative_details SET creation_by = 'marie-line puiffe' WHERE creation_by LIKE 'Marie-Line';
UPDATE derivative_details SET creation_by = 'inconnue' WHERE creation_by LIKE 'unknown';
UPDATE derivative_details SET creation_by = 'lise portelance' WHERE creation_by LIKE 'Lise';
UPDATE derivative_details SET creation_by = 'marise roy' WHERE creation_by LIKE 'Marise';
UPDATE derivative_details SET creation_by = 'manon de ladurantaye' WHERE creation_by LIKE 'Manon';
UPDATE derivative_details SET creation_by = 'stephanie lepage' WHERE creation_by LIKE 'Stéphanie';
UPDATE derivative_details SET creation_by = 'louise champoux' WHERE creation_by LIKE 'Louise';
UPDATE derivative_details SET creation_by = 'autre' WHERE creation_by LIKE 'other';
UPDATE derivative_details SET creation_by = 'magdalena zietarska' WHERE creation_by LIKE 'Magdalena';
UPDATE derivative_details SET creation_by = 'emilio, johanne et phil' WHERE creation_by LIKE 'emilio, johanne et p%';
UPDATE derivative_details SET creation_by = 'karine normandin' WHERE creation_by LIKE 'Karine';
UPDATE derivative_details SET creation_by = 'patrick kibangou bondza' WHERE creation_by LIKE 'patrick kibangou bon%';

UPDATE shipments SET shipped_by = 'autre' WHERE shipped_by LIKE 'other';

UPDATE aliquot_internal_uses SET used_by = 'cecile lepage' WHERE used_by LIKE '%Cecile%';

UPDATE aliquot_masters SET stored_by = 'autre' WHERE stored_by LIKE 'other';
UPDATE aliquot_masters SET stored_by = 'inconnue' WHERE stored_by LIKE 'unknown';

ALTER TABLE ad_tubes
	ADD COLUMN mycoplasma_free TINYINT(1) DEFAULT 0 AFTER cell_passage_number,
	ADD COLUMN mycoplasma_test VARCHAR(50) NULL DEFAULT NULL AFTER mycoplasma_free;
	
ALTER TABLE ad_tubes_revs
	ADD COLUMN mycoplasma_free TINYINT(1) DEFAULT 0 AFTER cell_passage_number,
	ADD COLUMN mycoplasma_test VARCHAR(50) NULL DEFAULT NULL AFTER mycoplasma_free;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'mycoplasma_free', 'mycoplasma free', '', 'checkbox', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='mycoplasma_free' AND `language_label`='mycoplasma free' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

UPDATE ad_tubes ad, aliquot_masters am, aliquot_controls ac
SET ad.mycoplasma_free = 1
WHERE am.id = ad.aliquot_master_id
AND ac.id = am.aliquot_control_id
AND am.notes LIKE '%test%mycopla%'
AND ac.form_alias LIKE '%ad_cell_culture_tubes%';

INSERT INTO i18n (id, en, fr) VALUES
("mycoplasma free", "Mycoplasma Free", "Mycoplasme Négatif"),
("mycoplasma test", "Mycoplasma Test", "Mycoplasme Teste"),
('histogel use','HistoGel Use','Utilsiation HistoGel'),
('qc culture population','Population','Population');

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`, `values_max_length`) VALUES
(null, 'qc mycoplasma tests', 1, 50);
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_mycoplasma_tests', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''qc mycoplasma tests'')');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'mycoplasma_test', 'mycoplasma test', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_mycoplasma_tests') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='mycoplasma_test' AND `language_label`='mycoplasma test' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_mycoplasma_tests')  AND `language_help`=''), '1', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

ALTER TABLE sd_der_cell_cultures
	ADD COLUMN qc_culture_population INT(5) DEFAULT NULL AFTER tmp_percentage_of_serum;	
ALTER TABLE sd_der_cell_cultures_revs
	ADD COLUMN qc_culture_population INT(5) DEFAULT NULL AFTER tmp_percentage_of_serum;
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'qc_culture_population', 'qc culture population', '', 'integer', 'size=3', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='qc_culture_population' AND `language_label`='qc culture population' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

INSERT INTO `aliquot_controls` (`id`, `aliquot_type`, `aliquot_type_precision`, `form_alias`, `detail_tablename`, `volume_unit`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, 'block', 'ascite cell', 'aliquot_masters,ad_der_ascite_cell_block', 'ad_blocks', NULL, 'Ascite cell block', 0, 'block');
INSERT INTO `sample_to_aliquot_controls` (`id`, `sample_control_id`, `aliquot_control_id`, `flag_active`)
VALUES 
(null, (SELECT id FROM sample_controls WHERE sample_type LIKE 'ascite cell'), 
(SELECT id FROM aliquot_controls WHERE aliquot_type LIKE 'block' AND form_alias LIKE '%ad_der_ascite_cell_block%'), '1');

ALTER TABLE ad_blocks
	ADD COLUMN histogel_use TINYINT(1) DEFAULT 0 AFTER path_report_code;
ALTER TABLE ad_blocks_revs
	ADD COLUMN histogel_use TINYINT(1) DEFAULT 0 AFTER path_report_code;
	
INSERT INTO structures(`alias`) VALUES ('ad_der_ascite_cell_block');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'histogel_use', 'histogel use', '', 'checkbox', '', '', NULL, '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='creat_to_stor_spent_time_msg' AND `language_label`='creation to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `language_help`=''), '1', '1201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`='generated_parent_sample_sample_type_help'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created (into the system)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_created'), '1', '2000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='histogel_use' AND `language_label`='histogel use' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `language_help`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created (into the system)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_created'), '1', '2000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created (into the system)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_created'), '1', '2000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '0', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '0', `flag_detail` = '1', `flag_summary` = '0',
`display_column` = '1', `display_order` = '60'
WHERE structure_id IN (SELECT id FROM structures WHERE alias='' OR alias = '' OR alias LIKE 'ad_der_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='Generated' AND `field`='creat_to_stor_spent_time_msg');

UPDATE structure_formats 
SET `flag_add` = '1', `flag_add_readonly` = '0', 
`flag_edit` = '1', `flag_edit_readonly` = '0', 
`flag_search` = '1', `flag_search_readonly` = '0', 
`flag_addgrid` = '1', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '1', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '1', `flag_detail` = '1', `flag_summary` = '0',
`display_column` = '1', `display_order` = '1201'
WHERE structure_id IN (SELECT id FROM structures WHERE alias='' OR alias = '' OR alias LIKE 'ad_der_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='study_summary_id');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '0', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '1', `flag_detail` = '0', `flag_summary` = '1',
`display_column` = '0', `display_order` = '3'
WHERE structure_id IN (SELECT id FROM structures WHERE alias='' OR alias = '' OR alias LIKE 'ad_der_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='initial_specimen_sample_type');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '0', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '1', `flag_detail` = '0', `flag_summary` = '1',
`display_column` = '0', `display_order` = '4'
WHERE structure_id IN (SELECT id FROM structures WHERE alias='' OR alias = '' OR alias LIKE 'ad_der_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='parent_sample_type');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '1', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '1', `flag_detail` = '1', `flag_summary` = '1',
`display_column` = '1', `display_order` = '2000'
WHERE structure_id IN (SELECT id FROM structures WHERE alias='' OR alias = '' OR alias LIKE 'ad_der_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='created');
	
UPDATE structure_formats 
SET `flag_index` = '1', `flag_detail` = '1', `flag_summary` = '1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_der_cell_tubes_incl_ml_vol')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='current_volume');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='rec_to_stor_spent_time_msg' AND `language_label`='reception to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_stor_spent_time_msg' AND `language_label`='collection to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created (into the system)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_created'), '1', '2000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '0', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '0', `flag_detail` = '1', `flag_summary` = '0',
`display_column` = '1', `display_order` = '61'
WHERE structure_id IN (SELECT id FROM structures WHERE'ad_spec_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='Generated' AND `field`='rec_to_stor_spent_time_msg');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '0', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '0', `flag_detail` = '1', `flag_summary` = '0',
`display_column` = '1', `display_order` = '60'
WHERE structure_id IN (SELECT id FROM structures WHERE'ad_spec_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='Generated' AND `field`='coll_to_stor_spent_time_msg');
	
UPDATE structure_formats 
SET `flag_add` = '1', `flag_add_readonly` = '0', 
`flag_edit` = '1', `flag_edit_readonly` = '0', 
`flag_search` = '1', `flag_search_readonly` = '0', 
`flag_addgrid` = '1', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '1', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '1', `flag_detail` = '1', `flag_summary` = '0',
`display_column` = '1', `display_order` = '1201'
WHERE structure_id IN (SELECT id FROM structures WHERE'ad_spec_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='study_summary_id');

UPDATE structure_formats 
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '1', `flag_search_readonly` = '0', 
`flag_addgrid` = '0', `flag_addgrid_readonly` = '0', 
`flag_editgrid` = '0', `flag_editgrid_readonly` = '0', 
`flag_batchedit` = '0', `flag_batchedit_readonly` = '0', 
`flag_index` = '1', `flag_detail` = '1', `flag_summary` = '0',
`display_column` = '1', `display_order` = '2000'
WHERE structure_id IN (SELECT id FROM structures WHERE'ad_spec_%')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='created');
	
	



