-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.0
--
-- For more information:
--    ./app/scripts£v2.7.0/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------

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


-- --------------------------------------------------------------------------------------------------------------------
-- Issue #3403: No check on 'TMA Slide Analysis/Scoring' linked to study before study deletion
-- --------------------------------------------------------------------------------------------------------------------

UPDATE i18n SET id = 'study/project is assigned to a tma slide' WHERE id = 'study/project is assigned to a  tma slide';
INSERT INTO i18n (id,en,fr) 
VALUE
('study/project is assigned to a tma slide use', "Your data cannot be deleted! This study/project is linked to a TMA slide use.", "Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à une utilisation de lame de TMA.");
UPDATE i18n SET fr = 'Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à une lame de TMA.' WHERE fr = 'Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un lame de TMA.';

-- --------------------------------------------------------------------------------------------------------------------
-- Add time to message displayed to inform user that connection to ATiM has been disabled temporarily.
-- --------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('too many failed login attempts - connection to atim disabled temporarily for %s mn', 
'Too many failed login attempts. Your connection to ATiM has been disabled temporarily for %s minutes.', 'Trop de tentatives de connexion. Votre connexion à ATiM a été désactivée temporairement pendant %s minutes.');

-- --------------------------------------------------------------------------------------------------------------------
-- Add missing autocomplete_.*_study_summary_id 
-- (see issue #3372: fields not necessary added to structures by atim_v2.6.8_upgrade.sql script)
-- --------------------------------------------------------------------------------------------------------------------

SET @input_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'title' AND model = 'StudySummary' AND tablename = 'study_summaries' aND type = 'input' AND setting='size=40');

-- aliquotinternaluses

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_aliquot_internal_use_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'aliquotinternaluses');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- aliquot_masters

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_aliquot_master_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'aliquot_masters');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- aliquot_master_edit_in_batchs

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_aliquot_master_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'aliquot_master_edit_in_batchs');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- consent_masters_study

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_consent_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'consent_masters_study');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- miscidentifiers_study

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_misc_identifier_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'miscidentifiers_study');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- orderlines

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_order_line_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'orderlines');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- orders

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_order_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'orders');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- tma_slides

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_tma_slide_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'tma_slides');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- tma_slide_uses

SET @auto_complete_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'autocomplete_tma_slide_use_study_summary_id' AND model = 'FunctionManagement');
SET @structure_id = (SELECT id FROM structures WHERE alias = 'tma_slide_uses');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`)
(SELECT
sfo.`structure_id`, @auto_complete_structure_field_id, sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.id = @input_structure_field_id
AND sfo.`structure_id` = @structure_id
AND sfo.`structure_id` NOT IN (
	SELECT
	sfo.`structure_id`
	FROM structure_fields sfi
	INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
	WHERE sfi.model LIKE 'FunctionManagement' 
	AND sfi.field LIKE 'autocomplete_%_study_summary_id%' 
	AND sfi.type='autocomplete' 
	AND sfi.setting LIKE '%url=/Study/StudySummaries/autocompleteStudy%'
));

-- --------------------------------------------------------------------------------------------------------------------
-- Change message of the report compareToBatchSetOrNode()
-- --------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUE 
('data of previously displayed %s_1 (1)', 'Previous %s_1 (1)', '%s_1 précédent (1)'),
('data of previously displayed %s_1 only (1)', 'Previous %s_1 only (1)', '%s_1 précédent seulement (1)'),
('data of selected %s_2 (2)', 'Selected/Chosen %s_2 (2)', '%s_2 sélectionné/choisi (2)'),
('data of selected %s_2 only (2)', 'Selected/Chosen %s_2 only (2)', '%s_2 sélectionné/choisi seulement (2)');

REPLACE INTO i18n (id,en,fr)
VALUE
('data both in previously displayed %s_1 and selected %s_2 (1 & 2)', 'Both in previously %s_1 and selected/chosen %s_2 (1 & 2)', 'Dans le %s_1 précédent et le %s_2 sélectionné/choisi (1 & 2)');

-- --------------------------------------------------------------------------------------------------------------------
-- Issue #3423: Add quality control and tissue review to collection tree view when data not linked to an aliquot
-- --------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('sample_uses_for_collection_tree_view');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Generated', '', 'sample_use_definition', 'input',  NULL , '0', 'size=30', '', '', 'use and/or event', ''), 
('InventoryManagement', 'Generated', '', 'sample_use_code', 'input',  NULL , '0', 'size=30', '', '', '', ':'), 
('InventoryManagement', 'Generated', '', 'sample_use_date', 'date',  NULL , '0', '', '', '', 'date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_uses_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='sample_use_definition' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='use and/or event' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='sample_uses_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='sample_use_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=':'), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='sample_uses_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='sample_use_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- --------------------------------------------------------------------------------------------------------------------
-- Issue #3440: StructureField.sortable field set to 0 by script should be reviewed...
-- --------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET `sortable` = 1 WHERE field = 'batchset_and_node_elements_distribution_description' AND model = 'Generated';

UPDATE structure_fields SET `sortable` = 1 WHERE field = 'sample_type' AND model = '0';
UPDATE structure_fields SET `sortable` = 1 WHERE field = 'cases_nbr' AND model = '0';
UPDATE structure_fields SET `sortable` = 1 WHERE field = 'aliquots_nbr' AND model = '0';
UPDATE structure_fields SET `sortable` = 1 WHERE field = 'notes' AND model = '0';

UPDATE structure_fields SET `sortable` = 1 WHERE field = 'nbr_of_elements' AND model = 'Generated';

UPDATE structure_fields SET `sortable` = 1 WHERE field = 'created_samples_nbr' AND model = '0';
UPDATE structure_fields SET `sortable` = 1 WHERE field = 'matching_participant_number' AND model = '0';

-- -------------------------------------------------------------------------------------
-- Correct one word's spell
-- -------------------------------------------------------------------------------------

REPLACE INTO `i18n` (id,en,fr) 
VALUES
('the deleted collection is linked to participant', 'Your data cannot be deleted! Collection is linked to participant.', 'Vos données ne peuvent être supprimées! La collection est attachée à un participant.'),
('please complete the security questions', 'Please complete the security questions', 'Veuillez compléter les questions de sécurités');

UPDATE i18n SET en = REPLACE(en, 'Your data cannot be deleted! <br>', 'Your data cannot be deleted! ');
UPDATE i18n SET fr = REPLACE(fr, 'Vos données ne peuvent être supprimées! <br>', 'Vos données ne peuvent être supprimées! ');

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.0', NOW(),'6858','n/a');
