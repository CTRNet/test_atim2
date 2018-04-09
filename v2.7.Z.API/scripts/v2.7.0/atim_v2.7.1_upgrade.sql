-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.1
--
-- For more information:
--    ./app/scripts£v2.7.0/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
--	Issue #3359: The pwd reset form has fields with different look and feel.
-- -------------------------------------------------------------------------------------
INSERT 
INTO 
	`structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
	(NULL, '898', 'notBlank', '', 'password is required');
	

-- -------------------------------------------------------------------------------------
--	The warning for CSV file
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	("csv file warning", "Please validate the export has correctly been completed checking no error message exists at the end of the file", "Veuillez valider que l'exportation a été correctement complétée en vérifiant qu'il n'y a pas de message d'erreur à la fin du fichier");

-- -------------------------------------------------------------------------------------
-- Add user_api_keys for saving api_keys
-- -------------------------------------------------------------------------------------
CREATE TABLE `user_api_keys` (
	`id` INT NOT NULL AUTO_INCREMENT , 
    `user_id` INT NOT NULL , 
	`created_by` int(10) unsigned DEFAULT NULL,
	`modified_by` int(10) unsigned DEFAULT NULL,
    `api_key` VARBINARY(64) NOT NULL , 
	`created` datetime DEFAULT NULL,
	`modified` datetime DEFAULT NULL,
	`flag_active` TINYINT(1) NULL DEFAULT '0',
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',	
    PRIMARY KEY (`id`),
	KEY `user_id_index` (`user_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
	
) ENGINE = InnoDB COMMENT = 'This tables is used for saving the api keys';

-- -------------------------------------------------------------------------------------
-- Add the caps tables (Control action parameters)
-- -------------------------------------------------------------------------------------
CREATE TABLE `api_cmalps` 
  ( 
     `id`         INT(11) NOT NULL auto_increment, 
     `controller` VARCHAR(255) NOT NULL, 
     `model`      VARCHAR(255) NOT NULL, 
     `action`     VARCHAR(255) NOT NULL, 
     `link`       VARCHAR(255) NOT NULL, 
     `parameters` VARCHAR(255) , 
     PRIMARY KEY (`id`) 
  ) 
engine = innodb 
comment = 'Controllers, models, actions, link and parameters that can be used by ATiM_API'; 
-- -------------------------------------------------------------------------------------
-- Insert the data in the cmalps-api table
-- -------------------------------------------------------------------------------------

