
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';

ALTER TABLE participants ADD COLUMN `qc_lady_sardo_data_migration_date` date DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN `qc_lady_sardo_data_migration_date` date DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_lady_sardo_data_migration_date', 'date',  NULL , '0', '', '', '', 'sardo migration date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_sardo_data_migration_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sardo migration date' AND `language_tag`=''), '3', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('sardo migration date','SARDO Data Migration','Migration Données SARDO');

UPDATE versions SET branch_build_number = '5736' WHERE version_number = '2.6.2';

-- -------------------------------------------------------------------------------------------------------------------
-- SQL statements executed on 2014-05-20
-- -------------------------------------------------------------------------------------------------------------------

-- Participant Race

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Races');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
('other', 'Other', 'Autre', '1', @control_id, NOW(), NOW(), 1, 1);

-- Consent Status

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("to be verified", "to be verified"),("not obtained", "not obtained"),("sent", "sent");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="to be verified" AND language_alias="to be verified"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="not obtained" AND language_alias="not obtained"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="sent" AND language_alias="sent"), "", "1");
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('to be verified','To be verified','À vérifier'),('not obtained','Not obtained','Non-obtenu'),('sent','Ssent','Envoyé');

-- Delete any EventSmoking

UPDATE event_masters SET deleted = 1 WHERE event_control_id IN (SELECT id FROM event_controls WHERE flag_active = 0);

-- Imaging types

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Imaging Types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
INSERT INTO `structure_permissible_values_customs` (`value`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("mammographie","Mammographie", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie des seins","Echographie des seins", '1', @control_id, NOW(), NOW(), 1, 1),
("scintigraphie osseuse","Scintigraphie osseuse", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie abdominale, thoracique et pelvienne","Tomodensitométrie abdominale, thoracique et pelvienne", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du sein","IRM du sein", '1', @control_id, NOW(), NOW(), 1, 1),
("radiographie osseuse","Radiographie osseuse", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie crânienne","Tomodensitométrie crânienne", '1', @control_id, NOW(), NOW(), 1, 1),
("tomographie d'émission par positron du corps entier","Tomographie d'émission par positron du corps entier", '1', @control_id, NOW(), NOW(), 1, 1),
("irm de la colonne vertébrale","IRM de la colonne vertébrale", '1', @control_id, NOW(), NOW(), 1, 1),
("irm osseuse","IRM osseuse", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie abdominale et thoracique","Tomodensitométrie abdominale et thoracique", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie de l'aisselle","Echographie de l'aisselle", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie de la colonne vertébrale","Tomodensitométrie de la colonne vertébrale", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie abdominale","Echographie abdominale", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie abdominale et pelvienne","Tomodensitométrie abdominale et pelvienne", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie du rachis cervival","Tomodensitométrie du rachis cervival", '1', @control_id, NOW(), NOW(), 1, 1),
("radiographie thoracique","Radiographie thoracique", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie thoracique","Tomodensitométrie thoracique", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie abdominale et pelvienne","Echographie abdominale et pelvienne", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du foie","IRM du foie", '1', @control_id, NOW(), NOW(), 1, 1),
("irm abdominale","IRM abdominale", '1', @control_id, NOW(), NOW(), 1, 1),
("irm de la tête","IRM de la tête", '1', @control_id, NOW(), NOW(), 1, 1),
("tomographie d'émission par positron de la région cervicale et du tronc","Tomographie d'émission par positron de la région cervicale et du tronc", '1', @control_id, NOW(), NOW(), 1, 1),
("coloscopie","Coloscopie", '1', @control_id, NOW(), NOW(), 1, 1),
("angioscan","Angioscan", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du cerveau","IRM du cerveau", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie du cerveau","Tomodensitométrie du cerveau", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie ganglionnaire","Echographie ganglionnaire", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie du rachis lombaire","Tomodensitométrie du rachis lombaire", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du rachis lombaire","IRM du rachis lombaire", '1', @control_id, NOW(), NOW(), 1, 1),
("irm pelvienne","IRM pelvienne", '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE qc_lady_imagings SET type = lower(type);


