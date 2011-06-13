-- run after v2.2.2
INSERT INTO banks(`name`, `description`, `created_by`, `created`, `modified_by`, `modified`) VALUES
('OHRI-COEUR', '', 1, NOW(), 1, NOW()),
('CBCF-COEUR', '', 1, NOW(), 1, NOW()),
('OVCare', '', 1, NOW(), 1, NOW());
INSERT INTO misc_identifier_controls (misc_identifier_name, misc_identifier_name_abbrev, flag_once_per_participant) VALUES
('OHRI-COEUR', 'OHRI-COEUR', 1),
('CBCF-COEUR', 'CBCF-COEUR', 1),
('OVCare', 'OVCare', 1);

ALTER TABLE banks
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
ALTER TABLE banks_revs
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
 
UPDATE banks SET misc_identifier_control_id=id;

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_type"),  (SELECT id FROM structure_permissible_values WHERE value="radiotherapy" AND language_alias="radiotherapy"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("suboptimal", "suboptimal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_residual_disease"),  (SELECT id FROM structure_permissible_values WHERE value="suboptimal" AND language_alias="suboptimal"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("radiotherapy", "radiotherapy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_type"),  (SELECT id FROM structure_permissible_values WHERE value="radiotherapy" AND language_alias="radiotherapy"), "0", "1");

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

