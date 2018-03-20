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
	('AliquotMasters', 'aliquotmaster', 'addAliquotInternalUse', 'InventoryManagement/AliquotMasters/addAliquotInternalUse/','aliquot_master_id = null'), 
	('AliquotMasters', 'aliquotmaster', 'add', 'InventoryManagement/AliquotMasters/add/', 'sample_master_id = null, aliquot_control_id = null, quantity = 1'),
	('AliquotMasters', 'aliquotmaster', 'addInit', 'InventoryManagement/AliquotMasters/addInit/', ''),
	('AliquotMasters', 'aliquotmaster', 'addSourceAliquots', 'InventoryManagement/AliquotMasters/addSourceAliquots/', 'collection_id, sample_master_id'),
	('AliquotMasters', 'aliquotmaster', 'defineRealiquotedChildren', 'InventoryManagement/AliquotMasters/defineRealiquotedChildren/', 'aliquot_master_id = null'),
	('AliquotMasters', 'aliquotmaster', 'delete', 'InventoryManagement/AliquotMasters/delete/', 'collection_id, sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'aliquotmaster', 'deleteAliquotInternalUse', 'InventoryManagement/AliquotMasters/deleteAliquotInternalUse/', 'aliquot_master_id, aliquot_use_id'),
	('AliquotMasters', 'aliquotmaster', 'deleteRealiquotingData', 'InventoryManagement/AliquotMasters/deleteRealiquotingData/', 'parent_id, child_id, source'),
	('AliquotMasters', 'aliquotmaster', 'deleteSourceAliquot', 'InventoryManagement/AliquotMasters/deleteSourceAliquot/', 'sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'aliquotmaster', 'detail', 'InventoryManagement/AliquotMasters/detail/', 'collection_id, sample_master_id, aliquot_master_id, is_from_tree_view_or_layout = 0'),
	('AliquotMasters', 'aliquotmaster', 'detailAliquotInternalUse', 'InventoryManagement/AliquotMasters/detailAliquotInternalUse/', 'aliquot_master_id, aliquot_use_id'),
	('AliquotMasters', 'aliquotmaster', 'edit', 'InventoryManagement/AliquotMasters/edit/', 'collection_id, sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'aliquotmaster', 'editAliquotInternalUse', 'InventoryManagement/AliquotMasters/editAliquotInternalUse/', 'aliquot_master_id, aliquot_use_id'),
	('AliquotMasters', 'aliquotmaster', 'editRealiquoting', 'InventoryManagement/AliquotMasters/editRealiquoting/', 'realiquoting_id'),
	('AliquotMasters', 'aliquotmaster', 'editSourceAliquot', 'InventoryManagement/AliquotMasters/editSourceAliquot/', 'sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'aliquotmaster', 'listAllRealiquotedParents', 'InventoryManagement/AliquotMasters/listAllRealiquotedParents/', 'collection_id, sample_master_id, aliquot_master_id'),
	('AliquotMasters', 'aliquotmaster', 'listallUses', 'InventoryManagement/AliquotMasters/listallUses/', 'collection_id, sample_master_id, aliquot_master_id, is_from_tree_view = false'),
	('AliquotMasters', 'aliquotmaster', 'realiquot', 'InventoryManagement/AliquotMasters/realiquot/', 'aliquot_id = null'),
	('AliquotMasters', 'aliquotmaster', 'realiquotInit', 'InventoryManagement/AliquotMasters/realiquotInit/', 'process_type, aliquot_id = null'),
	('AliquotMasters', 'aliquotmaster', 'realiquotInit2', 'InventoryManagement/AliquotMasters/realiquotInit2/', 'process_type, aliquot_id = null'),
	('Announcements', 'announcement', 'detail', 'Customize/Announcements/detail/', 'announcement_id = NULL'),
	('Announcements', 'announcement', 'index', 'Customize/Announcements/index/', 'list_type = '''''),
	('Banks', 'bank', 'add', 'Administrate/Banks/add/', ''), 
	('Banks', 'bank', 'delete', 'Administrate/Banks/delete/', 'bank_id'), 
	('Banks', 'bank', 'detail', 'Administrate/Banks/detail/', 'bank_id'), 
	('Banks', 'bank', 'edit', 'Administrate/Banks/edit/', 'bank_id'), 
	('Banks', 'bank', 'index', 'Administrate/Banks/index/', ''), 
	('Browser', 'browser', 'browse', 'Datamart/Browser/browse/', '$nodeId = 0, $controlId = 0, $mergeTo = 0'),
	('Browser', 'browser', 'getBrowserSearchlist', 'Datamart/Browser/getBrowserSearchlist/', ''),
	('Browser', 'browser', 'getControlList', 'Datamart/Browser/getControlList/', ''),
	('Browser', 'browser', 'getApiCmalp', 'Datamart/Browser/getApiCmalp/', ''),
	('ClinicalCollectionLinks', 'collection', 'add', 'ClinicalAnnotation/ClinicalCollectionLinks/add/', 'participant_id'),
	('ClinicalCollectionLinks', 'collection', 'delete', 'ClinicalAnnotation/ClinicalCollectionLinks/delete/', 'participant_id, collection_id'),
	('ClinicalCollectionLinks', 'collection', 'detail', 'ClinicalAnnotation/ClinicalCollectionLinks/detail/', 'participant_id, collection_id'),
	('ClinicalCollectionLinks', 'collection', 'edit', 'ClinicalAnnotation/ClinicalCollectionLinks/edit/', 'participant_id, collection_id'),
	('ClinicalCollectionLinks', 'collection', 'listall', 'ClinicalAnnotation/ClinicalCollectionLinks/listall/', 'participant_id'),
	('Collections', 'collection', 'add', 'InventoryManagement/Collections/add/', 'collection_id = 0, copy_source = 0'),
	('Collections', 'collection', 'delete', 'InventoryManagement/Collections/delete/', 'collection_id'),
	('Collections', 'collection', 'detail', 'InventoryManagement/Collections/detail/', 'collection_id, hide_header = false'),
	('Collections', 'collection', 'edit', 'InventoryManagement/Collections/edit/', 'collection_id'),
	('ConsentMasters', 'consentmaster', 'add', 'ClinicalAnnotation/ConsentMasters/add/', 'participant_id, consent_control_id'),
	('ConsentMasters', 'consentmaster', 'delete', 'ClinicalAnnotation/ConsentMasters/delete/', 'participant_id, consent_master_id'),
	('ConsentMasters', 'consentmaster', 'detail', 'ClinicalAnnotation/ConsentMasters/detail/', 'participant_id, consent_master_id'),
	('ConsentMasters', 'consentmaster', 'edit', 'ClinicalAnnotation/ConsentMasters/edit/', 'participant_id, consent_master_id'),
	('ConsentMasters', 'consentmaster', 'listall', 'ClinicalAnnotation/ConsentMasters/listall/', 'participant_id'),
	('DiagnosisMasters', 'diagnosismaster', 'add', 'ClinicalAnnotation/DiagnosisMasters/add/', 'participant_id, dx_control_id, parent_id'),
	('DiagnosisMasters', 'diagnosismaster', 'delete', 'ClinicalAnnotation/DiagnosisMasters/delete/', 'participant_id, diagnosis_master_id'),
	('DiagnosisMasters', 'diagnosismaster', 'detail', 'ClinicalAnnotation/DiagnosisMasters/detail/', 'participant_id, diagnosis_master_id'),
	('DiagnosisMasters', 'diagnosismaster', 'edit', 'ClinicalAnnotation/DiagnosisMasters/edit/', 'participant_id, diagnosis_master_id, redefined_primary_control_id = null'),
	('DiagnosisMasters', 'diagnosismaster', 'listall', 'ClinicalAnnotation/DiagnosisMasters/listall/', 'participant_id, parent_dx_id = null, is_ajax = 0'),
	('Dropdowns', 'structurepermissiblevaluescustom', 'add', 'Administrate/Dropdowns/add/', 'control_id'),
	('Dropdowns', 'structurepermissiblevaluescustom', 'edit', 'Administrate/Dropdowns/edit/', 'control_id, value_id'),
	('Dropdowns', 'structurepermissiblevaluescustom', 'view', 'Administrate/Dropdowns/view/', 'control_id'),
	('Drugs', 'drug', 'add', 'Drug/Drugs/add/', ''), 
	('Drugs', 'drug', 'delete', 'Drug/Drugs/delete/', 'drug_id'), 
	('Drugs', 'drug', 'detail', 'Drug/Drugs/detail/', 'drug_id'), 
	('Drugs', 'drug', 'edit', 'Drug/Drugs/edit/', 'drug_id'), 
	('Drugs', 'drug', 'autocompleteDrug', 'Drug/Drugs/autocompleteDrug/', ''),
	('EventMasters', 'eventmaster', 'add', 'ClinicalAnnotation/EventMasters/add/', 'participant_id, event_control_id, diagnosis_master_id = null'),
	('EventMasters', 'eventmaster', 'delete', 'ClinicalAnnotation/EventMasters/delete/', 'participant_id, event_master_id'),
	('EventMasters', 'eventmaster', 'detail', 'ClinicalAnnotation/EventMasters/detail/', 'participant_id, event_master_id, is_ajax = 0'),
	('EventMasters', 'eventmaster', 'edit', 'ClinicalAnnotation/EventMasters/edit/', 'participant_id, event_master_id'),
	('EventMasters', 'eventmaster', 'listall', 'ClinicalAnnotation/EventMasters/listall/', 'event_group, participant_id, event_control_id = null'),
	('FamilyHistories', 'familyhistory', 'add', 'ClinicalAnnotation/FamilyHistories/add/', 'participant_id'),
	('FamilyHistories', 'familyhistory', 'delete', 'ClinicalAnnotation/FamilyHistories/delete/', 'participant_id, family_history_id'),
	('FamilyHistories', 'familyhistory', 'detail', 'ClinicalAnnotation/FamilyHistories/detail/', 'participant_id, family_history_id'),
	('FamilyHistories', 'familyhistory', 'edit', 'ClinicalAnnotation/FamilyHistories/edit/', 'participant_id, family_history_id'),
	('FamilyHistories', 'familyhistory', 'listall', 'ClinicalAnnotation/FamilyHistories/listall/', 'participant_id'),
	('MiscIdentifiers', 'miscidentifier', 'add', 'ClinicalAnnotation/MiscIdentifiers/add/', 'participant_id, misc_identifier_control_id'),
	('MiscIdentifiers', 'miscidentifier', 'delete', 'ClinicalAnnotation/MiscIdentifiers/delete/', 'participant_id, misc_identifier_id'),
	('MiscIdentifiers', 'miscidentifier', 'edit', 'ClinicalAnnotation/MiscIdentifiers/edit/', 'participant_id, misc_identifier_id'),
	('MiscIdentifiers', 'miscidentifier', 'listall', 'ClinicalAnnotation/MiscIdentifiers/listall/', 'participant_id'),
	('MiscIdentifiers', 'miscidentifier', 'reuse', 'ClinicalAnnotation/MiscIdentifiers/reuse/', 'participant_id, misc_identifier_ctrl_id, submited = false'),
	('OrderItems', 'orderitem', 'add', 'Order/OrderItems/add/', 'order_id, order_line_id = 0 , object_model_name = ''AliquotMaster'''),
	('OrderItems', 'orderitem', 'addAliquotsInBatch', 'Order/OrderItems/addAliquotsInBatch/', 'aliquot_master_id = null'),
	('OrderItems', 'orderitem', 'addOrderItemsInBatch', 'Order/OrderItems/addOrderItemsInBatch/', 'object_model_name, object_id = null'),
	('OrderItems', 'orderitem', 'defineOrderItemsReturned', 'Order/OrderItems/defineOrderItemsReturned/', 'order_id = 0, order_line_id = 0, shipment_id = 0, order_item_id = 0'),
	('OrderItems', 'orderitem', 'delete', 'Order/OrderItems/delete/', 'order_id, order_item_id, main_form_model = null'),
	('OrderItems', 'orderitem', 'edit', 'Order/OrderItems/edit/', 'order_id, order_item_id, main_form_model = null'),
	('OrderItems', 'orderitem', 'editInBatch', 'Order/OrderItems/editInBatch/', ''),
	('OrderItems', 'orderitem', 'listall', 'Order/OrderItems/listall/', 'order_id, status = ''all'', order_line_id = null, shipment_id = null, main_form_model = null'),
	('OrderItems', 'orderitem', 'removeFlagReturned', 'Order/OrderItems/removeFlagReturned/', 'order_id, order_item_id, main_form_model = null'),
	('OrderLines', 'orderline', 'add', 'Order/OrderLines/add/', 'order_id'),
	('OrderLines', 'orderline', 'delete', 'Order/OrderLines/delete/', 'order_id, order_line_id'),
	('OrderLines', 'orderline', 'detail', 'Order/OrderLines/detail/', 'order_id, order_line_id'),
	('OrderLines', 'orderline', 'edit', 'Order/OrderLines/edit/', 'order_id, order_line_id'),
	('OrderLines', 'orderline', 'listall', 'Order/OrderLines/listall/', 'order_id'),
	('Orders', 'order', 'add', 'Order/Orders/add/', ''), 
	('Orders', 'order', 'delete', 'Order/Orders/delete/', 'order_id'), 
	('Orders', 'order', 'detail', 'Order/Orders/detail/', 'order_id , is_from_tree_view = false'),
	('Orders', 'order', 'edit', 'Order/Orders/edit/', 'order_id'), 
	('ParticipantContacts', 'participantcontact', 'add', 'ClinicalAnnotation/ParticipantContacts/add/', 'participant_id'),
	('ParticipantContacts', 'participantcontact', 'delete', 'ClinicalAnnotation/ParticipantContacts/delete/', 'participant_id, participant_contact_id'),
	('ParticipantContacts', 'participantcontact', 'detail', 'ClinicalAnnotation/ParticipantContacts/detail/', 'participant_id, participant_contact_id'),
	('ParticipantContacts', 'participantcontact', 'edit', 'ClinicalAnnotation/ParticipantContacts/edit/', 'participant_id, participant_contact_id'),
	('ParticipantContacts', 'participantcontact', 'listall', 'ClinicalAnnotation/ParticipantContacts/listall/', 'participant_id'),
	('ParticipantMessages', 'participantmessage', 'add', 'ClinicalAnnotation/ParticipantMessages/add/', 'participant_id = null'),
	('ParticipantMessages', 'participantmessage', 'delete', 'ClinicalAnnotation/ParticipantMessages/delete/', 'participant_id, participant_message_id'),
	('ParticipantMessages', 'participantmessage', 'detail', 'ClinicalAnnotation/ParticipantMessages/detail/', 'participant_id, participant_message_id'),
	('ParticipantMessages', 'participantmessage', 'edit', 'ClinicalAnnotation/ParticipantMessages/edit/', 'participant_id, participant_message_id'),
	('ParticipantMessages', 'participantmessage', 'listall', 'ClinicalAnnotation/ParticipantMessages/listall/', 'participant_id'),
	('Participants', 'participant', 'add', 'ClinicalAnnotation/Participants/add/', ''),
	('Participants', 'participant', 'delete', 'ClinicalAnnotation/Participants/delete/', 'participant_id'),
	('Participants', 'participant', 'edit', 'ClinicalAnnotation/Participants/edit/', 'participant_id'),
	('Participants', 'participant', 'profile', 'ClinicalAnnotation/Participants/profile/', 'participant_id'),
	('ProtocolExtendMasters', 'protocolextendmaster', 'add', 'Protocol/ProtocolExtendMasters/add/', 'protocol_master_id'),
	('ProtocolExtendMasters', 'protocolextendmaster', 'delete', 'Protocol/ProtocolExtendMasters/delete/', 'protocol_master_id, protocol_extend_master_id'),
	('ProtocolExtendMasters', 'protocolextendmaster', 'detail', 'Protocol/ProtocolExtendMasters/detail/', 'protocol_master_id, protocol_extend_master_id'),
	('ProtocolExtendMasters', 'protocolextendmaster', 'edit', 'Protocol/ProtocolExtendMasters/edit/', 'protocol_master_id, protocol_extend_master_id'),
	('ProtocolExtendMasters', 'protocolextendmaster', 'listall', 'Protocol/ProtocolExtendMasters/listall/', 'protocol_master_id'),
	('ProtocolMasters', 'protocolmaster', 'add', 'Protocol/ProtocolMasters/add/', 'protocol_control_id'),
	('ProtocolMasters', 'protocolmaster', 'delete', 'Protocol/ProtocolMasters/delete/', 'protocol_master_id'),
	('ProtocolMasters', 'protocolmaster', 'detail', 'Protocol/ProtocolMasters/detail/', 'protocol_master_id'),
	('ProtocolMasters', 'protocolmaster', 'edit', 'Protocol/ProtocolMasters/edit/', 'protocol_master_id'),
	('QualityCtrls', 'qualityctrl', 'addInit & add', 'InventoryManagement/QualityCtrls/addInit & add/', 'sample_master_id = null'),
	('QualityCtrls', 'qualityctrl', 'delete', 'InventoryManagement/QualityCtrls/delete/', 'collection_id, sample_master_id, quality_ctrl_id'),
	('QualityCtrls', 'qualityctrl', 'detail', 'InventoryManagement/QualityCtrls/detail/', 'collection_id, sample_master_id, quality_ctrl_id, is_from_tree_view = false'),
	('QualityCtrls', 'qualityctrl', 'edit', 'InventoryManagement/QualityCtrls/edit/', 'collection_id, sample_master_id, quality_ctrl_id'),
	('QualityCtrls', 'qualityctrl', 'listAll', 'InventoryManagement/QualityCtrls/listAll/', 'collection_id, sample_master_id'),
	('ReproductiveHistories', 'reproductivehistory', 'add', 'ClinicalAnnotation/ReproductiveHistories/add/', 'participant_id'),
	('ReproductiveHistories', 'reproductivehistory', 'delete', 'ClinicalAnnotation/ReproductiveHistories/delete/', 'participant_id, reproductive_history_id'),
	('ReproductiveHistories', 'reproductivehistory', 'detail', 'ClinicalAnnotation/ReproductiveHistories/detail/', 'participant_id, reproductive_history_id'),
	('ReproductiveHistories', 'reproductivehistory', 'edit', 'ClinicalAnnotation/ReproductiveHistories/edit/', 'participant_id, reproductive_history_id'),
	('ReproductiveHistories', 'reproductivehistory', 'listall', 'ClinicalAnnotation/ReproductiveHistories/listall/', 'participant_id'),
	('SampleMasters', 'samplemaster', 'add', 'InventoryManagement/SampleMasters/add/', 'collection_id, sample_control_id, parent_sample_master_id = 0'),
	('SampleMasters', 'samplemaster', 'batchDerivative', 'InventoryManagement/SampleMasters/batchDerivative/', 'aliquot_master_id = null'),
	('SampleMasters', 'samplemaster', 'batchDerivativeInit', 'InventoryManagement/SampleMasters/batchDerivativeInit/', 'aliquot_master_id = null'),
	('SampleMasters', 'samplemaster', 'batchDerivativeInit2', 'InventoryManagement/SampleMasters/batchDerivativeInit2/', 'aliquot_master_id = null'),
	('SampleMasters', 'samplemaster', 'delete', 'InventoryManagement/SampleMasters/delete/', 'collection_id, sample_master_id'),
	('SampleMasters', 'samplemaster', 'detail', 'InventoryManagement/SampleMasters/detail/', 'collection_id, sample_master_id, is_from_tree_view = 0'),
	('SampleMasters', 'samplemaster', 'edit', 'InventoryManagement/SampleMasters/edit/', 'collection_id, sample_master_id'),
	('SampleMasters', 'samplemaster', 'listAllDerivatives', 'InventoryManagement/SampleMasters/listAllDerivatives/', 'collection_id, specimen_sample_master_id'),
	('Shipments', 'shipment', 'add', 'Order/Shipments/add/', 'order_id, copied_shipment_id = null'),
	('Shipments', 'shipment', 'addToShipment', 'Order/Shipments/addToShipment/', 'order_id, shipment_id, order_line_id = null, offset = null, limit = null'),
	('Shipments', 'shipment', 'delete', 'Order/Shipments/delete/', 'order_id = null, shipment_id = null'),
	('Shipments', 'shipment', 'deleteFromShipment', 'Order/Shipments/deleteFromShipment/', 'order_id, order_item_id, shipment_id, main_form_model = null'),
	('Shipments', 'shipment', 'detail', 'Order/Shipments/detail/', 'order_id = null, shipment_id = null, is_from_tree_view = false'),
	('Shipments', 'shipment', 'edit', 'Order/Shipments/edit/', 'order_id = null, shipment_id = null'),
	('Shipments', 'shipment', 'listall', 'Order/Shipments/listall/', 'order_id = null'),
	('SopExtends', 'sopextend', 'add', 'Sop/SopExtends/add/', 'sop_master_id = null'),
	('SopExtends', 'sopextend', 'delete', 'Sop/SopExtends/delete/', 'sop_master_id = null, sop_extend_id = null'),
	('SopExtends', 'sopextend', 'detail', 'Sop/SopExtends/detail/', 'sop_master_id = null, sop_extend_id = null'),
	('SopExtends', 'sopextend', 'edit', 'Sop/SopExtends/edit/', 'sop_master_id = null, sop_extend_id = null'),
	('SopMasters', 'sopextend', 'add', 'Sop/SopMasters/add/', 'sop_control_id'),
	('SopMasters', 'sopextend', 'delete', 'Sop/SopMasters/delete/', 'sop_master_id'),
	('SopMasters', 'sopextend', 'detail', 'Sop/SopMasters/detail/', 'sop_master_id'),
	('SopMasters', 'sopextend', 'edit', 'Sop/SopMasters/edit/', 'sop_master_id '),
	('SopMasters', 'sopextend', 'listall', 'Sop/SopMasters/listall/', ''), 
	('SpecimenReviews', 'specimenreviewmaster', 'add', 'InventoryManagement/SpecimenReviews/add/', 'collection_id, sample_master_id, specimen_review_control_id'),
	('SpecimenReviews', 'specimenreviewmaster', 'delete', 'InventoryManagement/SpecimenReviews/delete/', 'collection_id, sample_master_id, specimen_review_id'),
	('SpecimenReviews', 'specimenreviewmaster', 'detail', 'InventoryManagement/SpecimenReviews/detail/', 'collection_id, sample_master_id, specimen_review_id, aliquot_master_id_from_tree_view = false'),
	('SpecimenReviews', 'specimenreviewmaster', 'edit', 'InventoryManagement/SpecimenReviews/edit/', 'collection_id, sample_master_id, specimen_review_id, undo = false'),
	('SpecimenReviews', 'specimenreviewmaster', 'listAll', 'InventoryManagement/SpecimenReviews/listAll/', 'collection_id, sample_master_id'),
	('StorageControls', 'storagecontrol', 'add', 'Administrate/StorageControls/add/', 'storage_category, duplicated_parent_storage_control_id = null'),
	('StorageControls', 'storagecontrol', 'changeActiveStatus', 'Administrate/StorageControls/changeActiveStatus/', 'storage_control_id, redirect_to = ''listAll'''),
	('StorageControls', 'storagecontrol', 'edit', 'Administrate/StorageControls/edit/', 'storage_control_id'),
	('StorageCoordinates', 'storagecoordinate', 'add', 'StorageLayout/StorageCoordinates/add/', 'storage_master_id'),
	('StorageCoordinates', 'storagecoordinate', 'delete', 'StorageLayout/StorageCoordinates/delete/', 'storage_master_id, storage_coordinate_id'),
	('StorageCoordinates', 'storagecoordinate', 'listAll', 'StorageLayout/StorageCoordinates/listAll/', 'storage_master_id'),
	('StorageMasters', 'storagemaster', 'add', 'StorageLayout/StorageMasters/add/', 'storage_control_id, predefined_parent_storage_id = null'),
	('StorageMasters', 'storagemaster', 'delete', 'StorageLayout/StorageMasters/delete/', 'storage_master_id'),
	('StorageMasters', 'storagemaster', 'detail', 'StorageLayout/StorageMasters/detail/', 'storage_master_id, is_from_tree_view_or_layout = 0, storage_category = null'),
	('StorageMasters', 'storagemaster', 'edit', 'StorageLayout/StorageMasters/edit/', 'storage_master_id'),
	('StudyContacts', 'studycontact', 'add', 'Study/StudyContacts/add/', 'study_summary_id'),
	('StudyContacts', 'studycontact', 'delete', 'Study/StudyContacts/delete/', 'study_summary_id, study_contact_id'),
	('StudyContacts', 'studycontact', 'detail', 'Study/StudyContacts/detail/', 'study_summary_id, study_contact_id'),
	('StudyContacts', 'studycontact', 'edit', 'Study/StudyContacts/edit/', 'study_summary_id, study_contact_id'),
	('StudyContacts', 'studycontact', 'listall', 'Study/StudyContacts/listall/', 'study_summary_id'),
	('StudyFundings', 'studyfunding', 'add', 'Study/StudyFundings/add/', 'study_summary_id'),
	('StudyFundings', 'studyfunding', 'delete', 'Study/StudyFundings/delete/', 'study_summary_id, study_funding_id'),
	('StudyFundings', 'studyfunding', 'detail', 'Study/StudyFundings/detail/', 'study_summary_id, study_funding_id'),
	('StudyFundings', 'studyfunding', 'edit', 'Study/StudyFundings/edit/', 'study_summary_id, study_funding_id'),
	('StudyFundings', 'studyfunding', 'listall', 'Study/StudyFundings/listall/', 'study_summary_id'),
	('StudyInvestigators', 'studyinvestigator', 'add', 'Study/StudyInvestigators/add/', 'study_summary_id'),
	('StudyInvestigators', 'studyinvestigator', 'delete', 'Study/StudyInvestigators/delete/', 'study_summary_id, study_investigator_id'),
	('StudyInvestigators', 'studyinvestigator', 'detail', 'Study/StudyInvestigators/detail/', 'study_summary_id, study_investigator_id'),
	('StudyInvestigators', 'studyinvestigator', 'edit', 'Study/StudyInvestigators/edit/', 'study_summary_id, study_investigator_id'),
	('StudyInvestigators', 'studyinvestigator', 'listall', 'Study/StudyInvestigators/listall/', 'study_summary_id'),
	('TmaSlides', 'tmaslide', 'add', 'StorageLayout/TmaSlides/add/', 'tma_block_storage_master_id = null'),
	('TmaSlides', 'tmaslide', 'delete', 'StorageLayout/TmaSlides/delete/', 'tma_block_storage_master_id, tma_slide_id'),
	('TmaSlides', 'tmaslide', 'detail', 'StorageLayout/TmaSlides/detail/', 'tma_block_storage_master_id, tma_slide_id, is_from_tree_view_or_layout = 0'),
	('TmaSlides', 'tmaslide', 'edit', 'StorageLayout/TmaSlides/edit/', 'tma_block_storage_master_id, tma_slide_id, from_slide_page = 0'),
	('TmaSlides', 'tmaslide', 'listAll', 'StorageLayout/TmaSlides/listAll/', 'tma_block_storage_master_id'),
	('TmaSlides', 'tmaslide', 'autocompleteLabel', 'StorageLayout/TmaSlides/autocompleteLabel/', ''),
	('TmaSlideUses', 'tmaslideuse', 'add', 'StorageLayout/TmaSlideUses/add/', 'tma_slide_id = null'),
	('TmaSlideUses', 'tmaslideuse', 'delete', 'StorageLayout/TmaSlideUses/delete/', 'tma_slide_use_id'),
	('TmaSlideUses', 'tmaslideuse', 'edit', 'StorageLayout/TmaSlideUses/edit/', 'tma_slide_use_id'),
	('TmaSlideUses', 'tmaslideuse', 'listAll', 'StorageLayout/TmaSlideUses/listAll/', 'tma_block_storage_master_id, tma_slide_id'),
	('TreatmentExtendMasters', 'treatmentextendmaster', 'add', 'ClinicalAnnotation/TreatmentExtendMasters/add/', 'participant_id, tx_master_id'),
	('TreatmentExtendMasters', 'treatmentextendmaster', 'delete', 'ClinicalAnnotation/TreatmentExtendMasters/delete/', 'participant_id, tx_master_id, tx_extend_id'),
	('TreatmentExtendMasters', 'treatmentextendmaster', 'edit', 'ClinicalAnnotation/TreatmentExtendMasters/edit/', 'participant_id, tx_master_id, tx_extend_id'),
	('TreatmentExtendMasters', 'treatmentextendmaster', 'importDrugFromChemoProtocol', 'ClinicalAnnotation/TreatmentExtendMasters/importDrugFromChemoProtocol/', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'treatmentmaster', 'add', 'ClinicalAnnotation/TreatmentMasters/add/', 'participant_id, tx_control_id, diagnosis_master_id = null'),
	('TreatmentMasters', 'treatmentmaster', 'delete', 'ClinicalAnnotation/TreatmentMasters/delete/', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'treatmentmaster', 'detail', 'ClinicalAnnotation/TreatmentMasters/detail/', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'treatmentmaster', 'edit', 'ClinicalAnnotation/TreatmentMasters/edit/', 'participant_id, tx_master_id'),
	('TreatmentMasters', 'treatmentmaster', 'listall', 'ClinicalAnnotation/TreatmentMasters/listall/', 'participant_id, treatment_control_id = null')
;

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'xxxx','n/a');
