UPDATE `structure_formats` SET `flag_add` = '0', `flag_edit_readonly` = '1' WHERE `structure_formats`.`id` =2249 LIMIT 1 ;

INSERT INTO `i18n` (
`id` ,
`page_id` ,
`en` ,
`fr`
)
VALUES (
'click to add a line', 'global', 'Click to add a line', 'Cliquez pour ajouter une ligne'
), (
'click to remove these elements', '', 'Click to remove these elements', 'Cliquez pour supprimer ces éléments'
), (
'uses', '', 'Uses', 'Utilisations'
);

DELETE FROM `menus` WHERE `menus`.`id` = 'inv_CAN_2232' LIMIT 1;

UPDATE `structure_formats` SET `flag_override_label` = '1',
`language_label` = 'Date' WHERE `structure_formats`.`id` =2233 LIMIT 1 ;

DELETE FROM `menus` WHERE `menus`.`id` = 'inv_CAN_2242' LIMIT 1;

UPDATE `menus` SET `use_link` = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/',
`use_summary`='Inventorymanagement.AliquotMaster::summary'
WHERE `menus`.`id` = 'inv_CAN_2233' LIMIT 1 ;

UPDATE `menus` SET `use_link` = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/',
`use_summary`='Inventorymanagement.AliquotMaster::summary'
 WHERE `menus`.`id` = 'inv_CAN_22233' LIMIT 1 ;

 update structure_formats set flag_search='1' where structure_id=122;
 

ALTER TABLE `pd_chemos`
  DROP `num_cycles`,
  DROP `length_cycles`;
  
ALTER TABLE `pd_chemos_revs`
  DROP `num_cycles`,
  DROP `length_cycles`;
  
TRUNCATE `protocol_controls`;

INSERT INTO `protocol_controls` (
`id` ,
`tumour_group` ,
`type` ,
`detail_tablename` ,
`form_alias` ,
`extend_tablename` ,
`extend_form_alias` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES (
NULL , 'all' , 'chemotherapy' , 'pd_chemos', 'pd_chemos', 'pe_chemos', 'pe_chemos', NULL , NULL , NULL , NULL
);

DELETE FROM `structures` WHERE `structures`.`id` = 187 LIMIT 1;
ALTER TABLE `structures` ADD UNIQUE (`alias`);

DELETE FROM structure_formats WHERE id IN (1494, 1495);
DELETE FROM structure_fields WHERE id IN(566, 567);

UPDATE `structure_formats` SET `display_order` = '2' WHERE `structure_formats`.`id` =1496 LIMIT 1 ;

UPDATE `structure_formats` SET `display_order` = '3' WHERE `structure_formats`.`id` =1497 LIMIT 1 ;

UPDATE `structure_formats` SET `display_order` = '4' WHERE `structure_formats`.`id` =1498 LIMIT 1 ;

UPDATE `structure_formats` SET `display_order` = '1' WHERE `structure_formats`.`id` =1499 LIMIT 1 ;

UPDATE `structure_value_domains_permissible_values` SET `language_alias` = 'p.o.: by mouth' WHERE `structure_value_domains_permissible_values`.`id` =439 LIMIT 1 ;

UPDATE `structure_value_domains_permissible_values` SET `language_alias` = 'IV: Intravenous', display_order = 4 WHERE `structure_value_domains_permissible_values`.`id` =440 LIMIT 1 ;

UPDATE `structure_permissible_values` SET value='p.o.: by mouth', language_alias='p.o.: by mouth' WHERE id=439;
UPDATE `structure_permissible_values` SET value='IV: Intravenous', language_alias='IV: Intravenous' WHERE id=440;

INSERT INTO `structure_permissible_values` (value, language_alias) VALUES
('IM: intramuscular injection', 'IM: intramuscular injection'),
('SC: subcutaneous injection', 'SC: subcutaneous injection'),
('PR: per rectum', 'PR: per rectum');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values` (structure_value_domain_id, structure_permissible_value_id, display_order, active, language_alias) VALUES
(100, @last_id, 2, 'yes', 'IM: intramuscular injection'),
(100, @last_id + 1, 3, 'yes', 'SC: subcutaneous injection'),
(100, @last_id + 2, 5, 'yes', 'PR: per rectum');
