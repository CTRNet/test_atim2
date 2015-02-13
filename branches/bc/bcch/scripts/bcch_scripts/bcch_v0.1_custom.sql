-- BCCH Customization Script
-- Version: v0.1
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.1", '');

--  =========================================================================
--	Eventum ID: #3108 - Core Upgrade - v2.6.3
--	=========================================================================
/*
-- Deactivate Participant Identifiers demo report
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');


-- Extended Treatment tables (txe_radiations)
SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_radiations' AND detail_form_alias = 'txe_radiations');
ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM txe_radiations);

ALTER TABLE txe_radiations ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY FK_txe_radiations_tx_masters, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE treatment_extend_masters extend_master, txe_radiations extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE txe_radiations_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;
UPDATE txe_radiations_revs extend_detail_revs, txe_radiations extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE txe_radiations ADD CONSTRAINT FK_txe_radiations_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;
INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM txe_radiations_revs ORDER BY version_id ASC);
ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE txe_radiations_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;
UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);

-- Drop `txe_radiations`
DROP TABLE txe_radiations;
DROP TABLE txe_radiations_revs;

-- Flag inactive relationsips if required (see queries below).
-- Don't forget Collection to Annotation, Treatment,Consent, etc if not requried.
*/
/*
SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_to_2 = 1 OR ctrl.flag_active_2_to_1 = 1);
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');
Please flag inactive datamart structure functions if required (see queries below).
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...'));
Please change datamart_structures_relationships_en(and fr).png in appwebrootimgdataBrowser
*/

-- Review specimen review detail form `spr_breast_cancer_types`

/*
  Should change trunk ViewSample to fix bug #2690:
  Changed [SampleMaster.parent_id AS parent_sample_id,] to [SampleMaster.parent_id AS parent_id].
  Please review custom ViewSample $table_query.
*/
/*
-- Category for custom lookup domains
UPDATE `structure_permissible_values_custom_controls` SET `category`='clinical - consent' WHERE `name`='ccbr person consenting';
UPDATE `structure_permissible_values_custom_controls` SET `category`='clinical - consent' WHERE `name`='ccbr treating physician';
UPDATE `structure_permissible_values_custom_controls` SET `category`='inventory' WHERE `name`='ccbr sample pickup by';
*/
--  =========================================================================
--	Eventum ID: #3112 - Add study field to collection
--	=========================================================================

ALTER TABLE `collections`
ADD COLUMN `study_summary_id` INT(11) NULL DEFAULT NULL AFTER `event_master_id` ;

ALTER TABLE `collections_revs`
ADD COLUMN `study_summary_id` INT(11) NULL DEFAULT NULL AFTER `event_master_id` ;

-- Add to collections structure
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study summary id', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study summary id' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Add to view
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study summary id' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Linked collections
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study summary id' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('study summary id', "Study", '');

--  =========================================================================
--	Eventum ID: #3109 - Participant Identifier auto-increment
--  Format: C00001
--	=========================================================================

-- Executed on production system by Navee
UPDATE `structure_validations`
SET `rule` = '/^[0-9]+$/'
WHERE `structure_field_id` = 521 AND `rule` = '/^CCBR[0-9]+$/';

-- Set field to read-only on EDIT view. Remove from ADD view.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='1', `flag_edit_readonly`='1', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='1', `flag_batchedit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add new misc identifier type
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`) VALUES
 ('CCBR Identifier', '1', '4', '1', '0', '1', '0');

