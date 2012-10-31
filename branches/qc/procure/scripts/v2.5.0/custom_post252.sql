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