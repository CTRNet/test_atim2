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

DELETE FROM `atim_new`.`menus` WHERE `menus`.`id` = 'inv_CAN_2232' LIMIT 1;

UPDATE `structure_formats` SET `flag_override_label` = '1',
`language_label` = 'Date' WHERE `structure_formats`.`id` =2233 LIMIT 1 ;

DELETE FROM `atim_new`.`menus` WHERE `menus`.`id` = 'inv_CAN_2242' LIMIT 1;

UPDATE `menus` SET `use_link` = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/',
`use_summary`='Inventorymanagement.AliquotMaster::summary'
WHERE `menus`.`id` = 'inv_CAN_2233' LIMIT 1 ;

UPDATE `menus` SET `use_link` = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/',
`use_summary`='Inventorymanagement.AliquotMaster::summary'
 WHERE `menus`.`id` = 'inv_CAN_22233' LIMIT 1 ;
