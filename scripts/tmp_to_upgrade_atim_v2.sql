 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('add uses', 'global', 'Add Uses', 'Cr&eacute;er utilisations');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('access to order', 'global', 'Access To Order', 'Acc&eacute;der &agrave; la commande');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('add internal use', 'global', 'Add Internal Use', 'Cr&eacute;er utilisation interne');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('define realiquoted children', 'global', 'Define Realiquoted Children', 'D&eacute;finir enfants r&eacute;-aliquot&eacute;s');

UPDATE `i18n` SET `fr` = 'Utilisation interne' 
WHERE `id` = 'internal use';

INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`) VALUES
(null, '6', (SELECT id FROM `structure_permissible_values` WHERE `value` LIKE 'n/a' LIMIT 0,1), 0, 'yes', 'n/a');

UPDATE `structure_formats` SET `language_tag` = ':' 
WHERE `structure_formats`.`id` = 2208 ;

UPDATE `structure_formats` SET `language_tag` = ':' 
WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1277' ;

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
(':', 'global', ':', ':');

UPDATE `structures`
SET `alias` = 'aliquotuses_system_dependent'
WHERE `alias` = 'linkedaliquotuses';

DELETE FROM `i18n` WHERE `id` = 'used by';
 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('used by', 'global', 'Used By', 'Utilis&eacute; par');

DELETE FROM `i18n` WHERE `id` = 'study';
 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('study', 'global', 'Study', '&Eacute;tude');