-- Create new misc identifier for each existing participant identifier
INSERT INTO `misc_identifiers` (`participant_id`, `identifier_value`, `misc_identifier_control_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `flag_unique`)
SELECT `id`, `participant_identifier`, (SELECT `id` FROM `misc_identifier_controls` WHERE `misc_identifier_name` = 'CCBR Identifier'), NOW(), (SELECT `id` FROM `users` WHERE `username` = 'administrator'), NOW(), (SELECT `id` FROM `users` WHERE `username` = 'administrator'), 0, 1 FROM `participants`;

-- Clear all existing identifiers to prep for new identifier values
UPDATE `participants` SET `participant_identifier` = '';

-- Fix validations for new format using C00001, required and unique
UPDATE `structure_validations` SET `rule`='notEmpty' WHERE `language_message`='error_participant identifier required';
UPDATE `structure_validations` SET `rule`='isUnique' WHERE `language_message`='error_participant identifier must be unique';

UPDATE `structure_validations` SET `rule` = 'custom,/^[C][0-9][0-9][0-9][0-9][0-9]$/'
WHERE `structure_field_id` = 521 AND `rule` = '/^[0-9]+$/' AND `language_message` = 'ccbr error participant identifier';

-- New error message
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr error participant identifier', "BCCH Biobank Identifier requires format: C00000 (C, followed by 5 digits)", '');

--  =========================================================================
--	Eventum ID: #3111 - Barcode generation
--	=========================================================================

-- Hide barcode field for aliquots. Will be auto-generated.
UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

--  =========================================================================
--	Eventum ID: #3110 - Label field for aliquots
--	=========================================================================

-- Set label to read-only on all add/edit forms
UPDATE structure_formats SET `flag_add_readonly`='0', `flag_addgrid_readonly`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


--  =========================================================================
--	Eventum ID: #3128 - Sample Code Format
--	=========================================================================

-- Set to readonly, remove from add form
UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

--  =========================================================================
--	Eventum ID: #3165 - CSV Export Fields
--	=========================================================================

-- Remove the Aliquot Type from the CSV
DELETE FROM `structure_formats` WHERE `structure_id`=(SELECT id FROM structures WHERE alias='aliquot_barcode') AND `structure_field_id`=(SELECT id FROM structure_fields WHERE plugin='InventoryManagement' AND model='AliquotControl' AND field='aliquot_type' AND language_label='aliquot type' AND type='select' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type'));

-- Add Label column to the CSV
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
 (NULL, (SELECT id FROM structures WHERE alias='aliquot_barcode'), (SELECT id FROM structure_fields WHERE plugin='InventoryManagement' AND model='AliquotMaster' AND tablename='aliquot_masters' AND field='aliquot_label' AND language_label='aliquot label' AND type='input'), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Add Study/Project to the CSV
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
 (NULL, (SELECT id FROM structures WHERE alias='aliquot_barcode'), (SELECT id FROM structure_fields WHERE plugin='InventoryManagement' AND model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND language_label='study / project' AND type='select'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Add Initial Storage Date to the CSV
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
 (NULL, (SELECT id FROM structures WHERE alias='aliquot_barcode'), (SELECT id FROM structure_fields WHERE plugin='InventoryManagement' AND model='AliquotMaster' AND tablename='aliquot_masters' AND field='storage_datetime' AND language_label='initial storage date' AND type='datetime'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

--  =========================================================================
--	Eventum ID: #3166 - BCCH Consent Form
--	=========================================================================

CREATE TABLE `cd_bcch_consents` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`bcch_verbal_consent` varchar(45) DEFAULT NULL,
`bcch_date_verbal_consent` date DEFAULT NULL,
`bcch_person_verbal_consent` varchar(45) DEFAULT NULL,
`bcch_formal_consent` varchar(45) DEFAULT NULL,
`bcch_formal_consent_type` varchar(45) DEFAULT NULL,
`bcch_date_formal_consent` date DEFAULT NULL,
`bcch_person_formal_consent` varchar(45) DEFAULT NULL,
`bcch_consent_all_donation` varchar(45) DEFAULT NULL,
`bcch_consent_tissue` varchar(45) DEFAULT NULL,
`bcch_consent_bone_marrow` varchar(45) DEFAULT NULL,
`bcch_consent_blood` varchar(45) DEFAULT NULL,
`bcch_consent_extra_blood` varchar(45) DEFAULT NULL,
`bcch_consent_csf` varchar(45) DEFAULT NULL,
`bcch_consent_leukopheresis` varchar(45) DEFAULT NULL,
`bcch_consent_genetic_material` varchar(45) DEFAULT NULL,
`bcch_consent_stem_cells` varchar(45) DEFAULT NULL,
`bcch_consent_buccal_swabs` varchar(45) DEFAULT NULL,
`bcch_consent_saliva` varchar(45) DEFAULT NULL,
`bcch_consent_urine` varchar(45) DEFAULT NULL,
`bcch_consent_stool` varchar(45) DEFAULT NULL,
`bcch_consent_prev_materials` varchar(45) DEFAULT NULL,
`bcch_consent_other_materials` varchar(45) DEFAULT NULL,
`bcch_other_materials_description` varchar(45) DEFAULT NULL,
`bcch_date_withdrawal_revoke` date DEFAULT NULL,
`bcch_consent_withdrawal` varchar(45) DEFAULT NULL,
`bcch_consent_revoke` varchar(45) DEFAULT NULL,
`bcch_assent_status` varchar(45) DEFAULT NULL,
`bcch_date_assent` date DEFAULT NULL,
`bcch_assent_reason_decline` varchar(45) DEFAULT NULL,
`bcch_formal_at_age_majority` varchar(45) DEFAULT NULL,
`bcch_assent_adolescent_capacity` varchar(45) DEFAULT NULL,
`consent_master_id` int(11) NOT NULL,
`deleted` tinyint(3) DEFAULT '0',
PRIMARY KEY (`id`)
);

CREATE TABLE `cd_bcch_consents_revs` (
`id` int(11) NOT NULL,
`bcch_verbal_consent` varchar(45) DEFAULT NULL,
`bcch_date_verbal_consent` date DEFAULT NULL,
`bcch_person_verbal_consent` varchar(45) DEFAULT NULL,
`bcch_formal_consent` varchar(45) DEFAULT NULL,
`bcch_formal_consent_type` varchar(45) DEFAULT NULL,
`bcch_date_formal_consent` date DEFAULT NULL,
`bcch_person_formal_consent` varchar(45) DEFAULT NULL,
`bcch_consent_all_donation` varchar(45) DEFAULT NULL,
`bcch_consent_tissue` varchar(45) DEFAULT NULL,
`bcch_consent_bone_marrow` varchar(45) DEFAULT NULL,
`bcch_consent_blood` varchar(45) DEFAULT NULL,
`bcch_consent_extra_blood` varchar(45) DEFAULT NULL,
`bcch_consent_csf` varchar(45) DEFAULT NULL,
`bcch_consent_leukopheresis` varchar(45) DEFAULT NULL,
`bcch_consent_genetic_material` varchar(45) DEFAULT NULL,
`bcch_consent_stem_cells` varchar(45) DEFAULT NULL,
`bcch_consent_buccal_swabs` varchar(45) DEFAULT NULL,
`bcch_consent_saliva` varchar(45) DEFAULT NULL,
`bcch_consent_urine` varchar(45) DEFAULT NULL,
`bcch_consent_stool` varchar(45) DEFAULT NULL,
`bcch_consent_prev_materials` varchar(45) DEFAULT NULL,
`bcch_consent_other_materials` varchar(45) DEFAULT NULL,
`bcch_other_materials_description` varchar(45) DEFAULT NULL,
`bcch_date_withdrawal_revoke` date DEFAULT NULL,
`bcch_consent_withdrawal` varchar(45) DEFAULT NULL,
`bcch_consent_revoke` varchar(45) DEFAULT NULL,
`bcch_assent_status` varchar(45) DEFAULT NULL,
`bcch_date_assent` date DEFAULT NULL,
`bcch_assent_reason_decline` varchar(45) DEFAULT NULL,
`bcch_formal_at_age_majority` varchar(45) DEFAULT NULL,
`bcch_assent_adolescent_capacity` varchar(45) DEFAULT NULL,
`consent_master_id` int(11) NOT NULL,
`version_id` int(11) NOT NULL AUTO_INCREMENT,
`version_created` datetime NOT NULL,
PRIMARY KEY (`version_id`)
);

-- This allows the new form to show up at the add menu
INSERT INTO consent_controls (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES (NULL, 'BCCH Consent', '1', 'cd_bcch_consents', 'cd_bcch_consents', '2', 'BCCH Consent');

-- Register the table at structures
INSERT INTO structures (`id`, `alias`, `description`) VALUES (NULL, 'cd_bcch_consents', NULL);

-- Create a domain for the yes, no, na fields
INSERT INTO structure_value_domains (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'bcch_consent_yesnona', 'open', '', NULL);

INSERT INTO structure_value_domains (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'bcch_consent_status', 'open', '', NULL);
INSERT INTO structure_value_domains (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'bcch_assent_status', 'open', '', NULL);
INSERT INTO structure_value_domains (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'bcch_assent_reason_decline', 'open', '', NULL);


-- Create the yes, no, na values


INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("consented", "bcch_consented");

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_consent_status"), (SELECT id FROM structure_permissible_values WHERE value="consented" AND language_alias="bcch_consented"), "1", "1");# 1 row affected.

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("declined", "bcch_declined");

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_consent_status"), (SELECT id FROM structure_permissible_values WHERE value="declined" AND language_alias="bcch_declined"), "2", "1");# 1 row affected.

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("withdrawn", "bcch_withdrawn");

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_consent_status"), (SELECT id FROM structure_permissible_values WHERE value="withdrawn" AND language_alias="bcch_withdrawn"), "3", "1");



INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("assented", "bcch_assented");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_assent_status"), (SELECT id FROM structure_permissible_values WHERE value="assented" AND language_alias="bcch_assented"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("declined", "bcch_declined");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_assent_status"), (SELECT id FROM structure_permissible_values WHERE value="declined" AND language_alias="bcch_declined"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("not assented", "bcch_not_assented");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_assent_status"), (SELECT id FROM structure_permissible_values WHERE value="not assented" AND language_alias="bcch_not_assented"), "3", "1");


INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("age", "bcch_age");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_assent_reason_decline"), (SELECT id FROM structure_permissible_values WHERE value="age" AND language_alias="bcch_age"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("cognitive", "bcch_cognitive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_assent_reason_decline"), (SELECT id FROM structure_permissible_values WHERE value="cognitive" AND language_alias="bcch_cognitive"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("other", "bcch_other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bcch_assent_reason_decline"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="bcch_other"), "3", "1");

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("yes", "bcch_yes");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("no", "bcch_no");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("na", "bcch_na");

-- Linking the domain with the actual values
INSERT INTO structure_value_domains_permissible_values (`id`,`structure_value_domain_id`,`structure_permissible_value_id`,`display_order`,`flag_active`,`use_as_input`)
VALUES (NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), (SELECT id FROM `structure_permissible_values` WHERE `language_alias` LIKE 'bcch_yes'), 1, 1, 1);
INSERT INTO structure_value_domains_permissible_values (`id`,`structure_value_domain_id`,`structure_permissible_value_id`,`display_order`,`flag_active`,`use_as_input`)
VALUES (NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), (SELECT id FROM `structure_permissible_values` WHERE `language_alias` LIKE 'bcch_no'), 2, 1, 1);
INSERT INTO structure_value_domains_permissible_values (`id`,`structure_value_domain_id`,`structure_permissible_value_id`,`display_order`,`flag_active`,`use_as_input`)
VALUES (NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), (SELECT id FROM `structure_permissible_values` WHERE `language_alias` LIKE 'bcch_na'), 3, 1, 1);

-- Now create the dropdown menu on the UI
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_all_donation', 'bcch consent all donation', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_tissue', 'bcch consent tissue', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_bone_marrow', 'bcch consent bone marrow', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_blood', 'bcch consent blood', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_extra_blood', 'bcch consent extra blood', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_csf', 'bcch consent csf', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_leukopheresis', 'bcch consent leukopheresis', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_genetic_material', 'bcch consent genetic material', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_stem_cells', 'bcch consent stem cells', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_buccal_swabs', 'bcch consent buccal', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_saliva', 'bcch consent saliva', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_urine', 'bcch consent urine', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_stool', 'bcch consent stool', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_prev_materials', 'bcch consent previous materials', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

-- Enable the menu on structure format, what function should this field access
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_all_donation'), '1', '11', 'bcch consent details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_tissue'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE `tablename`='cd_bcch_consents' AND `field`='bcch_consent_bone_marrow'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_blood'), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_extra_blood'), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_csf'), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_leukopheresis'), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_genetic_material'), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_stem_cells'), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_buccal_swabs'), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_saliva'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_urine'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_stool'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM `structures` WHERE `alias`='cd_bcch_consents'), (SELECT id FROM `structure_fields` WHERE  `tablename`='cd_bcch_consents' AND `field`='bcch_consent_prev_materials'), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');


-- Verbal Consent Status
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_verbal_consent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bcch_consent_status') , '0', '', '', '', 'bcch verbal consent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_verbal_consent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bcch_consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcch verbal consent' AND `language_tag`=''), '1', '1', 'bcch verbal consent', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Verbal Consent Date
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_date_verbal_consent', 'date',  NULL , '0', '', '', '', 'bcch date verbal consent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_date_verbal_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcch date verbal consent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Formal Consent Date and Assent Date
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_date_formal_consent', 'date',  NULL , '0', '', '', '', 'bcch date formal consent', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_date_assent', 'date',  NULL , '0', '', '', '', 'bcch date assent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_date_formal_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcch date formal consent' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_date_assent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcch date assent' AND `language_tag`=''), '2', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Assent Status and Asset Reasons

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_assent_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bcch_assent_status') , '0', '', '', '', 'bcch assent status', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_assent_reason_decline', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bcch_assent_reason_decline') , '0', '', '', '', 'bcch assent reason decline', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_assent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bcch_assent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcch assent status' AND `language_tag`=''), '2', '5', 'bcch assent', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_assent_reason_decline' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bcch_assent_reason_decline')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcch assent reason decline' AND `language_tag`=''), '2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');


-- Linking translator used field in the master form to BCCH form

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='translator_indicator' AND type='yes_no'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', 'n', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='translator_signature' AND type='yes_no'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Creating Age Majority --
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_formal_at_age_majority', 'bcch formal at age majority', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_formal_at_age_majority' AND type='yes_no'), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_assent_adolescent_capacity', 'bcch assent adolescent capacity', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_assent_adolescent_capacity' AND type='yes_no'), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Date of Withdrawal or Revoke

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_date_withdrawal_revoke', 'bcch date withdrawal revoke', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_date_withdrawal_revoke' AND type='date'), '2', '1', 'bcch withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');


-- Revoke of Consent

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_revoke', 'bcch consent revoke', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_consent_revoke' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona')), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');


-- Withdrawal of Consent

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_withdrawal', 'bcch consent withdrawal', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_consent_withdrawal' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona')), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Moving the Reason Denied/Withdrawn to under the Withdrawal Section
UPDATE structure_formats SET display_column='2', display_order='4' WHERE `structure_id`=(SELECT id FROM structures WHERE alias='consent_masters') AND `structure_field_id`=(SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='reason_denied' AND type='textarea');

-- Moving Status Date and Date Consent Signed to under Formal Consent

UPDATE structure_formats SET display_order='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='status_date' AND type='date');
UPDATE structure_formats SET display_order='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='consent_signed_date' AND type='date');


-- Adding Formal Consent and Formal Consent Type

INSERT INTO structure_value_domains (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'bcch_formal_consent_type', '', '', '');

INSERT INTO structure_permissible_values(`id`, `value`, `language_alias`) VALUES (NULL, 'participant', 'bcch participant');
INSERT INTO structure_permissible_values(`id`, `value`, `language_alias`) VALUES (NULL, 'parental', 'bcch parental');

INSERT INTO structure_value_domains_permissible_values(`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES (NULL, (SELECT id FROM structure_value_domains WHERE domain_name='bcch_formal_consent_type'), (SELECT id FROM structure_permissible_values WHERE value='participant' AND language_alias='bcch participant'), '1', '1', '1');
INSERT INTO structure_value_domains_permissible_values(`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES (NULL, (SELECT id FROM structure_value_domains WHERE domain_name='bcch_formal_consent_type'), (SELECT id FROM structure_permissible_values WHERE value='parental' AND language_alias='bcch parental'), '1', '1', '1');

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_formal_consent', 'bcch formal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_status'), '', 'open', 'open', 'open', '0');
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_formal_consent_type', '', 'bcch formal consent', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_formal_consent_type'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_formal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_status')), '1', '4', 'bcch formal consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_formal_consent_type' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_formal_consent_type')), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Add Person Consenting (Verbal and Formal)

#INSERT INTO structure_value_domains(`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_person_consenting', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''bcch person consenting'')');

#INSERT INTO structure_permissible_values_custom_controls(`id`, `name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`) VALUES (NULL, 'bcch person consenting', '1', '20', 'clinical - consent', '8', '8');


INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_person_verbal_consent', 'bcch person verbal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting'), '', 'open', 'open', 'open', '0');
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_person_formal_consent', 'bcch person formal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_person_verbal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting')), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_person_formal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting')), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Consent to other

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_other_materials', 'bcch consent other materials', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona'), '', 'open', 'open', 'open', '0');
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_other_materials_description', '', 'bcch other materials description', 'textarea', 'cols=20,rows=1', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_consent_other_materials' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='bcch_consent_yesnona')), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES (NULL, (SELECT id FROM structures WHERE alias='cd_bcch_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcch_consents' AND field='bcch_other_materials_description' AND type='textarea'), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


-- Add the language translation
INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('BCCH Consent', '', 'BCCH Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch_yes', '', 'Yes', 'Oui'), ('bcch_no', '', 'No', 'Non'), ('bcch_na', '', 'NA', ''), ('bcch consent tissue', '', 'Consent to Tissue Donation', ''), ('bcch formal consent', '', 'Formal consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch_consented', '', 'Consented', ''), ('bcch_declined', '', 'Declined',''), ('bcch_withdrawn', '', 'Withdrawn','');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch date verbal consent', '', 'Date of Verbal Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch date formal consent', '', 'Date of Formal Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch date assent', '', 'Date of Assent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch assent', '', 'Assent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch verbal consent', '', 'Verbal Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent details', '', 'Consent Details', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent all donation', '', 'Consent to Donation of All Sample Types', ''), ('bcch consent bone marrow', '', 'Consent to Donation of Bone Marrow', ''), ('bcch consent blood', '', 'Consent to Donation of Blood', ''), ('bcch consent extra blood', '', 'Consent to Collection of an Additional Blood Draw', ''), ('bcch consent csf', '', 'Use of Left Over CSF', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent leukopheresis', '', 'Use of Left Over Leukapheresis', ''), ('bcch consent genetic material', '', 'Use of Left Over Genetic Materials', ''), ('bcch consent stem cells', '', 'Use of Left Over Stem cells', ''), ('bcch consent buccal', '', 'Use of Buccal Swabs', ''), ('bcch consent saliva', '', 'Use of Saliva', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent urine', '', 'Use of Urine',''), ('bcch consent stool', '', 'Use of Stool', ''), ('bcch consent previous materials', '', 'Use of Samples Previously Collected', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch assent status', '', 'Assent', ''), ('bcch assent reason decline', '', 'Reason for Lack of Assent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch_assented', '', 'Assented', ''), ('bcch_not_assented', '', 'Not Assented', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch_age', '', 'Age', ''), ('bcch_cognitive', '', 'Cognitive', ''), ('bcch_other', '', 'Other', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch withdrawal', '', 'Withdrawal', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch date withdrawal revoke', '', 'Date of Withdrawal/Revoke', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch formal at age majority', '', 'Formal Consent - Age Majority', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch assent adolescent capacity', '', 'Adolescent Capacity to Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent revoke', '', 'Revoke of Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent withdrawal', '', 'Withdrawal of Consent', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch participant', '', 'Participant', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch parental', '', 'Parental', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch person verbal consent', '', 'Person Consenting (Verbal)', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch person formal consent', '', 'Person Consenting (Formal)', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch consent other materials', '', 'Consent to Other Materials', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch other materials description', '', 'Other Materials:', '');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES ('bcch formal consent type', '', 'Type', '');



