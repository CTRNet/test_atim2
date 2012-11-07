SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire version date');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('2006', '', '', '1', @control_id, NOW(), NOW(), 1, 1);

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles") AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="present" AND language_alias="present");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("unilateral","unilateral"),
("bilateral","bilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles"), 
(SELECT id FROM structure_permissible_values WHERE value="unilateral" AND language_alias="unilateral"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles"), 
(SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "3", "1");
REPLACE INTO i18n (id,en,fr) VALUES ('unilateral','Unilateral','Unilatéral'),('bilateral','Bilateral','Bilatéral');

ALTER TABLE procure_ed_lab_diagnostic_information_worksheets DROP COLUMN highest_prc_of_tumoral_zone_of_core;
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets_revs DROP COLUMN highest_prc_of_tumoral_zone_of_core;
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'highest_prc_of_tumoral_zone_of_core');
DELETE FROM structure_fields WHERE field = 'highest_prc_of_tumoral_zone_of_core';

ALTER TABLE procure_ed_lab_diagnostic_information_worksheets 
  ADD COLUMN affected_core_localisation varchar(250) DEFAULT NULL,
  ADD COLUMN affected_core_total_percentage decimal(10,2) DEFAULT NULL, 
  ADD COLUMN highest_gleason_score_observed varchar(50) DEFAULT NULL, 
  ADD COLUMN highest_gleason_score_percentage decimal(10,2) DEFAULT NULL;
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets_revs
  ADD COLUMN affected_core_localisation varchar(250) DEFAULT NULL,
  ADD COLUMN affected_core_total_percentage decimal(10,2) DEFAULT NULL, 
  ADD COLUMN highest_gleason_score_observed varchar(50) DEFAULT NULL, 
  ADD COLUMN highest_gleason_score_percentage decimal(10,2) DEFAULT NULL; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'procure_ed_lab_diagnostic_information_worksheets', 'affected_core_localisation', 'input',  NULL , '0', 'size=30', '', '', 'affected core localisation', ''), 
('ClinicalAnnotation', 'EventMaster', 'procure_ed_lab_diagnostic_information_worksheets', 'affected_core_total_percentage', 'float',  NULL , '0', 'size=6', '', '', 'affected core total percentage', ''), 
('ClinicalAnnotation', 'EventMaster', 'procure_ed_lab_diagnostic_information_worksheets', 'highest_gleason_score_observed', 'input',  NULL , '0', 'size=6', '', '', 'highest gleason score observed', ''), 
('ClinicalAnnotation', 'EventMaster', 'procure_ed_lab_diagnostic_information_worksheets', 'highest_gleason_score_percentage', 'float',  NULL , '0', 'size=6', '', '', 'highest gleason score percentage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='affected_core_localisation' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='affected core localisation' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='affected_core_total_percentage' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='affected core total percentage' AND `language_tag`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='highest_gleason_score_observed' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='highest gleason score observed' AND `language_tag`=''), '1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='highest_gleason_score_percentage' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='highest gleason score percentage' AND `language_tag`=''), '1', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='highest_gleason_score_observed' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='highest_gleason_score_percentage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'); 
INSERT INTO i18n (id,en,fr) VALUES
('affected core localisation', 'Affected core(s) localisation', 'Localisation zone(s) atteinte(s)'), 
('affected core total percentage', 'Total affected core(s) &#37;', '&#37; total zone(s) atteinte(s)'), 
('highest gleason score observed', 'Highest Gleason Score observed', 'Score de Gleason le plus élevé'), 
('highest gleason score percentage', '&#37; of the highest Gleason Score', '&#37; d''atteinte du score de Gleason le plus élevé');
  UPDATE structure_fields SET  `model`='EventDetail' WHERE model='EventMaster' AND tablename='procure_ed_lab_diagnostic_information_worksheets' AND field='affected_core_localisation' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail' WHERE model='EventMaster' AND tablename='procure_ed_lab_diagnostic_information_worksheets' AND field='affected_core_total_percentage' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail' WHERE model='EventMaster' AND tablename='procure_ed_lab_diagnostic_information_worksheets' AND field='highest_gleason_score_observed' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail' WHERE model='EventMaster' AND tablename='procure_ed_lab_diagnostic_information_worksheets' AND field='highest_gleason_score_percentage' AND `type`='float' AND structure_value_domain  IS NULL ;

ALTER TABLE sd_spe_tissues 
	CHANGE procure_number_to_slides_collected procure_number_of_slides_collected int(6) DEFAULT NULL,
	CHANGE procure_number_to_slides_collected_for_procure procure_number_of_slides_collected_for_procure int(6) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs
	CHANGE procure_number_to_slides_collected procure_number_of_slides_collected int(6) DEFAULT NULL,
	CHANGE procure_number_to_slides_collected_for_procure procure_number_of_slides_collected_for_procure int(6) DEFAULT NULL;	
UPDATE structure_fields SET field = 'procure_number_of_slides_collected' WHERE field = 'procure_number_to_slides_collected';
UPDATE structure_fields SET field = 'procure_number_of_slides_collected_for_procure' WHERE field = 'procure_number_to_slides_collected_for_procure';



