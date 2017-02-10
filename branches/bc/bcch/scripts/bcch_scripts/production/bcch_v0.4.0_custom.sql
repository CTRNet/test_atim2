-- BCCH Customization Script
-- Version 0.4
-- ATiM Version: 2.6.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.4", '');
	
--  =========================================================================
--	Eventum ID: #XXXX - Consent status under formal consent is not mandatory
--  BB-55
--	=========================================================================

-- Need to make it mandatory (cannot be empty)

INSERT INTO structure_validations (`structure_field_id`, `rule`, `language_message`) VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status'), 'notEmpty', 'Consent status field is required.');

DELETE FROM structure_validations
WHERE `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status')
AND `rule`= 'custom,/[A-Za-z]+/';

--  =========================================================================
--	Eventum ID: #XXXX - Sorting by storage system code is not ordered
--  BB-56
--	=========================================================================

ALTER TABLE view_storage_masters MODIFY `code` INT(11);

--  =========================================================================
--	Eventum ID: #XXXX 
--  BB-XX
--	=========================================================================

ALTER TABLE `cd_bcch_consents` ENGINE = InnoDB;

ALTER TABLE `cd_bcch_consents_revs` ENGINE = InnoDB;

--  =========================================================================
--	Eventum ID: #XXXX - Data fields for consent to prev materials and other materials are reversed for the BCWH consent forms
--  BB-88
--	=========================================================================

-- Update the descriptions
UPDATE structure_fields
SET `language_label`='bcwh consent previous materials'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_prev_materials';

UPDATE structure_fields
SET `language_label`='bcwh consent other materials'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_other_materials';

UPDATE structure_fields
SET `language_label`='bcwh maternal consent previous materials'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_prev_materials';

UPDATE structure_fields
SET `language_label`='bcwh maternal consent other materials'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_other_materials';


-- Update the positions
UPDATE structure_formats
SET `display_order`=23
WHERE `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_prev_materials')
AND `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents');

UPDATE structure_formats
SET `display_order`=24
WHERE `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_other_materials')
AND `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents');

UPDATE structure_formats
SET `display_order`=23
WHERE `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_prev_materials')
AND `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents');

UPDATE structure_formats
SET `display_order`=24
WHERE `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_other_materials')
AND `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents');


-- Swap the Data
UPDATE cd_bcwh_consents
SET bcwh_consent_prev_materials=(@temp:=bcwh_consent_prev_materials), bcwh_consent_prev_materials=bcwh_consent_other_materials, bcwh_consent_other_materials=@temp;

UPDATE cd_bcwh_consents_revs
SET bcwh_consent_prev_materials=(@temp:=bcwh_consent_prev_materials), bcwh_consent_prev_materials=bcwh_consent_other_materials, bcwh_consent_other_materials=@temp;

UPDATE cd_bcwh_maternal_consents
SET bcwh_maternal_consent_prev_materials=(@temp:=bcwh_maternal_consent_prev_materials), bcwh_maternal_consent_prev_materials=bcwh_maternal_consent_other_materials, bcwh_maternal_consent_other_materials=@temp;

UPDATE cd_bcwh_maternal_consents_revs
SET bcwh_maternal_consent_prev_materials=(@temp:=bcwh_maternal_consent_prev_materials), bcwh_maternal_consent_prev_materials=bcwh_maternal_consent_other_materials, bcwh_maternal_consent_other_materials=@temp;

--  =========================================================================
--	Eventum ID: #XXXX - Some fields of the consent forms are not searchable in the data browser
--  BB-89
--	=========================================================================

UPDATE structure_formats
SET `flag_search`=1 
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcch_consents');

UPDATE structure_formats
SET `flag_search`=1 
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents');

UPDATE structure_formats
SET `flag_search`=1 
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents');

-- Disable type from being searchable
UPDATE structure_formats
SET `flag_search`=0 
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='consent_masters')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id');


-- Need to fix a bug with formal consent type
UPDATE structure_fields
SET `language_tag`='bcch formal consent type'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field`='bcch_formal_consent_type';

