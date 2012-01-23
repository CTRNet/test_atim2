INSERT INTO `versions` (version_number, date_installed, build_number) 
VALUES('2.5.0', NOW(),'> 4043');

REPLACE INTO i18n (id, en, fr) VALUES
('reserved for study','Reserved For Study/Project','Réservé pour une Étude/Projet'),
('identifier name','Identifier Name', "Nom d'identifiant");

UPDATE menus SET use_link='/ClinicalAnnotation/Participants/search/' WHERE id='clin_CAN_1';
UPDATE menus SET use_link='/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%' WHERE id='clin_CAN_10';
UPDATE menus SET use_link='/ClinicalAnnotation/Participants/chronology/%%Participant.id%%' WHERE id='clin_CAN_1_13';
UPDATE menus SET use_link='/ClinicalAnnotation/MiscIdentifiers/listall/%%Participant.id%%' WHERE id='clin_CAN_24';
UPDATE menus SET use_link='/ClinicalAnnotation/ParticipantMessages/listall/%%Participant.id%%' WHERE id='clin_CAN_25';
UPDATE menus SET use_link='/ClinicalAnnotation/ParticipantContacts/listall/%%Participant.id%%' WHERE id='clin_CAN_26';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/screening/%%Participant.id%%' WHERE id='clin_CAN_27';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE id='clin_CAN_28';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/lifestyle/%%Participant.id%%' WHERE id='clin_CAN_30';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%' WHERE id='clin_CAN_31';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/adverse_events/%%Participant.id%%' WHERE id='clin_CAN_32';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Study/%%Participant.id%%' WHERE id='clin_CAN_33';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%' WHERE id='clin_CAN_4';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/listall/%%Participant.id%%' WHERE id='clin_CAN_5';
UPDATE menus SET use_link='/ClinicalAnnotation/ClinicalCollectionLinks/listall/%%Participant.id%%' WHERE id='clin_CAN_57';
UPDATE menus SET use_link='/ClinicalAnnotation/ProductMasters/productsTreeView/%%Participant.id%%' WHERE id='clin_CAN_571';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.primary_id%%' WHERE id='clin_CAN_5_1';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_1_id%%' WHERE id='clin_CAN_5_1.1';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_2_id%%' WHERE id='clin_CAN_5_1.2';
UPDATE menus SET use_link='/ClinicalAnnotation/Participants/profile/%%Participant.id%%' WHERE id='clin_CAN_6';
UPDATE menus SET use_link='/ClinicalAnnotation/ClinicalCollectionLinks/listall/%%Participant.id%%' WHERE id='clin_CAN_67';
UPDATE menus SET use_link='/ClinicalAnnotation/ReproductiveHistories/listall/%%Participant.id%%' WHERE id='clin_CAN_68';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Protocol/%%Participant.id%%' WHERE id='clin_CAN_69';
UPDATE menus SET use_link='/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%' WHERE id='clin_CAN_75';
UPDATE menus SET use_link='/ClinicalAnnotation/TreatmentMasters/detail/%%Participant.id%%/%%TreatmentMaster.id%%' WHERE id='clin_CAN_79';
UPDATE menus SET use_link='/ClinicalAnnotation/TreatmentExtends/listall/%%Participant.id%%/%%TreatmentMaster.id%%' WHERE id='clin_CAN_80';
UPDATE menus SET use_link='/ClinicalAnnotation/ConsentMasters/listall/%%Participant.id%%' WHERE id='clin_CAN_9';
UPDATE menus SET use_link='/Tools/Template/index' WHERE id='collection_template';
UPDATE menus SET use_link='/Menus/tools/' WHERE id='core_CAN_33';
UPDATE menus SET use_link='/Administrate/Groups' WHERE id='core_CAN_41';
UPDATE menus SET use_link='/Administrate/Groups/index' WHERE id='core_CAN_41_1';
UPDATE menus SET use_link='/Administrate/Groups/detail/%%Group.id%%/' WHERE id='core_CAN_41_1_1';
UPDATE menus SET use_link='/Administrate/Permissions/tree/%%Group.id%%/' WHERE id='core_CAN_41_1_2';
UPDATE menus SET use_link='/Administrate/AdminUsers/listall/%%Group.id%%/' WHERE id='core_CAN_41_1_3';
UPDATE menus SET use_link='/Administrate/AdminUsers/detail/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_1';
UPDATE menus SET use_link='/Administrate/Preferences/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_2';
UPDATE menus SET use_link='/Administrate/Passwords/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_3';
UPDATE menus SET use_link='/Administrate/UserLogs/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_4';
UPDATE menus SET use_link='/Administrate/Announcements/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_5';
UPDATE menus SET use_link='/Administrate/Banks/index' WHERE id='core_CAN_41_2';
UPDATE menus SET use_link='/Administrate/Banks/detail/%%Bank.id%%/' WHERE id='core_CAN_41_2_1';
UPDATE menus SET use_link='/Administrate/Announcements/index/%%Bank.id%%/' WHERE id='core_CAN_41_2_2';
UPDATE menus SET use_link='/Administrate/Dropdowns/index' WHERE id='core_CAN_41_3';
UPDATE menus SET use_link='/Administrate/MiscIdentifiers/index' WHERE id='core_CAN_41_4';
UPDATE menus SET use_link='/Administrate/AdminUsers/search/' WHERE id='core_CAN_41_5';
UPDATE menus SET use_link='/Customize/Preferences/index/' WHERE id='core_CAN_42';
UPDATE menus SET use_link='/Administrate/Versions/detail/' WHERE id='core_CAN_70';
UPDATE menus SET use_link='/Administrate/Menus/index/' WHERE id='core_CAN_71';
UPDATE menus SET use_link='/Administrate/Structures/index/' WHERE id='core_CAN_72';
UPDATE menus SET use_link='/Administrate/Structures/detail/%%Structure.id%%' WHERE id='core_CAN_75';
UPDATE menus SET use_link='/Administrate/Structure_formats/listall/%%Structure.id%%' WHERE id='core_CAN_76';
UPDATE menus SET use_link='/Customize/Profiles/index/' WHERE id='core_CAN_84';
UPDATE menus SET use_link='/Customize/Preferences/index/' WHERE id='core_CAN_85';
UPDATE menus SET use_link='/Customize/Passwords/index/' WHERE id='core_CAN_93';
UPDATE menus SET use_link='/Customize/Announcements/index/' WHERE id='core_CAN_97';
UPDATE menus SET use_link='/Drug/Drugs/search/' WHERE id='drug_CAN_96';
UPDATE menus SET use_link='/Drug/Drugs/etail/%%Drug.id%%' WHERE id='drug_CAN_97';
UPDATE menus SET use_link='/InventoryManagement/Collections/search' WHERE id='inv_CAN';
UPDATE menus SET use_link='/InventoryManagement/Collections/detail/%%Collection.id%%' WHERE id='inv_CAN_1';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/contentTreeView/%%Collection.id%%' WHERE id='inv_CAN_21';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_221';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_222';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2221';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2222';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%' WHERE id='inv_CAN_22231';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/' WHERE id='inv_CAN_22233';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/listAll/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2224';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%' WHERE id='inv_CAN_22241';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' WHERE id='inv_CAN_2231';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' WHERE id='inv_CAN_2233';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_224';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%' WHERE id='inv_CAN_2241';
UPDATE menus SET use_link='/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_225';
UPDATE menus SET use_link='/underdevelopment/' WHERE id='inv_CAN_3';
UPDATE menus SET use_link='/Menus' WHERE id='MAIN_MENU_1';
UPDATE menus SET use_link='/Users/logout' WHERE id='MAIN_MENU_2';
UPDATE menus SET use_link='/Material/materials/index/' WHERE id='mat_CAN_01';
UPDATE menus SET use_link='/Material/materials/detail/%%Material.id%%' WHERE id='mat_CAN_02';
UPDATE menus SET use_link='/Order/Orders/search/' WHERE id='ord_CAN_101';
UPDATE menus SET use_link='/Order/Orders/detail/%%Order.id%%/' WHERE id='ord_CAN_113';
UPDATE menus SET use_link='/Order/OrderLines/listall/%%Order.id%%/' WHERE id='ord_CAN_114';
UPDATE menus SET use_link='/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/' WHERE id='ord_CAN_115';
UPDATE menus SET use_link='/Order/shipments/listall/%%Order.id%%/' WHERE id='ord_CAN_116';
UPDATE menus SET use_link='/Order/OrderItems/listall/%%Order.id%%/%%OrderLine.id%%/' WHERE id='ord_CAN_117';
UPDATE menus SET use_link='/Order/OrderItems/detail/%%Order.id%%/%%OrderLine.id%%/%%OrderItem.id%%/' WHERE id='ord_CAN_118';
UPDATE menus SET use_link='/Order/Shipments/detail/%%Order.id%%/%%Shipment.id%%/' WHERE id='ord_CAN_119';
UPDATE menus SET use_link='/LabBook/LabBookMasters/search/' WHERE id='procd_CAN_01';
UPDATE menus SET use_link='/LabBook/LabBookMasters/detail/%%LabBookMaster.id%%' WHERE id='procd_CAN_02';
UPDATE menus SET use_link='/Protocol/ProtocolMasters/search/' WHERE id='proto_CAN_37';
UPDATE menus SET use_link='/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%' WHERE id='proto_CAN_82';
UPDATE menus SET use_link='/Protocol/ProtocolExtends/listall/%%ProtocolMaster.id%%' WHERE id='proto_CAN_83';
UPDATE menus SET use_link='/Provider/Providers/detail/%%Provider.id%%/' WHERE id='prov_CAN_10';
UPDATE menus SET use_link='/Menus/datamart/' WHERE id='qry-CAN-1';
UPDATE menus SET use_link='/Datamart/Browser/index' WHERE id='qry-CAN-1-1';
UPDATE menus SET use_link='/Datamart/Reports/index' WHERE id='qry-CAN-1-2';
UPDATE menus SET use_link='/Datamart/Adhocs/index/' WHERE id='qry-CAN-2';
UPDATE menus SET use_link='/Datamart/BatchSets/index/' WHERE id='qry-CAN-3';
UPDATE menus SET use_link='/RtbForm/RtbForms/index/' WHERE id='rtbf_CAN_01';
UPDATE menus SET use_link='/RtbForm/RtbForms/profile/%%Rtbform.id%%' WHERE id='rtbf_CAN_02';
UPDATE menus SET use_link='/Sop/SopMasters/listall/' WHERE id='sop_CAN_01';
UPDATE menus SET use_link='/Sop/SopMasters/detail/%%SopMaster.id%%/' WHERE id='sop_CAN_03';
UPDATE menus SET use_link='/Sop/SopExtends/listall/%%SopMaster.id%%/' WHERE id='sop_CAN_04';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/search/' WHERE id='sto_CAN_01';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%' WHERE id='sto_CAN_02';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/storageLayout/%%StorageMaster.id%%' WHERE id='sto_CAN_05';
UPDATE menus SET use_link='/StorageLayout/StorageCoordinates/listAll/%%StorageMaster.id%%' WHERE id='sto_CAN_06';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/0/TMA' WHERE id='sto_CAN_07';
UPDATE menus SET use_link='/StorageLayout/TmaSlides/listAll/%%StorageMaster.id%%' WHERE id='sto_CAN_08';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%' WHERE id='sto_CAN_10';
UPDATE menus SET use_link='/Study/StudySummaries/search/' WHERE id='tool_CAN_100';
UPDATE menus SET use_link='/Study/StudySummaries/detail/%%StudySummary.id%%/' WHERE id='tool_CAN_104';
UPDATE menus SET use_link='/Study/StudyContacts/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_105';
UPDATE menus SET use_link='/Study/StudyInvestigators/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_106';
UPDATE menus SET use_link='/Study/StudyReviews/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_107';
UPDATE menus SET use_link='/Study/StudyEthicsBoards/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_108';
UPDATE menus SET use_link='/Study/StudyFundings/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_109';
UPDATE menus SET use_link='/Study/StudyResults/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_110';
UPDATE menus SET use_link='/Study/StudyRelated/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_112';
UPDATE menus SET use_link='/Provider/Providers/index/' WHERE id='tool_CAN_43';

