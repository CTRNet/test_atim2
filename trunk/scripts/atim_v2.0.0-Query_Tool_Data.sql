 
UPDATE `structures` 
SET `alias` = 'aliquot_search_for_datamart_demo_2'
WHERE `old_id` IN ('CAN-999-999-000-999-1055');

DELETE FROM `structure_formats` WHERE `structure_old_id` IN ('CAN-999-999-000-999-1055');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1100', 81, 'CAN-999-999-000-999-1055', 216, 'CAN-999-999-000-999-1100', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1102', 81, 'CAN-999-999-000-999-1055', 218, 'CAN-999-999-000-999-1102', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1103', 81, 'CAN-999-999-000-999-1055', 219, 'CAN-999-999-000-999-1103', 0, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1107', 81, 'CAN-999-999-000-999-1055', 223, 'CAN-999-999-000-999-1107', 0, 23, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1108', 81, 'CAN-999-999-000-999-1055', 224, 'CAN-999-999-000-999-1108', 0, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1217', 81, 'CAN-999-999-000-999-1055', 328, 'CAN-999-999-000-999-1217', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1000', 81, 'CAN-999-999-000-999-1055', 152, 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1130', 81, 'CAN-999-999-000-999-1055', 247, 'CAN-999-999-000-999-1130', 0, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1131', 81, 'CAN-999-999-000-999-1055', 248, 'CAN-999-999-000-999-1131', 0, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1223', 81, 'CAN-999-999-000-999-1055', 333, 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1194', 81, 'CAN-999-999-000-999-1055', 306, 'CAN-999-999-000-999-1194', 0, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1110', 81, 'CAN-999-999-000-999-1055', 227, 'CAN-999-999-000-999-1110', 0, 30, '', '0', '', '0', '', '0', '', '1', 'number', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1222', 81, 'CAN-999-999-000-999-1055', 332, 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1055_CAN-999-999-000-999-1018', 81, 'CAN-999-999-000-999-1055', 170, 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structures` 
SET `alias` = 'aliquot_search_for_datamart_demo'
WHERE `old_id` IN ('CAN-999-999-000-999-1056');

DELETE FROM `structure_formats` WHERE `structure_old_id` IN ('CAN-999-999-000-999-1056');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1056_CAN-999-999-000-999-1102', 82, 'CAN-999-999-000-999-1056', 218, 'CAN-999-999-000-999-1102', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1056_CAN-999-999-000-999-1100', 82, 'CAN-999-999-000-999-1056', 216, 'CAN-999-999-000-999-1100', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1056_CAN-999-999-000-999-1103', 82, 'CAN-999-999-000-999-1056', 219, 'CAN-999-999-000-999-1103', 0, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1056_CAN-999-999-000-999-1130', 82, 'CAN-999-999-000-999-1056', 247, 'CAN-999-999-000-999-1130', 0, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1056_CAN-999-999-000-999-1131', 82, 'CAN-999-999-000-999-1056', 248, 'CAN-999-999-000-999-1131', 0, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1056_CAN-999-999-000-999-1018', 82, 'CAN-999-999-000-999-1056', 170, 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structures` 
SET `alias` = 'participant_search_for_datamart_demo'
WHERE `old_id` IN ('CAN-999-999-000-999-1003');

DELETE FROM `structure_formats` WHERE `structure_old_id` IN ('CAN-999-999-000-999-1003');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1003_CAN-999-999-000-999-1', 34, 'CAN-999-999-000-999-1003', 149, 'CAN-999-999-000-999-1', 0, 1, '', '1', 'first name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1003_CAN-999-999-000-999-2', 34, 'CAN-999-999-000-999-1003', 460, 'CAN-999-999-000-999-2', 0, 2, '', '1', 'last name', '0', '', '0', '', '0', '', '1', 'tool=csv', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1003_CAN-999-999-000-999-5', 34, 'CAN-999-999-000-999-1003', 744, 'CAN-999-999-000-999-5', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1003_CAN-999-999-000-999-57', 34, 'CAN-999-999-000-999-1003', 801, 'CAN-999-999-000-999-57', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1003_CAN-046-003-000-999-1', 34, 'CAN-999-999-000-999-1003', 117, 'CAN-046-003-000-999-1', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `datamart_adhoc`;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `flag_use_query_results`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'Participant For Demo (to test: LIKE, ''='', ''><='' on date, IN)', 'Clinicalannotation', 'Participant', 'participant_search_for_datamart_demo', 'participant_search_for_datamart_demo', 'detail=>/clinicalannotation/participants/profile/%%Participant.id%%/', '