UPDATE structure_fields
SET `language_tag`='bcwh formal consent type'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_formal_consent_type';

UPDATE structure_fields
SET `language_tag`='bcwh maternal formal consent type'
WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_formal_consent_type';

REPLACE into i18n (`id`, `en`) VALUES
('bcch formal consent type', 'Type'),
('bcwh formal consent type', 'Type'),
('bcwh maternal formal consent type', 'Type');


--  =========================================================================
--	Eventum ID: #XXXX - Clinical Annotation: Searching for participants with blank fields does not return all participants
--  BB-90
--	=========================================================================

-- Change the pagination amount to 50

UPDATE configs
SET `define_pagination_amount`=50;

--  =========================================================================
--	Eventum ID: #XXXX - Change "Study Type" in Study Summary from dropdown to multiple check boxes
--  BB-92
--	=========================================================================

-- Add the new columns for storing the yes and no checkboxes
ALTER TABLE study_summaries
	ADD COLUMN `study_type_clinical_trial` VARCHAR(50) DEFAULT NULL AFTER `study_type`,
	ADD COLUMN `study_type_acad_research` VARCHAR(50) DEFAULT NULL AFTER `study_type_clinical_trial`,
	ADD COLUMN `study_type_biobank` VARCHAR(50) DEFAULT NULL AFTER `study_type_acad_research`,
	ADD COLUMN `study_type_other` VARCHAR(50) DEFAULT NULL AFTER `study_type_biobank`;

ALTER TABLE study_summaries_revs
	ADD COLUMN `study_type_clinical_trial` VARCHAR(50) DEFAULT NULL AFTER `study_type`,
	ADD COLUMN `study_type_acad_research` VARCHAR(50) DEFAULT NULL AFTER `study_type_clinical_trial`,
	ADD COLUMN `study_type_biobank` VARCHAR(50) DEFAULT NULL AFTER `study_type_acad_research`,
	ADD COLUMN `study_type_other` VARCHAR(50) DEFAULT NULL AFTER `study_type_biobank`;

-- Migrate the existing data in the study_type field to the new fields
UPDATE study_summaries 
SET `study_type_clinical_trial`='y', `study_type_acad_research`='n', `study_type_biobank`='n', `study_type_other`='n'
WHERE `study_type`='clinical trial';

UPDATE study_summaries 
SET `study_type_clinical_trial`='n', `study_type_acad_research`='y', `study_type_biobank`='n', `study_type_other`='n'
WHERE `study_type`='academic research';

UPDATE study_summaries 
SET `study_type_clinical_trial`='n', `study_type_acad_research`='n', `study_type_biobank`='y', `study_type_other`='n'
WHERE `study_type`='biobank';

UPDATE study_summaries 
SET `study_type_clinical_trial`='n', `study_type_acad_research`='n', `study_type_biobank`='n', `study_type_other`='y'
WHERE `study_type`='other';

UPDATE study_summaries_revs 
SET `study_type_clinical_trial`='y', `study_type_acad_research`='n', `study_type_biobank`='n', `study_type_other`='n'
WHERE `study_type`='clinical trial';

UPDATE study_summaries_revs 
SET `study_type_clinical_trial`='n', `study_type_acad_research`='y', `study_type_biobank`='n', `study_type_other`='n'
WHERE `study_type`='academic research';

UPDATE study_summaries_revs 
SET `study_type_clinical_trial`='n', `study_type_acad_research`='n', `study_type_biobank`='y', `study_type_other`='n'
WHERE `study_type`='biobank';

UPDATE study_summaries_revs 
SET `study_type_clinical_trial`='n', `study_type_acad_research`='n', `study_type_biobank`='n', `study_type_other`='y'
WHERE `study_type`='other';

-- Drop the old field after data migration
ALTER TABLE study_summaries
	DROP COLUMN `study_type`;