UPDATE structure_fields SET plugin='Administrate' WHERE plugin='administrate';
UPDATE structure_fields SET plugin='ClinicalAnnotation' WHERE plugin='clinicalannotation';
UPDATE structure_fields SET plugin='CodingIcd' WHERE plugin='codingicd';
UPDATE structure_fields SET plugin='Customize' WHERE plugin='customize';
UPDATE structure_fields SET plugin='Datamart' WHERE plugin='datamart';
UPDATE structure_fields SET plugin='Drug' WHERE plugin='Drug';
UPDATE structure_fields SET plugin='InventoryManagement' WHERE plugin='inventorymanagement';
UPDATE structure_fields SET plugin='LabBook' WHERE plugin='labbook';
UPDATE structure_fields SET plugin='Material' WHERE plugin='material';
UPDATE structure_fields SET plugin='Order' WHERE plugin='order';
UPDATE structure_fields SET plugin='Protocol' WHERE plugin='protocol';
UPDATE structure_fields SET plugin='RtbForm' WHERE plugin='rtbform';
UPDATE structure_fields SET plugin='Sop' WHERE plugin='sop';
UPDATE structure_fields SET plugin='StorageLayout' WHERE plugin='storagelayout';
UPDATE structure_fields SET plugin='Study' WHERE plugin='study';
UPDATE structure_fields SET plugin='Tools' WHERE plugin='Tools';

