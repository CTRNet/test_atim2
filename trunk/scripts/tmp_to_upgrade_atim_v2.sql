UPDATE `structure_permissible_values` SET value='fre' WHERE id=757;
UPDATE `structure_permissible_values` SET value='eng' WHERE id=758;

UPDATE `structure_fields` SET `language_label` = 'city',
`language_tag` = '' WHERE `structure_fields`.`id` =69 LIMIT 1 ;

UPDATE `structure_fields` SET `language_label` = 'region',
`language_tag` = '' WHERE `structure_fields`.`id` =70 LIMIT 1 ;

UPDATE `structure_fields` SET `language_label` = 'country',
`language_tag` = '' WHERE `structure_fields`.`id` =71 LIMIT 1 ;

UPDATE `structure_fields` SET `language_label` = 'mail_code',
`language_tag` = '' WHERE `structure_fields`.`id` =72 LIMIT 1 ;