INSERT INTO `api_cmalps`
(`controller`, `model`, `action`, `link`, `parameters`)
VALUES 
	('AliquotMasters', 'AliquotMaster', 'addAliquotInternalUse', 'InventoryManagement/AliquotMasters/addAliquotInternalUse', 'aliquot_master_id = null'), 
	('AliquotMasters', 'AliquotMaster', 'add', 'InventoryManagement/AliquotMasters/add', 'sample_master_id = null, aliquot_control_id = null, quantity = 1'),
	('AliquotMasters', 'AliquotMaster', 'addInit', 'InventoryManagement/AliquotMasters/addInit', ''),
	('AliquotMasters', 'AliquotMaster', 'addSourceAliquots', 'InventoryManagement/AliquotMasters/addSourceAliquots', 'collection_id, sample_master_id'),
	('AliquotMasters', 'AliquotMaster', 'defineRealiquotedChildren', 'InventoryManagement/AliquotMasters/defineRealiquotedChildren', 'aliquot_master_id = null'),
	('AliquotMasters', 'AliquotMaster', 'delete', 'InventoryManagement/AliquotMasters/delete', 'collection_id, sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'AliquotMaster', 'deleteAliquotInternalUse', 'InventoryManagement/AliquotMasters/deleteAliquotInternalUse', 'aliquot_master_id, aliquot_use_id'),
	('AliquotMasters', 'AliquotMaster', 'deleteRealiquotingData', 'InventoryManagement/AliquotMasters/deleteRealiquotingData', 'parent_id, child_id, source'),
	('AliquotMasters', 'AliquotMaster', 'deleteSourceAliquot', 'InventoryManagement/AliquotMasters/deleteSourceAliquot', 'sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'AliquotMaster', 'detail', 'InventoryManagement/AliquotMasters/detail', 'collection_id, sample_master_id, aliquot_master_id, is_from_tree_view_or_layout = 0'),
	('AliquotMasters', 'AliquotMaster', 'detailAliquotInternalUse', 'InventoryManagement/AliquotMasters/detailAliquotInternalUse', 'aliquot_master_id, aliquot_use_id'),
	('AliquotMasters', 'AliquotMaster', 'edit', 'InventoryManagement/AliquotMasters/edit', 'collection_id, sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'AliquotMaster', 'editAliquotInternalUse', 'InventoryManagement/AliquotMasters/editAliquotInternalUse', 'aliquot_master_id, aliquot_use_id'),
	('AliquotMasters', 'AliquotMaster', 'editRealiquoting', 'InventoryManagement/AliquotMasters/editRealiquoting', 'realiquoting_id'),
	('AliquotMasters', 'AliquotMaster', 'editSourceAliquot', 'InventoryManagement/AliquotMasters/editSourceAliquot', 'sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'AliquotMaster', 'listAllRealiquotedParents', 'InventoryManagement/AliquotMasters/listAllRealiquotedParents', 'collection_id, sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'AliquotMaster', 'listallUses', 'InventoryManagement/AliquotMasters/listallUses', 'collection_id, sample_master_id, aliquot_master_id, is_from_tree_view = false'),
	('AliquotMasters', 'AliquotMaster', 'realiquot', 'InventoryManagement/AliquotMasters/realiquot', 'aliquot_id = null'),
	('AliquotMasters', 'AliquotMaster', 'realiquotInit', 'InventoryManagement/AliquotMasters/realiquotInit', 'process_type, aliquot_id = null'),
	('AliquotMasters', 'AliquotMaster', 'realiquotInit2', 'InventoryManagement/AliquotMasters/realiquotInit2', 'process_type, aliquot_id = null'),
	('Announcements', 'Announcement', 'detail', 'Customize/Announcements/detail', 'announcement_id = NULL'),
	('Announcements', 'Announcement', 'index', 'Customize/Announcements/index', 'list_type = '''''),
	('Banks', 'Bank', 'add', 'Administrate/Banks/add', ''), 
	('Banks', 'Bank', 'delete', 'Administrate/Banks/delete', 'bank_id'), 
	('Banks', 'Bank', 'detail', 'Administrate/Banks/detail', 'bank_id'), 
	('Banks', 'Bank', 'edit', 'Administrate/Banks/edit', 'bank_id'), 
	('Banks', 'Bank', 'index', 'Administrate/Banks/index', ''), 
	('Browser', 'Browser', 'browse', 'Datamart/Browser/browse', '$nodeId = 0, $controlId = 0, $mergeTo = 0'),
	('Browser', 'Browser', 'initialAPI', 'Datamart/Browser/initialAPI', ''),
	('ClinicalCollectionLinks', 'Collection', 'add', 'ClinicalAnnotation/ClinicalCollectionLinks/add', 'participant_id'),
	('ClinicalCollectionLinks', 'Collection', 'delete', 'ClinicalAnnotation/ClinicalCollectionLinks/delete', 'participant_id, collection_id'),
	('ClinicalCollectionLinks', 'Collection', 'detail', 'ClinicalAnnotation/ClinicalCollectionLinks/detail', 'participant_id, collection_id'),
	('ClinicalCollectionLinks', 'Collection', 'edit', 'ClinicalAnnotation/ClinicalCollectionLinks/edit', 'participant_id, collection_id'),
	('ClinicalCollectionLinks', 'Collection', 'listall', 'ClinicalAnnotation/ClinicalCollectionLinks/listall', 'participant_id'),
	('Collections', 'Collection', 'add', 'InventoryManagement/Collections/add', 'collection_id = 0, copy_source = 0'),
	('Collections', 'Collection', 'delete', 'InventoryManagement/Collections/delete', 'collection_id'),
	('Collections', 'Collection', 'detail', 'InventoryManagement/Collections/detail', 'collection_id, hide_header = false'),
	('Collections', 'Collection', 'edit', 'InventoryManagement/Collections/edit', 'collection_id'),
	('ConsentMasters', 'ConsentMaster', 'add', 'ClinicalAnnotation/ConsentMasters/add', 'participant_id, consent_control_id'),
	('ConsentMasters', 'ConsentMaster', 'delete', 'ClinicalAnnotation/ConsentMasters/delete', 'participant_id, consent_master_id'),
	('ConsentMasters', 'ConsentMaster', 'detail', 'ClinicalAnnotation/ConsentMasters/detail', 'participant_id, consent_master_id'),
	('ConsentMasters', 'ConsentMaster', 'edit', 'ClinicalAnnotation/ConsentMasters/edit', 'participant_id, consent_master_id'),
	('ConsentMasters', 'ConsentMaster', 'listall', 'ClinicalAnnotation/ConsentMasters/listall', 'participant_id'),
	('DiagnosisMasters', 'DiagnosisMaster', 'add', 'ClinicalAnnotation/DiagnosisMasters/add', 'participant_id, dx_control_id, parent_id'),
	('DiagnosisMasters', 'DiagnosisMaster', 'delete', 'ClinicalAnnotation/DiagnosisMasters/delete', 'participant_id, diagnosis_master_id'),
	('DiagnosisMasters', 'DiagnosisMaster', 'detail', 'ClinicalAnnotation/DiagnosisMasters/detail', 'participant_id, diagnosis_master_id'),
	('DiagnosisMasters', 'DiagnosisMaster', 'edit', 'ClinicalAnnotation/DiagnosisMasters/edit', 'participant_id, diagnosis_master_id, redefined_primary_control_id = null'),
	('DiagnosisMasters', 'DiagnosisMaster', 'listall', 'ClinicalAnnotation/DiagnosisMasters/listall', 'participant_id, parent_dx_id = null, is_ajax = 0'),
	('Dropdowns', 'StructurePermissibleValuesCustom', 'add', 'Administrate/Dropdowns/add', 'control_id'),
	('Dropdowns', 'StructurePermissibleValuesCustom', 'edit', 'Administrate/Dropdowns/edit', 'control_id, value_id'),
	('Dropdowns', 'StructurePermissibleValuesCustom', 'view', 'Administrate/Dropdowns/view', 'control_id'),
	('Drugs', 'Drug', 'add', 'Drug/Drugs/add', ''), 
	('Drugs', 'Drug', 'delete', 'Drug/Drugs/delete', 'drug_id'), 
	('Drugs', 'Drug', 'detail', 'Drug/Drugs/detail', 'drug_id'), 
	('Drugs', 'Drug', 'edit', 'Drug/Drugs/edit', 'drug_id'), 
	('Drugs', 'Drug', 'autocompleteDrug', 'Drug/Drugs/autocompleteDrug', ''),
	('Drugs', 'Drug', 'search', 'Drug/Drugs/search', ''), 
	('EventMasters', 'EventMaster', 'add', 'ClinicalAnnotation/EventMasters/add', 'participant_id, event_control_id, diagnosis_master_id = null'),
	('EventMasters', 'EventMaster', 'delete', 'ClinicalAnnotation/EventMasters/delete', 'participant_id, event_master_id'),
	('EventMasters', 'EventMaster', 'detail', 'ClinicalAnnotation/EventMasters/detail', 'participant_id, event_master_id, is_ajax = 0'),
	('EventMasters', 'EventMaster', 'edit', 'ClinicalAnnotation/EventMasters/edit', 'participant_id, event_master_id'),
	('EventMasters', 'EventMaster', 'listall', 'ClinicalAnnotation/EventMasters/listall', 'event_group, participant_id, event_control_id = null'),
	('FamilyHistories', 'FamilyHistory', 'add', 'ClinicalAnnotation/FamilyHistories/add', 'participant_id'),
	('FamilyHistories', 'FamilyHistory', 'delete', 'ClinicalAnnotation/FamilyHistories/delete', 'participant_id, family_history_id'),
	('FamilyHistories', 'FamilyHistory', 'detail', 'ClinicalAnnotation/FamilyHistories/detail', 'participant_id, family_history_id'),
	('FamilyHistories', 'FamilyHistory', 'edit', 'ClinicalAnnotation/FamilyHistories/edit', 'participant_id, family_history_id'),
	('FamilyHistories', 'FamilyHistory', 'listall', 'ClinicalAnnotation/FamilyHistories/listall', 'participant_id'),
	('MiscIdentifiers', 'Miscidentifier', 'add', 'ClinicalAnnotation/MiscIdentifiers/add', 'participant_id, misc_identifier_control_id'),
	('MiscIdentifiers', 'Miscidentifier', 'delete', 'ClinicalAnnotation/MiscIdentifiers/delete', 'participant_id, misc_identifier_id'),
	('MiscIdentifiers', 'Miscidentifier', 'edit', 'ClinicalAnnotation/MiscIdentifiers/edit', 'participant_id, misc_identifier_id'),
	('MiscIdentifiers', 'Miscidentifier', 'listall', 'ClinicalAnnotation/MiscIdentifiers/listall', 'participant_id'),
	('MiscIdentifiers', 'Miscidentifier', 'reuse', 'ClinicalAnnotation/MiscIdentifiers/reuse', 'participant_id, misc_identifier_ctrl_id, submited = false'),
	('OrderItems', 'OrderItem', 'add', 'Order/OrderItems/add', 'order_id, order_line_id = 0 , object_model_name = ''AliquotMaster'''),
	('OrderItems', 'OrderItem', 'addAliquotsInBatch', 'Order/OrderItems/addAliquotsInBatch', 'aliquot_master_id = null'),
	('OrderItems', 'OrderItem', 'addOrderItemsInBatch', 'Order/OrderItems/addOrderItemsInBatch', 'object_model_name, object_id = null'),
	('OrderItems', 'OrderItem', 'defineOrderItemsReturned', 'Order/OrderItems/defineOrderItemsReturned', 'order_id = 0, order_line_id = 0, shipment_id = 0, order_item_id = 0'),
	('OrderItems', 'OrderItem', 'delete', 'Order/OrderItems/delete', 'order_id, order_item_id, main_form_model = null'),
	('OrderItems', 'OrderItem', 'edit', 'Order/OrderItems/edit', 'order_id, order_item_id, main_form_model = null'),
	('OrderItems', 'OrderItem', 'editInBatch', 'Order/OrderItems/editInBatch', ''),
	('OrderItems', 'OrderItem', 'listall', 'Order/OrderItems/listall', 'order_id, status = ''all'', order_line_id = null, shipment_id = null, main_form_model = null'),
	('OrderItems', 'OrderItem', 'removeFlagReturned', 'Order/OrderItems/removeFlagReturned', 'order_id, order_item_id, main_form_model = null'),
	('OrderLines', 'OrderLine', 'add', 'Order/OrderLines/add', 'order_id'),
	('OrderLines', 'OrderLine', 'delete', 'Order/OrderLines/delete', 'order_id, order_line_id'),
	('OrderLines', 'OrderLine', 'detail', 'Order/OrderLines/detail', 'order_id, order_line_id'),
	('OrderLines', 'OrderLine', 'edit', 'Order/OrderLines/edit', 'order_id, order_line_id'),
	('OrderLines', 'OrderLine', 'listall', 'Order/OrderLines/listall', 'order_id'),
	('Orders', 'Order', 'add', 'Order/Orders/add', ''), 
	('Orders', 'Order', 'delete', 'Order/Orders/delete', 'order_id'), 
	('Orders', 'Order', 'detail', 'Order/Orders/detail', 'order_id , is_from_tree_view = false'),
	('Orders', 'Order', 'edit', 'Order/Orders/edit', 'order_id'), 
	('ParticipantContacts', 'ParticipantContact', 'add', 'ClinicalAnnotation/ParticipantContacts/add', 'participant_id'),
	('ParticipantContacts', 'ParticipantContact', 'delete', 'ClinicalAnnotation/ParticipantContacts/delete', 'participant_id, participant_contact_id'),
	('ParticipantContacts', 'ParticipantContact', 'detail', 'ClinicalAnnotation/ParticipantContacts/detail', 'participant_id, participant_contact_id'),
	('ParticipantContacts', 'ParticipantContact', 'edit', 'ClinicalAnnotation/ParticipantContacts/edit', 'participant_id, participant_contact_id'),
	('ParticipantContacts', 'ParticipantContact', 'listall', 'ClinicalAnnotation/ParticipantContacts/listall', 'participant_id'),
	('ParticipantMessages', 'ParticipantMessage', 'add', 'ClinicalAnnotation/ParticipantMessages/add', 'participant_id = null'),
	('ParticipantMessages', 'ParticipantMessage', 'delete', 'ClinicalAnnotation/ParticipantMessages/delete', 'participant_id, participant_message_id'),
	('ParticipantMessages', 'ParticipantMessage', 'detail', 'ClinicalAnnotation/ParticipantMessages/detail', 'participant_id, participant_message_id'),
	('ParticipantMessages', 'ParticipantMessage', 'edit', 'ClinicalAnnotation/ParticipantMessages/edit', 'participant_id, participant_message_id'),
	('ParticipantMessages', 'ParticipantMessage', 'listall', 'ClinicalAnnotation/ParticipantMessages/listall', 'participant_id'),
	('Participants', 'Participant', 'add', 'ClinicalAnnotation/Participants/add', ''),
	('Participants', 'Participant', 'delete', 'ClinicalAnnotation/Participants/delete', 'participant_id'),
	('Participants', 'Participant', 'edit', 'ClinicalAnnotation/Participants/edit', 'participant_id'),
	('Participants', 'Participant', 'profile', 'ClinicalAnnotation/Participants/profile', 'participant_id'),
	('ProtocolExtendMasters', 'ProtocolExtendMaster', 'add', 'Protocol/ProtocolExtendMasters/add', 'protocol_master_id'),
	('ProtocolExtendMasters', 'ProtocolExtendMaster', 'delete', 'Protocol/ProtocolExtendMasters/delete', 'protocol_master_id, protocol_extend_master_id'),
	('ProtocolExtendMasters', 'ProtocolExtendMaster', 'detail', 'Protocol/ProtocolExtendMasters/detail', 'protocol_master_id, protocol_extend_master_id'),
	('ProtocolExtendMasters', 'ProtocolExtendMaster', 'edit', 'Protocol/ProtocolExtendMasters/edit', 'protocol_master_id, protocol_extend_master_id'),
	('ProtocolExtendMasters', 'ProtocolExtendMaster', 'listall', 'Protocol/ProtocolExtendMasters/listall', 'protocol_master_id'),
	('ProtocolMasters', 'ProtocolMaster', 'add', 'Protocol/ProtocolMasters/add', 'protocol_control_id'),
	('ProtocolMasters', 'ProtocolMaster', 'delete', 'Protocol/ProtocolMasters/delete', 'protocol_master_id'),
	('ProtocolMasters', 'ProtocolMaster', 'detail', 'Protocol/ProtocolMasters/detail', 'protocol_master_id'),
	('ProtocolMasters', 'ProtocolMaster', 'edit', 'Protocol/ProtocolMasters/edit', 'protocol_master_id'),
	('QualityCtrls', 'QualityCtrl', 'addInit & add', 'InventoryManagement/QualityCtrls/addInit & add', 'sample_master_id = null'),
	('QualityCtrls', 'QualityCtrl', 'delete', 'InventoryManagement/QualityCtrls/delete', 'collection_id, sample_master_id, quality_ctrl_id'),
	('QualityCtrls', 'QualityCtrl', 'detail', 'InventoryManagement/QualityCtrls/detail', 'collection_id, sample_master_id, quality_ctrl_id, is_from_tree_view = false'),
	('QualityCtrls', 'QualityCtrl', 'edit', 'InventoryManagement/QualityCtrls/edit', 'collection_id, sample_master_id, quality_ctrl_id'),
	('QualityCtrls', 'QualityCtrl', 'listAll', 'InventoryManagement/QualityCtrls/listAll', 'collection_id, sample_master_id'),
	('ReproductiveHistories', 'ReproductiveHistory', 'add', 'ClinicalAnnotation/ReproductiveHistories/add', 'participant_id'),
	('ReproductiveHistories', 'ReproductiveHistory', 'delete', 'ClinicalAnnotation/ReproductiveHistories/delete', 'participant_id, reproductive_history_id'),
	('ReproductiveHistories', 'ReproductiveHistory', 'detail', 'ClinicalAnnotation/ReproductiveHistories/detail', 'participant_id, reproductive_history_id'),
	('ReproductiveHistories', 'ReproductiveHistory', 'edit', 'ClinicalAnnotation/ReproductiveHistories/edit', 'participant_id, reproductive_history_id'),
	('ReproductiveHistories', 'ReproductiveHistory', 'listall', 'ClinicalAnnotation/ReproductiveHistories/listall', 'participant_id'),
	('SampleMasters', 'SampleMaster', 'add', 'InventoryManagement/SampleMasters/add', 'collection_id, sample_control_id, parent_sample_master_id = 0'),
	('SampleMasters', 'SampleMaster', 'batchDerivative', 'InventoryManagement/SampleMasters/batchDerivative', 'aliquot_master_id = null'),
	('SampleMasters', 'SampleMaster', 'batchDerivativeInit', 'InventoryManagement/SampleMasters/batchDerivativeInit', 'aliquot_master_id = null'),
	('SampleMasters', 'SampleMaster', 'batchDerivativeInit2', 'InventoryManagement/SampleMasters/batchDerivativeInit2', 'aliquot_master_id = null'),
	('SampleMasters', 'SampleMaster', 'delete', 'InventoryManagement/SampleMasters/delete', 'collection_id, sample_master_id'),
	('SampleMasters', 'SampleMaster', 'detail', 'InventoryManagement/SampleMasters/detail', 'collection_id, sample_master_id, is_from_tree_view = 0'),
	('SampleMasters', 'SampleMaster', 'edit', 'InventoryManagement/SampleMasters/edit', 'collection_id, sample_master_id'),
	('SampleMasters', 'SampleMaster', 'listAllDerivatives', 'InventoryManagement/SampleMasters/listAllDerivatives', 'collection_id, specimen_sample_master_id'),
	('Shipments', 'Shipment', 'add', 'Order/Shipments/add', 'order_id, copied_shipment_id = null'),
	('Shipments', 'Shipment', 'addToShipment', 'Order/Shipments/addToShipment', 'order_id, shipment_id, order_line_id = null, offset = null, limit = null'),
	('Shipments', 'Shipment', 'delete', 'Order/Shipments/delete', 'order_id = null, shipment_id = null'),
	('Shipments', 'Shipment', 'deleteFromShipment', 'Order/Shipments/deleteFromShipment', 'order_id, order_item_id, shipment_id, main_form_model = null'),
	('Shipments', 'Shipment', 'detail', 'Order/Shipments/detail', 'order_id = null, shipment_id = null, is_from_tree_view = false'),
	('Shipments', 'Shipment', 'edit', 'Order/Shipments/edit', 'order_id = null, shipment_id = null'),
	('Shipments', 'Shipment', 'listall', 'Order/Shipments/listall', 'order_id = null'),
	('SopExtends', 'SopExtend', 'add', 'Sop/SopExtends/add', 'sop_master_id = null'),
	('SopExtends', 'SopExtend', 'delete', 'Sop/SopExtends/delete', 'sop_master_id = null, sop_extend_id = null'),
	('SopExtends', 'SopExtend', 'detail', 'Sop/SopExtends/detail', 'sop_master_id = null, sop_extend_id = null'),
	('SopExtends', 'SopExtend', 'edit', 'Sop/SopExtends/edit', 'sop_master_id = null, sop_extend_id = null'),
	('SopMasters', 'SopExtend', 'add', 'Sop/SopMasters/add', 'sop_control_id'),
	('SopMasters', 'SopExtend', 'delete', 'Sop/SopMasters/delete', 'sop_master_id'),
	('SopMasters', 'SopExtend', 'detail', 'Sop/SopMasters/detail', 'sop_master_id'),
	('SopMasters', 'SopExtend', 'edit', 'Sop/SopMasters/edit', 'sop_master_id '),
	('SopMasters', 'SopExtend', 'listall', 'Sop/SopMasters/listall', ''), 
	('SpecimenReviews', 'SpecimenReviewMaster', 'add', 'InventoryManagement/SpecimenReviews/add', 'collection_id, sample_master_id, specimen_review_control_id'),
	('SpecimenReviews', 'SpecimenReviewMaster', 'delete', 'InventoryManagement/SpecimenReviews/delete', 'collection_id, sample_master_id, specimen_review_id'),
	('SpecimenReviews', 'SpecimenReviewMaster', 'detail', 'InventoryManagement/SpecimenReviews/detail', 'collection_id, sample_master_id, specimen_review_id, aliquot_master_id_from_tree_view = false'),
	('SpecimenReviews', 'SpecimenReviewMaster', 'edit', 'InventoryManagement/SpecimenReviews/edit', 'collection_id, sample_master_id, specimen_review_id, undo = false'),
	('SpecimenReviews', 'SpecimenReviewMaster', 'listAll', 'InventoryManagement/SpecimenReviews/listAll', 'collection_id, sample_master_id'),
	('StorageControls', 'StorageControl', 'add', 'Administrate/StorageControls/add', 'storage_category, duplicated_parent_storage_control_id = null'),
	('StorageControls', 'StorageControl', 'changeActiveStatus', 'Administrate/StorageControls/changeActiveStatus', 'storage_control_id, redirect_to = ''listAll'''),
	('StorageControls', 'StorageControl', 'edit', 'Administrate/StorageControls/edit', 'storage_control_id'),
	('StorageCoordinates', 'StorageCoordinate', 'add', 'StorageLayout/StorageCoordinates/add', 'storage_master_id'),
	('StorageCoordinates', 'StorageCoordinate', 'delete', 'StorageLayout/StorageCoordinates/delete', 'storage_master_id, storage_coordinate_id'),
	('StorageCoordinates', 'StorageCoordinate', 'listAll', 'StorageLayout/StorageCoordinates/listAll', 'storage_master_id'),
	('StorageMasters', 'StorageMaster', 'add', 'StorageLayout/StorageMasters/add', 'storage_control_id, predefined_parent_storage_id = null'),
	('StorageMasters', 'StorageMaster', 'delete', 'StorageLayout/StorageMasters/delete', 'storage_master_id'),
	('StorageMasters', 'StorageMaster', 'detail', 'StorageLayout/StorageMasters/detail', 'storage_master_id, is_from_tree_view_or_layout = 0, storage_category = null'),
	('StorageMasters', 'StorageMaster', 'edit', 'StorageLayout/StorageMasters/edit', 'storage_master_id'),
	('StudyContacts', 'StudyContact', 'add', 'Study/StudyContacts/add', 'study_summary_id'),
	('StudyContacts', 'StudyContact', 'delete', 'Study/StudyContacts/delete', 'study_summary_id, study_contact_id'),
	('StudyContacts', 'StudyContact', 'detail', 'Study/StudyContacts/detail', 'study_summary_id, study_contact_id'),
	('StudyContacts', 'StudyContact', 'edit', 'Study/StudyContacts/edit', 'study_summary_id, study_contact_id'),
	('StudyContacts', 'StudyContact', 'listall', 'Study/StudyContacts/listall', 'study_summary_id'),
	('StudyFundings', 'StudyFunding', 'add', 'Study/StudyFundings/add', 'study_summary_id'),
	('StudyFundings', 'StudyFunding', 'delete', 'Study/StudyFundings/delete', 'study_summary_id, study_funding_id'),
	('StudyFundings', 'StudyFunding', 'detail', 'Study/StudyFundings/detail', 'study_summary_id, study_funding_id'),
	('StudyFundings', 'StudyFunding', 'edit', 'Study/StudyFundings/edit', 'study_summary_id, study_funding_id'),
	('StudyFundings', 'StudyFunding', 'listall', 'Study/StudyFundings/listall', 'study_summary_id'),
	('StudyInvestigators', 'StudyInvestigator', 'add', 'Study/StudyInvestigators/add', 'study_summary_id'),
	('StudyInvestigators', 'StudyInvestigator', 'delete', 'Study/StudyInvestigators/delete', 'study_summary_id, study_investigator_id'),
	('StudyInvestigators', 'StudyInvestigator', 'detail', 'Study/StudyInvestigators/detail', 'study_summary_id, study_investigator_id'),
	('StudyInvestigators', 'StudyInvestigator', 'edit', 'Study/StudyInvestigators/edit', 'study_summary_id, study_investigator_id'),
	('StudyInvestigators', 'StudyInvestigator', 'listall', 'Study/StudyInvestigators/listall', 'study_summary_id'),
	('TmaSlides', 'TmaSlide', 'add', 'StorageLayout/TmaSlides/add', 'tma_block_storage_master_id = null'),
	('TmaSlides', 'TmaSlide', 'delete', 'StorageLayout/TmaSlides/delete', 'tma_block_storage_master_id, tma_slide_id'),
	('TmaSlides', 'TmaSlide', 'detail', 'StorageLayout/TmaSlides/detail', 'tma_block_storage_master_id, tma_slide_id, is_from_tree_view_or_layout = 0'),
	('TmaSlides', 'TmaSlide', 'edit', 'StorageLayout/TmaSlides/edit', 'tma_block_storage_master_id, tma_slide_id, from_slide_page = 0'),
	('TmaSlides', 'TmaSlide', 'listAll', 'StorageLayout/TmaSlides/listAll', 'tma_block_storage_master_id'),
	('TmaSlides', 'TmaSlide', 'autocompleteLabel', 'StorageLayout/TmaSlides/autocompleteLabel', ''),
	('TmaSlideUses', 'TmaSlideUse', 'add', 'StorageLayout/TmaSlideUses/add', 'tma_slide_id = null'),
	('TmaSlideUses', 'TmaSlideUse', 'delete', 'StorageLayout/TmaSlideUses/delete', 'tma_slide_use_id'),
	('TmaSlideUses', 'TmaSlideUse', 'edit', 'StorageLayout/TmaSlideUses/edit', 'tma_slide_use_id'),
	('TmaSlideUses', 'TmaSlideUse', 'listAll', 'StorageLayout/TmaSlideUses/listAll', 'tma_block_storage_master_id, tma_slide_id'),
	('TreatmentExtendMasters', 'TreatmentExtendMaster', 'add', 'ClinicalAnnotation/TreatmentExtendMasters/add', 'participant_id, tx_master_id'),
	('TreatmentExtendMasters', 'TreatmentExtendMaster', 'delete', 'ClinicalAnnotation/TreatmentExtendMasters/delete', 'participant_id, tx_master_id, tx_extend_id'),
	('TreatmentExtendMasters', 'TreatmentExtendMaster', 'edit', 'ClinicalAnnotation/TreatmentExtendMasters/edit', 'participant_id, tx_master_id, tx_extend_id'),
	('TreatmentExtendMasters', 'TreatmentExtendMaster', 'importDrugFromChemoProtocol', 'ClinicalAnnotation/TreatmentExtendMasters/importDrugFromChemoProtocol', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'TreatmentMaster', 'add', 'ClinicalAnnotation/TreatmentMasters/add', 'participant_id, tx_control_id, diagnosis_master_id = null'),
	('TreatmentMasters', 'TreatmentMaster', 'delete', 'ClinicalAnnotation/TreatmentMasters/delete', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'TreatmentMaster', 'detail', 'ClinicalAnnotation/TreatmentMasters/detail', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'TreatmentMaster', 'edit', 'ClinicalAnnotation/TreatmentMasters/edit', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'TreatmentMaster', 'listall', 'ClinicalAnnotation/TreatmentMasters/listall', 'participant_id, treatment_control_id = null')
;

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'xxxx','n/a');