UPDATE structure_value_domains SET source='InventoryManagement.AliquotControl::getAliquotTypePermissibleValues' WHERE id=5;
UPDATE structure_value_domains SET source='ClinicalAnnotation.TreatmentControl::getDiseaseSitePermissibleValues' WHERE id=101;
UPDATE structure_value_domains SET source='Protocol.ProtocolControl::getProtocolTypePermissibleValues' WHERE id=102;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''quality control tools'')' WHERE id=104;
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValues' WHERE id=141;
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSampleTypePermissibleValues' WHERE id=144;
UPDATE structure_value_domains SET source='StorageLayout.StorageControl::getStorageTypePermissibleValues' WHERE id=146;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''specimen collection sites'')' WHERE id=173;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''laboratory staff'')' WHERE id=174;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''specimen supplier departments'')' WHERE id=175;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''laboratory sites'')' WHERE id=179;
UPDATE structure_value_domains SET source='ClinicalAnnotation.Icd10::permissibleValues' WHERE id=187;
UPDATE structure_value_domains SET source='Administrate.Bank::getBankPermissibleValues' WHERE id=191;
UPDATE structure_value_domains SET source='Drug.Drug::getDrugPermissibleValues' WHERE id=192;
UPDATE structure_value_domains SET source='Protocol.ProtocolControl::getProtocolTumourGroupPermissibleValues' WHERE id=193;
UPDATE structure_value_domains SET source='StorageLayout.StorageMaster::getParentStoragePermissibleValues' WHERE id=194;
UPDATE structure_value_domains SET source='Sop.SopMaster::getTmaBlockSopPermissibleValues' WHERE id=195;
UPDATE structure_value_domains SET source='Sop.SopMaster::getTmaSlideSopPermissibleValues' WHERE id=196;
UPDATE structure_value_domains SET source='Study.StudySummary::getStudyPermissibleValues' WHERE id=197;
UPDATE structure_value_domains SET source='InventoryManagement.AliquotControl::getAliquotTypePermissibleValuesFromId' WHERE id=198;
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSampleTypePermissibleValuesFromId' WHERE id=199;
UPDATE structure_value_domains SET source='InventoryManagement.AliquotControl::getSampleAliquotTypesPermissibleValues' WHERE id=200;
UPDATE structure_value_domains SET source='Order.Shipment::getShipmentPermissibleValues' WHERE id=201;
UPDATE structure_value_domains SET source='Sop.SopMaster::getCollectionSopPermissibleValues' WHERE id=202;
UPDATE structure_value_domains SET source='Sop.SopMaster::getSampleSopPermissibleValues' WHERE id=203;
UPDATE structure_value_domains SET source='InventoryManagement.SampleDetail::getTissueSourcePermissibleValues' WHERE id=204;
UPDATE structure_value_domains SET source='Sop.SopMaster::getAliquotSopPermissibleValues' WHERE id=205;
UPDATE structure_value_domains SET source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValues' WHERE id=206;
UPDATE structure_value_domains SET source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNameAbrevPermissibleValues' WHERE id=207;
UPDATE structure_value_domains SET source='ClinicalAnnotation.ConsentControl::getConsentTypePermissibleValuesFromId' WHERE id=208;
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisControl::getDiagnosisTypePermissibleValuesFromId' WHERE id=209;
UPDATE structure_value_domains SET source='ClinicalAnnotation.EventControl::getEventDiseaseSitePermissibleValues' WHERE id=210;
UPDATE structure_value_domains SET source='ClinicalAnnotation.EventControl::getEventTypePermissibleValues' WHERE id=211;
UPDATE structure_value_domains SET source='ClinicalAnnotation.TreatmentControl::getMethodPermissibleValues' WHERE id=212;
UPDATE structure_value_domains SET source='Protocol.ProtocolMaster::getProtocolPermissibleValuesFromId' WHERE id=213;
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisMaster::getMorphologyValues' WHERE id=214;
UPDATE structure_value_domains SET source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValuesFromId' WHERE id=216;
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValuesFromId' WHERE id=217;
UPDATE structure_value_domains SET source='InventoryManagement.SpecimenReviewControl::getSpecimenTypePermissibleValues' WHERE id=220;
UPDATE structure_value_domains SET source='InventoryManagement.SpecimenReviewControl::getReviewTypePermissibleValues' WHERE id=221;
UPDATE structure_value_domains SET source='InventoryManagement.AliquotReviewMaster::getAliquotListForReview' WHERE id=223;
UPDATE structure_value_domains SET source='User::getUsersList' WHERE id=224;
UPDATE structure_value_domains SET source='Datamart.Batchset::getActionsDropdown' WHERE id=329;
UPDATE structure_value_domains SET source='InventoryManagement.SampleMaster::getParentSampleDropdown' WHERE id=330;
UPDATE structure_value_domains SET source='StorageLayout.StorageMaster::getStoragesDropdown' WHERE id=331;
UPDATE structure_value_domains SET source='InventoryManagement.AliquotMaster::getRealiquotDropdown' WHERE id=333;
UPDATE structure_value_domains SET source='InventoryManagement.SampleMaster::getDerivativesDropdown' WHERE id=335;
UPDATE structure_value_domains SET source='LabBook.LabBookControl::getLabBookTypePermissibleValuesFromId' WHERE id=336;
UPDATE structure_value_domains SET source='LabBook.LabBookMaster::getLabBookPermissibleValuesFromId' WHERE id=337;
UPDATE structure_value_domains SET source='Datamart.DatamartStructure::getDisplayNameFromId' WHERE id=339;
UPDATE structure_value_domains SET source='Sop.SopControl::getTypePermissibleValues' WHERE id=344;
UPDATE structure_value_domains SET source='Sop.SopControl::getGroupPermissibleValues' WHERE id=345;
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisControl::getTypePermissibleValues' WHERE id=346;
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisControl::getCategoryPermissibleValues' WHERE id=347;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''sop versions'')' WHERE id=348;
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''consent form versions'')' WHERE id=352;
UPDATE structure_value_domains SET source='ClinicalAnnotation.EventControl::getEventGroupPermissibleValues' WHERE id=354;
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getParentSampleTypePermissibleValues' WHERE id=355;
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getParentSampleTypePermissibleValuesFromId' WHERE id=356;

