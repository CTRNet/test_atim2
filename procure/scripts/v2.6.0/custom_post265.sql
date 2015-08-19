
ALTER TABLE participants ADD COLUMN procure_transferred_participant char(1) default 'n';
ALTER TABLE participants_revs ADD COLUMN procure_transferred_participant char(1) default 'n';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_transferred_participant', 'yes_no',  NULL , '0', '', '', '', 'transferred participant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_transferred_participant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transferred participant' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('transferred participant','Transferred Participant','Participant Transféré'),
("the 'transferred participant' value has to be set","The 'transferred participant' value has to be set.","La donnée 'Participant Transféré' doit être complétée");

UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_banks", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("chuq", "chuq");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="chuq" AND language_alias="chuq"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("chum", "chum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="chum" AND language_alias="chum"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("chus", "chus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="chus" AND language_alias="chus"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("cusm", "cusm");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="cusm" AND language_alias="cusm"), "", "1");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('chum', 'CHUM', 'CHUM'),
('chuq', 'CHUQ', 'CHUQ'),
('chus', 'CHUS', 'CHUS'),
('cusm', 'MUHC', 'CUSM');

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) VALUES
(null, 'participant study number', 0, 0, '', NULL, 
0, 0, 0, 0, '', '', 1);
INSERT INTO i18n (id,en,fr) VALUES ('participant study number','Participant Study #', 'No étude patient');

SELECT 'Form Identification Control: Correct data if list below is not empty' AS '### MESSAGE ###';
SELECT CONCAT('ConsentMaster', '.', ConsentMaster.id) AS 'Model.id', Participant.participant_identifier, ConsentMaster.procure_form_identification
FROM participants Participant
INNER JOIN consent_masters ConsentMaster ON Participant.id = ConsentMaster.participant_id AND ConsentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND ConsentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier)
UNION ALL
SELECT CONCAT('TreatmentMaster', '.', TreatmentMaster.id) AS 'Model.id', Participant.participant_identifier, TreatmentMaster.procure_form_identification
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND TreatmentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier)
UNION ALL
SELECT CONCAT('EventMaster', '.', EventMaster.id) AS 'Model.id', Participant.participant_identifier, EventMaster.procure_form_identification
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id AND EventMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND EventMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier);

SELECT 'Aliquot Barcode Control: Correct data if list below is not empty' AS '### MESSAGE ###';
SELECT CONCAT('AliquotMaster', '.', AliquotMaster.id) AS 'Model.id', Participant.participant_identifier, AliquotMaster.barcode
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier);

INSERT INTO i18n (id,en,fr) 
VALUES 
("please validate that all aliquots identifications are consistent with the participant identification", 
"Please validate that all aliquots identifications are consistent with the participant identification.",
"Veuillez valider que les identifications des aliquots sont compatibles avec l'identification du participant.");

SELECT 'Set default value for field participants.procure_last_modification_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE participants ADD COLUMN procure_last_modification_by_bank VARCHAR(5);
ALTER TABLE participants_revs ADD COLUMN procure_last_modification_by_bank VARCHAR(5);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_last_modification_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', '', 'bank');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_modification_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='bank'), '3', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

SELECT 'Set default value for field ConsentMaster.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE consent_masters ADD COLUMN procure_created_by_bank VARCHAR(5);
ALTER TABLE consent_masters_revs ADD COLUMN procure_created_by_bank VARCHAR(5);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

SELECT 'Set default value for field EventMaster.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE event_masters ADD COLUMN procure_created_by_bank VARCHAR(5);
ALTER TABLE event_masters_revs ADD COLUMN procure_created_by_bank VARCHAR(5);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '-6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

SELECT 'Set default value for field TreatmentMaster.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE treatment_masters ADD COLUMN procure_created_by_bank VARCHAR(5);
ALTER TABLE treatment_masters_revs ADD COLUMN procure_created_by_bank VARCHAR(5);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '-5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');











ajouter la notion de bank au niveau des collections.
ne crééer qu'une branch pour central et processing...
























UPDATE versions SET branch_build_number = '6???' WHERE version_number = '2.6.5';