ALTER TABLE study_summaries_revs
	DROP COLUMN `study_type`;

DELETE FROM structure_formats
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries') 
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type' AND `language_label`='study_type' AND `type`='select');

DELETE FROM structure_fields
WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type' AND `language_label`='study_type' AND `type`='select';

-- Register the new fields to the structure and UI
INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Study', 'StudySummary', 'study_summaries', 'study_type_clinical_trial', 'study type clinical trial', '', 'yes_no', NULL, 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'study_type_acad_research', 'study type academic research', '', 'yes_no', NULL, 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'study_type_biobank', 'study type biobank', '', 'yes_no', NULL, 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'study_type_other', 'study type other', '', 'yes_no', NULL, 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, 
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, 
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type_clinical_trial' AND `language_label`='study type clinical trial' AND `type`='yes_no'),
 1, 20, 'study types', 0, 0, 0,
 0, 0, 1, 'n',
 1, 0, 1, 0, 0, 0, 0, 0,
 1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type_acad_research' AND `language_label`='study type academic research' AND `type`='yes_no'),
 1, 21, '', 0, 0, 0,
 0, 0, 1, 'n',
 1, 0, 1, 0, 0, 0, 0, 0,
 1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type_biobank' AND `language_label`='study type biobank' AND `type`='yes_no'),
 1, 22, '', 0, 0, 0,
 0, 0, 1, 'n',
 1, 0, 1, 0, 0, 0, 0, 0,
 1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type_other' AND `language_label`='study type other' AND `type`='yes_no'),
 1, 23, '', 0, 0, 0,
 0, 0, 1, 'n',
 1, 0, 1, 0, 0, 0, 0, 0,
 1, 0, 0, 1, 1, 0, 0);
 
 UPDATE structure_formats
 SET `flag_override_default`=1, `default`='n'
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_consent' AND `type`='yes_no');
 
 UPDATE structure_formats
 SET `flag_override_default`=1, `default`='n'
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_collection' AND `type`='yes_no');
 
 UPDATE structure_formats
 SET `flag_override_default`=1, `default`='n'
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_processing' AND `type`='yes_no');
 
 UPDATE structure_formats
 SET `flag_override_default`=1, `default`='n'
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_simple_data_collection' AND `type`='yes_no');
 
  UPDATE structure_formats
 SET `flag_override_default`=1, `default`='n'
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_clinical_data_collection' AND `type`='yes_no');
 
 UPDATE structure_formats
 SET `flag_override_default`=1, `default`='n'
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_storage' AND `type`='yes_no');
 
 -- Move the position of the if other text field to the correct REPLACE
 UPDATE structure_formats
 SET `display_order`=24
 WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studysummaries')
 AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type_other_desc' AND `language_tag`='study_type_other_desc' AND `type`='textarea');
 
 
REPLACE INTO i18n (`id`, `en`) VALUES 
('study types', 'Study Types'),
('study type clinical trial', 'Clinical Trial'),
('study type academic research', 'Academic Research'),
('study type biobank', 'BioBank'),
('study type other', 'Others');

--  =========================================================================
--	Eventum ID: #XXXX - Add two "permission to contact" option in the contact session
--  BB-93
--	=========================================================================

ALTER TABLE participant_contacts
	ADD COLUMN `contact_permission_research` VARCHAR(50) DEFAULT NULL AFTER `id`,
	ADD COLUMN `contact_permission_admin` VARCHAR(50) DEFAULT NULL AFTER `contact_permission_research`;

ALTER TABLE participant_contacts_revs
	ADD COLUMN `contact_permission_research` VARCHAR(50) DEFAULT NULL AFTER `id`,
	ADD COLUMN `contact_permission_admin` VARCHAR(50) DEFAULT NULL AFTER `contact_permission_research`;
	
INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'contact_permission_research', 'contact permission for research', '', 'yes_no', NULL, 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'contact_permission_admin', 'contact permission for admin', '', 'yes_no', NULL, 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, 
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, 
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='participantcontacts'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_permission_research' AND `type`='yes_no'),
1, 6, '', 0, 0, 0, 
0, 0, 1, 'n', 
1, 0, 1, 0, 0, 0, 0, 0, 
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='participantcontacts'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_permission_admin' AND `type`='yes_no'),
1, 7, '', 0, 0, 0, 
0, 0, 1, 'n', 
1, 0, 1, 0, 0, 0, 0, 0, 
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES 
('contact permission for research', 'Permission to Contact for Research'),
('contact permission for admin', 'Permission to Contact for Administration');

--  =========================================================================
--	Eventum ID: #XXXX - Double the size of the "Selection Label" field in the UI
--  BB-94
--	=========================================================================

UPDATE structure_fields
SET `setting`='size=40,url=/StorageLayout/storage_masters/autocompleteLabel'
WHERE `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label' AND `type`='autocomplete';

UPDATE structure_fields
SET `setting`='size=40,url=/StorageLayout/storage_masters/autocompleteLabel/'
WHERE `plugin`='StorageLayout' AND `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='selection_label' AND `type`='input';

UPDATE structure_fields
SET `setting`='size=40'
WHERE `plugin`='StorageLayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `type`='input';

UPDATE structure_fields
SET `setting`='size=40'
WHERE `plugin`='StorageLayout' AND `model`='ViewAliquot' AND `field`='selection_label' AND `type`='input';

--  =========================================================================
--	Eventum ID: #XXXX - Change the 24x1 rack to 6x4 configuration
--  BB-95
--	=========================================================================