UPDATE menus SET use_summary=REPLACE(use_summary, 'Inventorymanagement', 'InventoryManagement'); 
UPDATE menus SET use_summary=REPLACE(use_summary, 'Storagelayout', 'StorageLayout'); 
UPDATE menus SET use_summary=REPLACE(use_summary, 'Clinicalannotation', 'ClinicalAnnotation'); 

UPDATE datamart_structures SET plugin='InventoryManagement' WHERE plugin='Inventorymanagement';
UPDATE datamart_structures SET plugin='ClinicalAnnotation' WHERE plugin='ClinicalAnnotation';
UPDATE datamart_structures SET plugin='StorageLayout' WHERE plugin='StorageLayout';
UPDATE datamart_structures SET index_link=REPLACE(index_link, 'inventorymanagement', 'InventoryManagement'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, 'storagelayout', 'StorageLayout'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, 'clinicalannotation', 'ClinicalAnnotation'); 

UPDATE structure_fields SET setting=REPLACE(setting, 'codingicd', 'CodingIcd') WHERE setting like '%codingicd%';
UPDATE structure_fields SET setting=REPLACE(setting, '/inventorymanagement/', '/InventoryManagement/') WHERE setting like '%/inventorymanagement/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/aliquot_masters/', '/AliquotMasters/') WHERE setting like '%/aliquot_masters/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/labbook/', '/LabBook/') WHERE setting like '%/labbook/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/lab_book_masters/', '/LabBookMasters/') WHERE setting like '%/lab_book_masters/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/storagelayout/', '/StorageLayout/') WHERE setting like '%/storagelayout/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/storage_masters/', '/StorageMasters/') WHERE setting like '%/storagemasters/%';

