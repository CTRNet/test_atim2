-- ------------------------------------------------------
-- ATiM v2.7.0 Upgrade Script
-- version: 2.7.0
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added id field for view 'view_structure_formats_simplified' because id field is required (for CakePHP 2.5+)
-- -----------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `view_structure_formats_simplified`;
DROP VIEW IF EXISTS `view_structure_formats_simplified`;
CREATE VIEW `view_structure_formats_simplified` AS SELECT
concat(`sfo`.`id`,'-',`sfi`.`id`) AS `id`,
`str`.`alias` AS `structure_alias`,
`sfo`.`id` AS `structure_format_id`,
`sfi`.`id` AS `structure_field_id`,
`sfo`.`structure_id` AS `structure_id`,
`sfi`.`plugin` AS `plugin`,
`sfi`.`model` AS `model`,
`sfi`.`tablename` AS `tablename`,
`sfi`.`field` AS `field`,
`sfi`.`structure_value_domain` AS `structure_value_domain`,
`svd`.`domain_name` AS `structure_value_domain_name`,
`sfi`.`flag_confidential` AS `flag_confidential`,
if((`sfo`.`flag_override_label` = '1'),`sfo`.`language_label`,`sfi`.`language_label`) AS `language_label`,
if((`sfo`.`flag_override_tag` = '1'),`sfo`.`language_tag`,`sfi`.`language_tag`) AS `language_tag`,
if((`sfo`.`flag_override_help` = '1'),`sfo`.`language_help`,`sfi`.`language_help`) AS `language_help`,
if((`sfo`.`flag_override_type` = '1'),`sfo`.`type`,`sfi`.`type`) AS `type`,
if((`sfo`.`flag_override_setting` = '1'),`sfo`.`setting`,`sfi`.`setting`) AS `setting`,
if((`sfo`.`flag_override_default` = '1'),`sfo`.`default`,`sfi`.`default`) AS `default`,
`sfi`.`sortable` AS `sortable`,
`sfo`.`flag_add` AS `flag_add`,
`sfo`.`flag_add_readonly` AS `flag_add_readonly`,
`sfo`.`flag_edit` AS `flag_edit`,
`sfo`.`flag_edit_readonly` AS `flag_edit_readonly`,
`sfo`.`flag_search` AS `flag_search`,
`sfo`.`flag_search_readonly` AS `flag_search_readonly`,
`sfo`.`flag_addgrid` AS `flag_addgrid`,
`sfo`.`flag_addgrid_readonly` AS `flag_addgrid_readonly`,
`sfo`.`flag_editgrid` AS `flag_editgrid`,
`sfo`.`flag_editgrid_readonly` AS `flag_editgrid_readonly`,
`sfo`.`flag_batchedit` AS `flag_batchedit`,
`sfo`.`flag_batchedit_readonly` AS `flag_batchedit_readonly`,
`sfo`.`flag_index` AS `flag_index`,
`sfo`.`flag_detail` AS `flag_detail`,
`sfo`.`flag_summary` AS `flag_summary`,
`sfo`.`flag_float` AS `flag_float`,
`sfo`.`display_column` AS `display_column`,
`sfo`.`display_order` AS `display_order`,
`sfo`.`language_heading` AS `language_heading`,
`sfo`.`margin` AS `margin` 
FROM (((`structure_formats` `sfo` join `structure_fields` `sfi` on((`sfo`.`structure_field_id` = `sfi`.`id`))) 
JOIN `structures` `str` on((`str`.`id` = `sfo`.`structure_id`))) 
LEFT JOIN `structure_value_domains` `svd` on((`svd`.`id` = `sfi`.`structure_value_domain`)));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update Validation rule 'notEmpty' (deprecated) to 'notBlank' (for CakePHP 2.7+)
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_validations SET rule='notBlank' WHERE rule='notEmpty';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.0', NOW(),'5617','n/a');
