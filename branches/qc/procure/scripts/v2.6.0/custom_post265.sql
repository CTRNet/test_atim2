
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


























INSERT INTO i18n (id,en,fr) 
VALUES 
("please validate that all aliquots identifications are consistent with the participant identification", 
"Please validate that all aliquots identifications are consistent with the participant identification.",
"Veuillez valider que les identifications des aliquots sont compatibles avec l'identification du participant.");



































UPDATE versions SET branch_build_number = '6???' WHERE version_number = '2.6.5';