UPDATE datamart_adhoc SET plugin='ClinicalAnnotation' WHERE plugin like 'clinicalannotation';
UPDATE datamart_adhoc SET plugin='InventoryManagement' WHERE plugin like 'inventorymanagement';
UPDATE datamart_adhoc SET plugin='StorageLayout' WHERE plugin like 'storagelayout';
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/clinicalannotation/', '/ClinicalAnnotation/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/inventorymanagement/', '/InventoryManagement/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/storagelayout/', '/StorageLayout/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/participants/', '/Participants/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/aliquot_masters/', '/AliquotMasters/');

UPDATE menus SET use_link='/Drug/Drugs/detail/%%Drug.id%%' WHERE id='drug_CAN_97';

ALTER TABLE collections
 ADD COLUMN participant_id INT DEFAULT NULL AFTER collection_notes,
 ADD COLUMN diagnosis_master_id INT DEFAULT NULL AFTER participant_id,
 ADD COLUMN consent_master_id INT DEFAULT NULL AFTER diagnosis_master_id,
 ADD FOREIGN KEY (participant_id) REFERENCES participants(id),
 ADD FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id),
 ADD FOREIGN KEY (consent_master_id) REFERENCES consent_masters(id);
ALTER TABLE collections_revs
 ADD COLUMN participant_id INT DEFAULT NULL AFTER collection_notes,
 ADD COLUMN diagnosis_master_id INT DEFAULT NULL AFTER participant_id,
 ADD COLUMN consent_master_id INT DEFAULT NULL AFTER diagnosis_master_id;
 
UPDATE collections AS c
INNER JOIN clinical_collection_links AS ccl ON c.id=ccl.collection_id
SET c.participant_id=ccl.participant_id, c.diagnosis_master_id=ccl.diagnosis_master_id, c.consent_master_id=ccl.consent_master_id;
INSERT INTO collections_revs (id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property, collection_notes, participant_id, diagnosis_master_id, modified_by, version_created)
(SELECT id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property, collection_notes, participant_id, diagnosis_master_id, modified_by, NOW() FROM collections);


CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,`col`.`participant_id` AS `participant_id`,`col`.`diagnosis_master_id` AS `diagnosis_master_id`,`col`.`consent_master_id` AS `consent_master_id`,`part`.`participant_identifier` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,`col`.`created` AS `created` from `collections` `col` 
left join `participants` `part` on `col`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1 
left join `banks` on `col`.`bank_id` = `banks`.`id` and `banks`.`deleted` <> 1 where `col`.`deleted` <> 1;