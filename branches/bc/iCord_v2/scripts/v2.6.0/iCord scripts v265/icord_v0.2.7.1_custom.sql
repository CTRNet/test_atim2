-- Under Animal Specific Data, remove 'Injury type' field #495

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES ('core_installname', 'iCord v0.2.7.1', 'iCord v0.2.7.1');

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES ('Sham', 'Sham');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES ('Sham', 'Sham', '');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES ((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_injury_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'Sham'), 4, 1, 1);

UPDATE structure_value_domains_permissible_values SET `flag_active` = 0 WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_injury_type') AND (`structure_permissible_value_id` = (SELECT `id` FROM structure_permissible_values WHERE `value` = 'contusion') OR `structure_permissible_value_id` = (SELECT `id` FROM structure_permissible_values WHERE `value` = 'compression'));

-- make field as default in select
UPDATE structure_fields SET `default` = 'contusion+compression' WHERE `field` = 'pig_injury_type' and `type` = 'select' and `tablename` = 'dxd_animals' and `model` = 'DiagnosisDetail';