--  =========================================================================
--	Eventum ID: #3163 - Study Title Validation
--	=========================================================================

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE tablename = 'study_summaries' AND field = 'title'), 'custom,/^[A-Za-z][A-Za-z][A-Za-z][A-Za-z][A-Za-z]$/', 'ccbr study title must be 5 characters');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr study title must be 5 characters', "Study title must be 5 characters long", '');

--  =========================================================================
--	Eventum ID: #3161 - Tissue source - Add values
--	=========================================================================
UPDATE structure_value_domains SET `override`="", `source`="" WHERE domain_name="tissue_source_list";
INSERT INTO structure_permissible_values (value, language_alias) VALUES("placenta", "placenta");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list"), (SELECT id FROM structure_permissible_values WHERE value="placenta" AND language_alias="placenta"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "2", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('placenta', "Placenta", '');

--  =========================================================================
--	Eventum ID: #3167 - Migration - CSF conversion
--  Tables to update: sample_controls, sample
--	=========================================================================

-- Disable CCBR sample type
UPDATE parent_to_derivative_sample_controls SET flag_active=0
WHERE `derivative_sample_control_id` = (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr cerebrospinal fluid');

-- Move all data from CCBR cerebrospinal_fluid sample detail table to ATiM csf detail table
INSERT INTO `sd_spe_csfs` (`sample_master_id`, `collected_volume`, `collected_volume_unit`)
SELECT `sample_master_id`, `collected_volume`, `collected_volume_unit` FROM `sd_spe_ccbr_cerebrospinal_fluid`;

INSERT INTO `sd_spe_csfs_revs` (`sample_master_id`, `collected_volume`, `collected_volume_unit`, `version_id`, `version_created`)
SELECT `sample_master_id`, `collected_volume`, `collected_volume_unit` FROM `sd_spe_ccbr_cerebrospinal_fluid_revs`;

-- Update sample_masters
UPDATE `sample_masters`
SET `sample_control_id` = (SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf'), `initial_specimen_sample_type` = ('csf')
WHERE `sample_control_id` = (SELECT `id` FROM sample_controls WHERE `sample_type` = 'ccbr cerebrospinal fluid');

-- Remove from sample_controls and parent_to_derivative_sample_controls
DELETE FROM parent_to_derivative_sample_controls
WHERE `derivative_sample_control_id` = (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr cerebrospinal fluid');

DELETE FROM `sample_controls`
WHERE `sample_type` = 'ccbr cerebrospinal fluid';

-- DROP TABLE
DROP TABLE `bc_children_atim`.`sd_spe_ccbr_cerebrospinal_fluid`;
DROP TABLE `bc_children_atim`.`sd_spe_ccbr_cerebrospinal_fluid_revs`;

-- Update aliquot masters
-- Wait for Tamsin's reply. Leave as-is for ml

--  =========================================================================
--	Eventum ID: #XXXX - New sample type (Swab)
--	=========================================================================
CREATE TABLE `sd_spe_swabs` (
  `sample_master_id` int(11) NOT NULL,
  `ccbr_swab_location` varchar(255) DEFAULT NULL,
  KEY `FK_sd_spe_swabss_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_swabs_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_swabs_revs` (
  `sample_master_id` int(11) NOT NULL,
  `ccbr_swab_location` varchar(255) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_swabs');

-- Add swab location field to detail form
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('ccbr swab', 'specimen', 'sd_spe_swabs,specimens', 'sd_spe_swabs', '0', 'swab');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr swab', "Swab", '');

-- Value domain for swab location
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ccbr_swab_location", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("buccal", "buccal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_swab_location"), (SELECT id FROM structure_permissible_values WHERE value="buccal" AND language_alias="buccal"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cervix", "cervix");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_swab_location"), (SELECT id FROM structure_permissible_values WHERE value="cervix" AND language_alias="cervix"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("vagina", "vagina");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_swab_location"), (SELECT id FROM structure_permissible_values WHERE value="vagina" AND language_alias="vagina"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('buccal', "Buccal", ''),
('cervix', "Cervix", ''),
('vagina', "Vagina", '');

-- Add swab location to detail form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_swabs', 'ccbr_swab_location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_swab_location') , '0', '', '', '', 'ccbr swab location', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='sd_spe_swabs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_swabs' AND `field`='ccbr_swab_location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_swab_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr swab location' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr swab location', "Swab Location", '');

-- Enable new sample type
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr swab'), '1');

-- Add aliquot
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
 ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr swab'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'Specimen tube', '0', 'swab|tube');


--  =========================================================================
--	Eventum ID: #XXXX - New sample type (Cord Blood)
--	========================================================================



--  =========================================================================
--	Eventum ID: #3155 - Collection - Add new needs default participant ID
--	=========================================================================

-- Set Collection Property to 'Independant Collection'
-- UPDATE structure_formats SET `flag_override_default`='1', `default`='independent collection', `flag_add_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