INSERT INTO storage_controls
(`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, 
`coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, 
`reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, 
`is_tma_block`, `flag_active`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
('ccbr rack24', 'position', 'integer', 24, 
NULL, NULL, NULL, 4, 6, 
0, 0, 0, 0, 
0, 1, 'std_racks', 'custom#storage types#ccbr box24', 1);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Storage Types' AND `flag_active`=1 AND `values_max_length`=30 AND `category`='storages'),
 'ccbr rack24', 'Rack 24 (6x4)', '', 0, 1, NOW(), 1, NOW(), 1, 0);
 
INSERT INTO structure_permissible_values_customs_revs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `modified_by`, `version_created`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Storage Types' AND `flag_active`=1 AND `values_max_length`=30 AND `category`='storages'),
 'ccbr rack24', 'Rack 24 (6x4)', '', 0, 1, 1, NOW());

-- Convert the current rack24 from 24x1 to 6x4
UPDATE storage_masters
SET `storage_control_id`=(SELECT `id` FROM storage_controls WHERE `storage_type`='ccbr rack24' AND `coord_x_title`='position' AND `coord_x_type`='integer' AND `coord_x_size`=24 AND `coord_y_title` IS NULL AND `display_x_size`=4 AND `display_y_size`=6 AND `detail_tablename`='std_racks')
WHERE `storage_control_id`=(SELECT `id` FROM storage_controls WHERE `storage_type`='rack24' AND `coord_x_title`='position' AND `coord_x_type`='integer' AND `coord_x_size`=24 AND `coord_y_title` IS NULL AND `display_x_size`=1 AND `display_y_size`=24 AND `detail_tablename`='std_racks');


UPDATE storage_masters_revs
SET `storage_control_id`=(SELECT `id` FROM storage_controls WHERE `storage_type`='ccbr rack24' AND `coord_x_title`='position' AND `coord_x_type`='integer' AND `coord_x_size`=24 AND `coord_y_title` IS NULL AND `display_x_size`=4 AND `display_y_size`=6 AND `detail_tablename`='std_racks')
WHERE `storage_control_id`=(SELECT `id` FROM storage_controls WHERE `storage_type`='rack24' AND `coord_x_title`='position' AND `coord_x_type`='integer' AND `coord_x_size`=24 AND `coord_y_title` IS NULL AND `display_x_size`=1 AND `display_y_size`=24 AND `detail_tablename`='std_racks');


UPDATE view_storage_masters
SET `storage_control_id`=(SELECT `id` FROM storage_controls WHERE `storage_type`='ccbr rack24' AND `coord_x_title`='position' AND `coord_x_type`='integer' AND `coord_x_size`=24 AND `coord_y_title` IS NULL AND `display_x_size`=4 AND `display_y_size`=6 AND `detail_tablename`='std_racks')
WHERE `storage_control_id`=(SELECT `id` FROM storage_controls WHERE `storage_type`='rack24' AND `coord_x_title`='position' AND `coord_x_type`='integer' AND `coord_x_size`=24 AND `coord_y_title` IS NULL AND `display_x_size`=1 AND `display_y_size`=24 AND `detail_tablename`='std_racks');

--  =========================================================================
--	Eventum ID: #XXXX - Disable the shelf in storage
--  BB-102
--	=========================================================================

UPDATE storage_controls
SET `flag_active`= 0 
WHERE `storage_type`='shelf' 
AND `detail_tablename`='std_shelfs';

CREATE TABLE IF NOT EXISTS temp1 AS (SELECT * FROM storage_masters);

UPDATE storage_masters
SET `parent_id` = (SELECT `id` FROM temp1 WHERE `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type`='freezer' AND `detail_tablename`='std_freezers') AND `selection_label`='A1-108B-CC')
WHERE `parent_id`= (SELECT `id` FROM temp1 WHERE `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type`='shelf' AND `detail_tablename`='std_shelfs') AND `selection_label`='A1-108B-CC-Bottom');

DROP Table temp1;

CREATE TABLE IF NOT EXISTS temp2 AS (SELECT * FROM storage_masters_revs);

UPDATE storage_masters_revs
SET `parent_id` = (SELECT `id` FROM temp2 WHERE `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type`='freezer' AND `detail_tablename`='std_freezers') AND `selection_label`='A1-108B-CC')
WHERE `parent_id`= (SELECT `id` FROM temp2 WHERE `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type`='shelf' AND `detail_tablename`='std_shelfs') AND `selection_label`='A1-108B-CC-Bottom');

DROP Table temp2;

UPDATE storage_masters
SET `deleted`= 1 
WHERE `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type`='shelf' AND `detail_tablename`='std_shelfs')
AND `short_label` = 'Bottom'
AND `selection_label` = 'A1-108B-CC-Bottom';

-- Rename the selection label boxes 

UPDATE storage_masters
SET `selection_label` = 'A1-108B-CC-B1'
WHERE `selection_label` = 'A1-108B-CC-Bottom-B1'
AND `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type` = 'box81 1A-9I');

UPDATE storage_masters
SET `selection_label` = 'A1-108B-CC-2'
WHERE `selection_label` = 'A1-108B-CC-Bottom-2'
AND `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type` = 'box81 1A-9I');

UPDATE storage_masters_revs
SET `selection_label` = 'A1-108B-CC-B1'
WHERE `selection_label` = 'A1-108B-CC-Bottom-B1'
AND `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type` = 'box81 1A-9I');

UPDATE storage_masters_revs
SET `selection_label` = 'A1-108B-CC-2'
WHERE `selection_label` = 'A1-108B-CC-Bottom-2'
AND `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type` = 'box81 1A-9I');

UPDATE view_storage_masters
SET `selection_label` = 'A1-108B-CC-B1'
WHERE `selection_label` = 'A1-108B-CC-Bottom-B1'
AND `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type` = 'box81 1A-9I');

UPDATE storage_masters_revs
SET `selection_label` = 'A1-108B-CC-2'
WHERE `selection_label` = 'A1-108B-CC-Bottom-2'
AND `storage_control_id` = (SELECT `id` FROM storage_controls WHERE `storage_type` = 'box81 1A-9I');

