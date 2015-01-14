-- BCCH Customization Script
-- Version: v0.1
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.1", '');

--  =========================================================================
--	Eventum ID: #3108 - Core Upgrade - v2.6.3
--	=========================================================================	

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

-- Category for custom lookup domains
UPDATE `structure_permissible_values_custom_controls` SET `category`='clinical - consent' WHERE `name`='ccbr person consenting';
UPDATE `structure_permissible_values_custom_controls` SET `category`='clinical - consent' WHERE `name`='ccbr treating physician';
UPDATE `structure_permissible_values_custom_controls` SET `category`='inventory' WHERE `name`='ccbr sample pickup by';

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
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study summary id' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

-- Add to view
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study summary id' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

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

--  Add new identifiers for all existing participants
DROP TABLE IF EXISTS `temp_participant_ids`;
CREATE TABLE `temp_participant_ids` (
	`id` MEDIUMINT NOT NULL AUTO_INCREMENT,
	`new_id` CHAR(5) DEFAULT NULL,
	PRIMARY KEY (`id`)
) ;

DROP PROCEDURE IF EXISTS `create_new_ids`;

DELIMITER |
CREATE PROCEDURE `create_new_ids`()
BEGIN
	DECLARE num_participants INT;
	DECLARE generated_id CHAR(5);
	
	SET generated_id = 'C0000';
	SELECT COUNT(*) INTO num_participants FROM `participants`;
	
	WHILE num_participants > 0 DO
		INSERT INTO `temp_participant_ids` (`new_id`) VALUES (`generated_id`);
		SET num_participants = num_participants - 1;
	END WHILE;
END|
DELIMITER ;

CALL create_new_ids();

DROP PROCEDURE IF EXISTS `create_new_ids`;

/*

INSERT INTO `temp_participant_ids` (`new_id`
SELECT `id` AS CONVERT (CHAR(5), CHAR(ASCII('C') + (`id`),
FROM `participants`;

create table T (
    CoreValue int not null,
    DisplayValue as CONVERT(varchar(10),(CoreValue / 26)+1) + CHAR(ASCII('A') + (CoreValue-1) % 26)
)
go
insert into T (CoreValue)
select ROW_NUMBER() OVER (ORDER BY so1.object_id)
from sys.objects so1,sys.objects so2
go
select * from T

'ABC' + RIGHT('000' + LTRIM(IdField),3)
select top 1 
    case when SequenceChar = 'Z' then
        cast((SequenceNum + 1) as varchar) + 'A'
    else
        cast(SequenceNum as varchar) + char(ascii(SequenceChar) + 1)
    end as NextSequence
from (
    select Value, 
        cast(substring(Value, 1, CharIndex - 1) as int) as SequenceNum, 
        substring(Value, CharIndex, len(Value)) as SequenceChar
    from (
        select Value, patindex('%[A-Z]%', Value) as CharIndex
        from MyTable
    ) a
) b
order by SequenceNum desc, SequenceChar desc
*/

-- Fix validations for new format using C00001, required and unique
UPDATE `structure_validations` SET `rule`='notEmpty' WHERE `language_message`='error_participant identifier required';
UPDATE `structure_validations` SET `rule`='isUnique' WHERE `language_message`='error_participant identifier must be unique';

UPDATE `structure_validations` SET `rule` = '/^[C][0-9][0-9][0-9][0-9][0-9]$'
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
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_addgrid_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