SELECT 
Participant.id,

Participant.first_name,
Participant.last_name,
Participant.date_of_birth,

ConsentMaster.consent_status,
ConsentMaster.status_date

FROM participants AS Participant
LEFT JOIN consent_masters AS ConsentMaster ON ConsentMaster.participant_id = Participant.id
WHERE Participant.first_name LIKE "%@@Participant.first_name@@%"
AND TRUE AND Participant.last_name IN (@@Participant.last_name@@) 
AND ConsentMaster.consent_status = "@@ConsentMaster.consent_status@@"
AND Participant.date_of_birth >= "@@Participant.date_of_birth_start@@" 
AND Participant.date_of_birth <= "@@Participant.date_of_birth_end@@" ;

', 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `flag_use_query_results`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'Aliquot Search For Demo (very basic)', 'Inventorymanagement', 'AliquotMaster', 'aliquot_search_for_datamart_demo', 'aliquot_search_for_datamart_demo', 'aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/|sample detail=>/clinicalannotation/sample_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/', '

SELECT AliquotMaster.id, 
AliquotMaster.sample_master_id,
AliquotMaster.collection_id,
 
SampleMaster.sample_type, 

AliquotMaster.aliquot_type, 
AliquotMaster.barcode, 
AliquotMaster.in_stock, 
AliquotMaster.current_volume, 
AliquotMaster.aliquot_volume_unit

FROM sample_masters AS SampleMaster
INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id 
WHERE TRUE AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" 
AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" 
AND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@";

', 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `flag_use_query_results`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'Complex Aliquot Search For Demo (to test: LIKE, ''='', ''><='' on number)', 'Inventorymanagement', 'AliquotMaster', 'aliquot_search_for_datamart_demo_2', 'aliquot_search_for_datamart_demo_2', NULL, '

SELECT AliquotMaster.id, 

Collection.acquisition_label,
Collection.bank_id, 

SampleMaster.initial_specimen_sample_type,
SampleMaster.sample_type, 

AliquotMaster.aliquot_type, 
AliquotMaster.barcode, 
AliquotMaster.in_stock, 
AliquotMaster.current_volume, 
AliquotMaster.aliquot_volume_unit, 

StorageMaster.id, 
StorageMaster.selection_label, 
AliquotMaster.storage_coord_x, 
AliquotMaster.storage_coord_y, 
StorageMaster.temperature, 
StorageMaster.temp_unit 

FROM collections AS Collection 
INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id 
INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id 
INNER JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id 
WHERE TRUE AND Collection.bank_id = "@@Collection.bank_id@@" 
AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" 
AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" 
AND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@" 
AND StorageMaster.selection_label LIKE "%@@StorageMaster.selection_label@@%" 
AND StorageMaster.temperature >= "@@StorageMaster.temperature_start@@" 
AND StorageMaster.temperature <= "@@StorageMaster.temperature_end@@" 
AND StorageMaster.temp_unit = "@@StorageMaster.temp_unit@@" 
ORDER BY StorageMaster.selection_label, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y;

', 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `datamart_batch_processes`;
INSERT INTO `datamart_batch_processes` (`id` , `name` , `plugin` , `model` ,`url`)
VALUES (NULL , 'add to order', 'Inventorymanagement', 'AliquotMaster', '/order/order_items/addAliquotsInBatch/');

