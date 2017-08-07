-- ------------------------------------------------------
-- ATiM Database Upgrade Script
-- version: 2.7.1
--
-- For more information:
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- Create the view_structure_formats_simplified view by combination of 
-- structure_formats, structure_fields, structure and structure_value_domains table
-- -------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `view_structure_formats_simplified`;
DROP VIEW IF EXISTS `view_structure_formats_simplified`;
CREATE VIEW `view_structure_formats_simplified` AS 
select 
CONCAT (`sfo`.`id`,`sfi`.`id`) AS `id`,
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
sfi.sortable,
`sfo`.`flag_add` AS `flag_add`,`sfo`.`flag_add_readonly` AS `flag_add_readonly`,
`sfo`.`flag_edit` AS `flag_edit`,`sfo`.`flag_edit_readonly` AS `flag_edit_readonly`,
`sfo`.`flag_search` AS `flag_search`,`sfo`.`flag_search_readonly` AS `flag_search_readonly`,
`sfo`.`flag_addgrid` AS `flag_addgrid`,`sfo`.`flag_addgrid_readonly` AS `flag_addgrid_readonly`,
`sfo`.`flag_editgrid` AS `flag_editgrid`,`sfo`.`flag_editgrid_readonly` AS `flag_editgrid_readonly`,
`sfo`.`flag_batchedit` AS `flag_batchedit`,`sfo`.`flag_batchedit_readonly` AS `flag_batchedit_readonly`,
`sfo`.`flag_index` AS `flag_index`,`sfo`.`flag_detail` AS `flag_detail`,`sfo`.`flag_summary` AS `flag_summary`,
`sfo`.`flag_float` AS `flag_float`,
`sfo`.`display_column` AS `display_column`,
`sfo`.`display_order` AS `display_order`,
`sfo`.`language_heading` AS `language_heading`,
`sfo`.`margin` AS `margin` 
from (((`structure_formats` `sfo` join `structure_fields` `sfi` on((`sfo`.`structure_field_id` = `sfi`.`id`))) join `structures` `str` on((`str`.`id` = `sfo`.`structure_id`))) left join `structure_value_domains` `svd` on((`svd`.`id` = `sfi`.`structure_value_domain`)));
UPDATE structure_fields SET sortable = '0' WHERE model IN ('0', 'FunctionManagement', 'Generated', 'GeneratedParentAliquot', 'GeneratedParentSample');

-- -------------------------------------------------------------------------------------
-- Change the deprecated notEmpty rule to notBlank
-- -------------------------------------------------------------------------------------

UPDATE structure_validations SET rule='notBlank' WHERE rule='notEmpty';
	
-- ---------------------------------------------------------------------------------------------------------------
-- Announcements Management Review
--   - Remove group_id from announcements to fix issue #3392 (Move User to another group : Messages are lost)
--   - Add check before bank/user deletion: No announcement should be linked to the record
-- ---------------------------------------------------------------------------------------------------------------

-- Add no deletion message
	
INSERT IGNORE INTO i18n (id,en,fr)
VALUES 	
('at least one announcement is linked to that bank', 'At least one announcement is linked to that bank', 'Au moins une annonce est attachée à cette banque'),
('at least one announcement is linked to that user', 'At least one announcement is linked to that user', 'Au moins une annonce est attachée à cet utilisateur');

-- Foreign Key Clean Up

ALTER TABLE `announcements` MODIFY `bank_id` int(11) DEFAULT NULL;
ALTER TABLE `announcements_revs` MODIFY `bank_id` int(11) DEFAULT NULL;

SET @modified = (SELECT NOW());
UPDATE announcements SET group_id = null, modified = @modified WHERE group_id IS NOT NULL;

UPDATE announcements SET user_id = null, modified = @modified WHERE user_id = 0;
UPDATE announcements SET bank_id = null, modified = @modified WHERE bank_id = 0;
UPDATE announcements SET group_id = null, modified = @modified WHERE group_id = 0;

UPDATE announcements SET user_id = null, modified = @modified WHERE user_id IS NOT NULL AND user_id NOT IN (SELECT id FROM users);
UPDATE announcements SET bank_id = null, modified = @modified WHERE bank_id IS NOT NULL AND bank_id NOT IN (SELECT id FROM banks);
UPDATE announcements SET group_id = null, modified = @modified WHERE group_id IS NOT NULL AND group_id NOT IN (SELECT id FROM groups);

UPDATE announcements SET deleted = 1, modified = @modified WHERE user_id IN (SELECT id FROM users WHERE deleted = 1);
UPDATE announcements SET deleted = 1, modified = @modified WHERE bank_id IN (SELECT id FROM banks WHERE deleted = 1);
UPDATE announcements SET deleted = 1, modified = @modified WHERE group_id IN (SELECT id FROM groups WHERE deleted = 1);

ALTER TABLE `announcements`
  ADD CONSTRAINT `FK_announcements_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
ALTER TABLE `announcements`
  ADD CONSTRAINT `FK_announcements_banks` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`);
ALTER TABLE `announcements`
  ADD CONSTRAINT `FK_announcements_groups` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`);

INSERT INTO announcements_revs (id,user_id,group_id,bank_id,date,date_accuracy,title,body,date_start,date_start_accuracy,date_end,date_end_accuracy,modified_by,version_created)
(SELECT id,user_id,group_id,bank_id,date,date_accuracy,title,body,date_start,date_start_accuracy,date_end,date_end_accuracy,modified_by,modified FROM announcements WHERE modified = @modified);

-- Menus Update

UPDATE menus SET use_link = REPLACE(use_link, '/Administrate/Announcements/index/user/%%Group.id%%', '/Administrate/Announcements/index/user/');
UPDATE menus SET language_title = 'announcements' WHERE  use_link LIKE '/Administrate/Announcements/index/user%';

-- --------------------------------------------------------------------------------------------------------------------
-- Issue #3382: Participant Identifiers Report: No participant found with partial part of the participant identifier
--    Added warning message.
-- --------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('all searches are considered as exact searches', 'All searches are considered as exact searches', 'Toutes les recherches sont considérées comme des recherches exactes');






















-- -------------------------------------------------------------------------------------
-- Correct one word's spell
-- -------------------------------------------------------------------------------------

REPLACE INTO `i18n` (id,en,fr) 
VALUES
('please complete the security questions', 'Please complete the security questions', 'Veuillez compléter les questions de sécurités');

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.0', NOW(),'xxxx','n/a');
