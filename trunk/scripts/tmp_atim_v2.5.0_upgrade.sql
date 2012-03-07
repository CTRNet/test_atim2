INSERT INTO `versions` (version_number, date_installed, build_number) 
VALUES('2.5.0', NOW(),'> 4043');

REPLACE INTO i18n (id, en, fr) VALUES
('reserved for study','Reserved For Study/Project','Réservé pour une Étude/Projet'),
('identifier name','Identifier Name', "Nom d'identifiant"),
('click here to access it', "Click here to access it.", "Cliquez ici pour y accéder."),
("last modification", "Last Modification", "Dernière Modification"),
("help_part_last_mod", "The date at which the last participant clinical related data was created or modified, excluding .", "Date de la plus récente création ou modification de données cliniques liées au participant."),
("add identifier", "Add identifier", "Ajouter identifiant"),
("batch edit", "Batch edit", "Modification en lot"),
("you need to at least update a value", "You need to at least update a value.", "Vous devez mettre à jour au moins une valeur."),
("you are about to edit %d element(s)", "You are about to edit %d element(s).", "Vous êtes sur le point de mettre %s élément(s) à jour."),
("collection details", "Collection details", "Détails de la collection"),
("collection content", "Collection content", "Contenu de la collection"),
("empty spaces", "Empty Spaces", "Emplacements Vides"),
("keep entries with the most recent start date per participant",
 "Keep entries with the most recent start date per participant",
 "Conserver les entrées avec la date de départ la plus récente par participant"),
("keep entries with the oldest start date per participant",
 "Keep entries with the oldest start date per participant",
 "Conserver les entrées avec la date de départ la plus ancienne par participant"),
("keep entries with the most recent date per participant",
 "Keep entries with the most recent date per participant",
 "Conserver les entrées avec la date la plus récente par participant"),
("keep entries with the oldest date per participant",
 "Keep entries with the oldest date per participant",
 "Conserver les entrées avec la  date la plus ancienne par participant"),
("a special parameter could not be applied because relations between %s and its children node are shared",
 "A special paremeter could not be applied because relations between %s and its children node are shared.",
 "Un paramètre spécial n'a pas pu être appliqué car les relations entre %s et son noeud enfant sont partagées."),
("core_newpassword", "New password", "Nouveau mot de passe"),
("core_confirmpassword", "Confirm new password", "Confirmez les nouveau mot de passe"),
("unsaved browsing trees that are automatically deleted when there are more than %d",
 "Unsaved browsing trees that are automatically deleted when there are more than %d.",
 "Arbres de navigation non enregistrés qui sont supprimés automatiquement lorsqu'il y en a plus de %d."),
("temporary batch sets", "Temporary batch sets", "Lots de données temporaires"),
("unsaved batch sets that are automatically deleted when there are more than %d",
 "Unsaved batch sets that are automatically deleted when there are more than %d.",
 "Lots de données non enregistrés qui sont supprimés automatiquement lorsqu'il y en a plus de %d."),
("saved batch sets", "Saved batch sets", "Lots de données enregistrés");   

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
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/inventorymanagement/', '/InventoryManagement/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/storagelayout/', '/StorageLayout/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/clinicalannotation/', '/ClinicalAnnotation/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/aliquot_masters/', '/AliquotMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/collections/', '/Collections/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/storage_masters/', '/StorageMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/participants/', '/Participants/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/consent_masters/', '/ConsentMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/diagnosis_masters/', '/DiagnosisMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/treatment_masters/', '/TreatmentMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/family_histories/', '/FamilyHistory/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/participant_messages/', '/ParicipantMessages/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/quality_ctrls/', '/QualityCtrls/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/event_masters/', '/EventMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/specimen_reviews/', '/SpecimenReviews/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/order/', '/Order/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/order_items/', '/OrderItems/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/shipments/', '/Shipments/'); 

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


DROP VIEW view_collections;
CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,`col`.`participant_id` AS `participant_id`,`col`.`diagnosis_master_id` AS `diagnosis_master_id`,`col`.`consent_master_id` AS `consent_master_id`,`part`.`participant_identifier` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,`col`.`created` AS `created` from `collections` `col` 
left join `participants` `part` on `col`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1 
left join `banks` on `col`.`bank_id` = `banks`.`id` and `banks`.`deleted` <> 1 where `col`.`deleted` <> 1;

ALTER TABLE specimen_details MODIFY sample_master_id INT NOT NULL;
ALTER TABLE specimen_details_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE derivative_details MODIFY sample_master_id INT NOT NULL;
ALTER TABLE derivative_details_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE ad_tubes MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tubes_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_bags MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_bags_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_blocks MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_blocks_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_cores MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_cores_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_slides MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_slides_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_gel_matrices MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_gel_matrices_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_cores MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_cores_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_slides MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_slides_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tubes_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_whatman_papers MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_whatman_papers_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE aliquot_internal_uses MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE aliquot_internal_uses_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ar_breast_tissue_slides MODIFY aliquot_review_master_id INT NOT NULL;
ALTER TABLE ar_breast_tissue_slides_revs MODIFY aliquot_review_master_id INT NOT NULL;
ALTER TABLE derivative_details_revs MODIFY sample_master_id INT NOT NULL,
 MODIFY lab_book_master_id INT NULL;
ALTER TABLE ed_all_adverse_events_adverse_events MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_adverse_events_adverse_events_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_followups MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_followups_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_presentations MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_presentations_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_comorbidities MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_comorbidities_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_lifestyle_smokings MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_lifestyle_smokings_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_protocol_followups MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_protocol_followups_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_study_researches MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_study_researches_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_lab_pathologies MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_lab_pathologies_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_screening_mammograms MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_screening_mammograms_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE lbd_dna_extractions MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE lbd_dna_extractions_revs MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE lbd_slide_creations MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE lbd_slide_creations_revs MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE order_items MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE order_items_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE pd_chemos MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pd_chemos_revs MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pd_surgeries MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pd_surgeries_revs MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pe_chemos MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pe_chemos_revs MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE quality_ctrls MODIFY sample_master_id INT NOT NULL;
ALTER TABLE quality_ctrls_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE realiquotings MODIFY parent_aliquot_master_id INT NOT NULL;
ALTER TABLE realiquotings MODIFY child_aliquot_master_id INT NOT NULL;
ALTER TABLE realiquotings_revs MODIFY parent_aliquot_master_id INT NOT NULL;
ALTER TABLE realiquotings_revs MODIFY child_aliquot_master_id INT NOT NULL;
ALTER TABLE sd_der_amp_rnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_amp_rnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_b_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_b_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_blood_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_blood_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_bone_marrow_susps MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_bone_marrow_susps_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cdnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cdnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_cultures MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_cultures_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_lysates MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_lysates_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_dnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_dnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_no_b_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_no_b_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pbmcs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pbmcs_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_plasmas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_plasmas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_proteins MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_proteins_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_rnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_rnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_serums MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_serums_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_lysates MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_lysates_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_susps MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_susps_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cents MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cents_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cons MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cons_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_ascites MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_ascites_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bloods MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bloods_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bone_marrows MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bone_marrows_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_cystic_fluids MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_cystic_fluids_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pericardial_fluids MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pericardial_fluids_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_peritoneal_washes MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_peritoneal_washes_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pleural_fluids MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pleural_fluids_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_tissues MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_tissues_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_urines MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_urines_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sopd_general_alls MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sopd_general_alls_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sopd_inventory_alls MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sopd_inventory_alls_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_general_all MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_general_all_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_inventory_all MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_inventory_all_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE source_aliquots MODIFY sample_master_id INT NOT NULL;
ALTER TABLE source_aliquots MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE source_aliquots_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE source_aliquots_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE specimen_details_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE specimen_review_masters MODIFY sample_master_id INT NOT NULL;
ALTER TABLE specimen_review_masters_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE spr_breast_cancer_types MODIFY specimen_review_master_id INT NOT NULL;
ALTER TABLE spr_breast_cancer_types_revs MODIFY specimen_review_master_id INT NOT NULL;
ALTER TABLE std_boxs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_boxs_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_cupboards MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_cupboards_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_freezers MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_freezers_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_fridges MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_fridges_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_incubators MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_incubators_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_nitro_locates MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_nitro_locates_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_racks MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_racks_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_rooms MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_rooms_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_shelfs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_shelfs_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks MODIFY sop_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE storage_coordinates MODIFY storage_master_id INT NOT NULL;
ALTER TABLE storage_coordinates_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE txe_radiations MODIFY tx_master_id INT NOT NULL;
ALTER TABLE txe_radiations_revs MODIFY tx_master_id INT NOT NULL;
 
CREATE TABLE system_vars(
 k VARCHAR(50) NOT NULL PRIMARY KEY,
 v VARCHAR(50) NOT NULL
)Engine=InnoDb;
INSERT INTO system_vars (k, v) VALUES
('permission_timestamp', 0);

ALTER TABLE permissions_presets_revs
 DROP KEY name;
 
UPDATE structure_fields SET  `setting`='noCtrl=' WHERE model='0' AND tablename='' AND field='report_date_range_period' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='date_range_period');
UPDATE structure_fields SET  `setting`='noCtrl=' WHERE model='0' AND tablename='' AND field='report_spent_time_display_mode' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='spent_time_display_mode');
UPDATE structure_fields SET setting='' WHERE setting='accuracy';

UPDATE datamart_structure_functions SET link=REPLACE(link, '/clinicalannotation/', '/ClinicalAnnotation/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/inventorymanagement/', '/InventoryManagement/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/aliquot_masters/', '/AliquotMasters/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/sample_masters/', '/SampleMasters/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/order/', '/Order/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/order_items/', '/OrderItems/');
UPDATE datamart_structure_functions SET link=REPLACE(link, 'datamart/reports/', '/Datamart/Reports/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/quality_ctrls/', '/QualityCtrls/');

ALTER TABLE misc_identifiers
 ADD COLUMN flag_unique TINYINT DEFAULT NULL,
 ADD UNIQUE KEY(misc_identifier_control_id, identifier_value, flag_unique);
ALTER TABLE misc_identifiers_revs
 ADD COLUMN flag_unique TINYINT DEFAULT NULL;
ALTER TABLE misc_identifier_controls
 ADD COLUMN flag_unique BOOLEAN NOT NULL DEFAULT true;
UPDATE misc_identifiers mi
INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id
SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
 
ALTER TABLE participants 
 ADD COLUMN last_modification DATETIME NOT NULL DEFAULT '2001-01-01 00:00:00' AFTER last_chart_checked_date_accuracy,
 ADD COLUMN last_modification_ds_id INT UNSIGNED NOT NULL DEFAULT 1 AFTER last_modification,
 ADD FOREIGN KEY (last_modification_ds_id) REFERENCES datamart_structures(id);
ALTER TABLE participants_revs 
 ADD COLUMN last_modification DATETIME NOT NULL DEFAULT '2001-01-01 00:00:00' AFTER last_chart_checked_date_accuracy,
 ADD COLUMN last_modification_ds_is INT UNSIGNED NOT NULL DEFAULT 1 AFTER last_modification;
 
ALTER TABLE datamart_structures
 DROP COLUMN use_key,
 DROP COLUMN control_model,
 DROP COLUMN control_field;
 
INSERT INTO datamart_structures(plugin, model, structure_id, display_name, control_master_model, index_link, batch_edit_link) VALUES
('ClinicalAnnotation', 'ParticipantContact', 30, 'participant contacts', '', '/ClinicalAnnotation/ParticipantContacts/detail/%%ParticipantContact.participant_id%%/%%ParticipantContact.id%%', ''), 
('ClinicalAnnotation', 'ReproductiveHistory', 110, 'reproductive histories', '', '/ClinicalAnnotation/ReproductiveHistories/detail/%%ReproductiveHistory.participant_id%%/%%ReproductiveHistory.id%%', '');

INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
(18, 4, 1, 1, 'ParticipantContact.participant_id'), 
(19, 4, 1, 1, 'ReproductiveHistory.participant_id');

UPDATE participants SET last_modification=modified, last_modification_ds_id=4; 
UPDATE participants AS t1 INNER JOIN misc_identifiers AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 6); 
UPDATE participants AS t1 INNER JOIN consent_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 8); 
UPDATE participants AS t1 INNER JOIN diagnosis_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 9); 
UPDATE participants AS t1 INNER JOIN treatment_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 10); 
UPDATE participants AS t1 INNER JOIN family_histories AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 11); 
UPDATE participants AS t1 INNER JOIN participant_messages AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 12); 
UPDATE participants AS t1 INNER JOIN event_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 14); 
UPDATE participants AS t1 INNER JOIN participant_contacts AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 18); 
UPDATE participants AS t1 INNER JOIN reproductive_histories AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 19); 

ALTER TABLE participants 
 MODIFY last_modification DATETIME NOT NULL;
ALTER TABLE participants_revs 
 MODIFY last_modification DATETIME NOT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'last_modification', 'datetime',  NULL , '0', '', '', 'help_part_last_mod', 'last modification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_part_last_mod' AND `language_label`='last modification' AND `language_tag`=''), '3', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

#disable identifiers menu
UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_24');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-118' AND `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `language_label`='identifier abrv' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='new_bank_participant_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-118' AND `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `language_label`='identifier abrv' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_fields WHERE (`public_identifier`='DE-118' AND `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `language_label`='identifier abrv' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE field='misc_identifier_name' AND structure_value_domain IS NOT NULL) WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='identifier_name' AND model='MiscIdentifier');
DELETE FROM structure_fields WHERE field='identifier_name' AND model='MiscIdentifier';

UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_2222');
UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_22233');

UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
((SELECT id FROM datamart_structures WHERE model='ViewAliquot'), 'edit', 'InventoryManagement/AliquotMasters/editInBatch/', 1);

UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_site' AND model='DerivativeDetail' AND tablename='derivative_details') WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_site' AND model='DerivativeDetail' AND tablename='');
DELETE FROM structure_fields WHERE field='creation_site' AND model='DerivativeDetail' AND tablename='';
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_by' AND model='DerivativeDetail' AND tablename='derivative_details') WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_by' AND model='DerivativeDetail' AND tablename='');
DELETE FROM structure_fields WHERE field='creation_by' AND model='DerivativeDetail' AND tablename='';
UPDATE structure_fields SET tablename='derivative_details' WHERE model='DerivativeDetail';

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_21');
UPDATE menus SET parent_id='inv_CAN_1' WHERE parent_id='inv_CAN_21';

INSERT INTO structures(`alias`) VALUES ('storage_w_spaces');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', '0', '', 'empty_spaces', 'integer_positive',  NULL , '0', '', '', '', 'empty spaces', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='storage_w_spaces'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='empty_spaces' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='empty spaces' AND `language_tag`=''), '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE storage_controls SET form_alias=CONCAT(form_alias, ',storage_w_spaces') WHERE coord_x_size IS NOT NULL OR coord_y_size IS NOT NULL;

CREATE VIEW view_storage_masters AS SELECT sm.*, IF(coord_x_size IS NULL AND coord_y_size IS NULL, NULL, IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - COUNT(am.id) - COUNT(ts.id) - COUNT(smc.id)) AS empty_spaces FROM storage_masters AS sm
INNER JOIN storage_controls AS sc ON sm.storage_control_id=sc.id
LEFT JOIN aliquot_masters AS am ON am.storage_master_id=sm.id AND am.deleted=0
LEFT JOIN tma_slides AS ts ON ts.storage_master_id=sm.id AND ts.deleted=0
LEFT JOIN storage_masters AS smc ON smc.parent_id=sm.id AND smc.deleted=0
WHERE sm.deleted=0 GROUP BY sm.id;

ALTER TABLE datamart_structures
 ADD COLUMN adv_search_structure_alias VARCHAR(255) DEFAULT NULL AFTER structure_id, 
 ADD FOREIGN KEY (adv_search_structure_alias) REFERENCES structures(alias);
ALTER TABLE datamart_browsing_results
 CHANGE parent_node_id parent_id INT UNSIGNED DEFAULT NULL,
 ADD lft INT UNSIGNED DEFAULT NULL AFTER parent_id,
 ADD rght INT UNSIGNED DEFAULT NULL AFTER lft,
 ADD COLUMN browsing_type VARCHAR(20) NOT NULL DEFAULT '' AFTER raw;

UPDATE datamart_browsing_results SET browsing_type='drilldown' WHERE raw='0';
UPDATE datamart_browsing_results SET browsing_type='direct access' WHERE raw='1' AND LENGTH(serialized_search_params) < 66;
UPDATE datamart_browsing_results SET browsing_type='from batchset' WHERE raw='1' AND parent_id IS NULL AND serialized_search_params IS NULL;
UPDATE datamart_browsing_results SET browsing_type='search' WHERE raw='1';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("adv_coll_datetime", "", "", "");

INSERT INTO structures(`alias`) VALUES ('collections_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', 'view_collections', 'collection_datetime', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') , '0', 'noCtrl=', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='collection_datetime' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime')  AND `flag_confidential`='0' AND `setting`='noCtrl=' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE datamart_structures SET adv_search_structure_alias='collections_adv_search' WHERE model='ViewCollection';

UPDATE datamart_browsing_controls SET use_field=SUBSTR(use_field, LOCATE('.', use_field) + 1);

UPDATE datamart_structures SET index_link='/ClinicalAnnotation/participants/profile/%%MiscIdentifier.participant_id%%' WHERE model='MiscIdentifier';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tx_filter", "", "", "ClinicalAnnotation.TreatmentMaster::getBrowsingFilter");
INSERT INTO structures(`alias`) VALUES ('tx_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tx_filter') , '0', '', '', '', 'filter', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='tx_adv_search'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_filter')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='filter' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE datamart_structures SET adv_search_structure_alias='tx_adv_search' WHERE model='TreatmentMaster'; 
UPDATE structure_fields SET `setting`='noCtrl=' WHERE model='TreatmentMaster' AND tablename='' AND field='browsing_filter' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_filter');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("dx_filter", "", "", "ClinicalAnnotation.DiagnosisMaster::getBrowsingFilter");
INSERT INTO structures(`alias`) VALUES ('dx_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='dx_filter') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_adv_search'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_filter')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE datamart_structures SET adv_search_structure_alias='dx_adv_search' WHERE model='DiagnosisMaster';
UPDATE structure_fields SET `language_label`='filter', `setting`='noCtrl=' WHERE model='DiagnosisMaster' AND tablename='' AND field='browsing_filter' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='dx_filter');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("collection_filter", "", "", "InventoryManagement.Collection::getBrowsingFilter");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='collection_filter') , '0', 'noCtrl=', '', '', 'filter', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_filter')  AND `flag_confidential`='0' AND `setting`='noCtrl=' AND `default`='' AND `language_help`='' AND `language_label`='filter' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='chemo_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='response' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='completed_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='path_num' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_value_domains SET `source`="InventoryManagement.Collection::getBrowsingFilter" WHERE domain_name="collection_filter";
UPDATE structure_value_domains SET `source`="InventoryManagement.Collection::getBrowsingAdvSearch('collection_datetime')" WHERE domain_name="adv_coll_datetime";

CREATE TABLE datamart_saved_browsing_indexes(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL,
 group_id INT NOT NULL,
 sharing_status VARCHAR(50) NOT NULL DEFAULT 'user',
 name VARCHAR(50) NOT NULL DEFAULT '',
 starting_datamart_structure_id INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY (starting_datamart_structure_id) REFERENCES datamart_structures(id)
)Engine=InnoDb;

CREATE TABLE datamart_saved_browsing_steps(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 datamart_saved_browsing_index_id INT UNSIGNED NOT NULL,
 datamart_structure_id INT UNSIGNED NOT NULL,
 datamart_sub_structure_id INT UNSIGNED DEFAULT NULL,
 serialized_search_params TEXT,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY (datamart_saved_browsing_index_id) REFERENCES datamart_saved_browsing_indexes(id),
 FOREIGN KEY (datamart_structure_id) REFERENCES datamart_structures(id)
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('datamart_saved_browsing');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'SavedBrowsingIndex', 'datamart_saved_browsing_indexes', 'name', 'input',  NULL , '0', '', '', '', 'name', ''), 
('Datamart', 'SavedBrowsingIndex', 'datamart_saved_browsing_indexes', 'sharing_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status') , '0', '', '', '', 'status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='sharing_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='sharing_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status')), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), 'isUnique');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status') ,  `default`='user' WHERE model='SavedBrowsingIndex' AND tablename='datamart_saved_browsing_indexes' AND field='sharing_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status');

ALTER TABLE menus
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, use_summary, flag_active) VALUES
('qry-CAN-1-1-1', 'qry-CAN-1-1', 0, 1, 'data browser', '', '/Datamart/Browser/index', '', 1),
('qry-CAN-1-1-2', 'qry-CAN-1-1', 0, 1, 'saved browsing steps', '', '/Datamart/BrowsingSteps/listall', '', 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'DatamartStructure', 'datamart_structures', 'display_name', 'input',  NULL , '0', '', '', '', 'starting element', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='DatamartStructure' AND `tablename`='datamart_structures' AND `field`='display_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='starting element' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE datamart_structures SET control_master_model='StorageMaster' WHERE model='StorageMaster';

UPDATE structure_fields SET  `type`='password' WHERE model='User' AND tablename='users' AND field='new_password' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='password' WHERE model='User' AND tablename='users' AND field='confirm_password' AND `type`='input' AND structure_value_domain  IS NULL ;

ALTER TABLE ad_bags DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_bags_revs DROP COLUMN id;
ALTER TABLE ad_blocks DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_blocks_revs DROP COLUMN id;
ALTER TABLE ad_cell_cores DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_cell_cores_revs DROP COLUMN id;
ALTER TABLE ad_cell_slides DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_cell_slides_revs DROP COLUMN id;
ALTER TABLE ad_gel_matrices DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_gel_matrices_revs DROP COLUMN id;
ALTER TABLE ad_tissue_cores DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_tissue_cores_revs DROP COLUMN id;
ALTER TABLE ad_tissue_slides DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_tissue_slides_revs DROP COLUMN id;
ALTER TABLE ad_tubes DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_tubes_revs DROP COLUMN id;
ALTER TABLE ad_whatman_papers DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_whatman_papers_revs DROP COLUMN id;
ALTER TABLE ar_breast_tissue_slides DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ar_breast_tissue_slides_revs DROP COLUMN id;
ALTER TABLE cd_nationals DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE cd_nationals_revs DROP COLUMN id;
ALTER TABLE derivative_details DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE derivative_details_revs DROP COLUMN id;
ALTER TABLE dxd_bloods DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_bloods_revs DROP COLUMN id;
ALTER TABLE dxd_primaries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_primaries_revs DROP COLUMN id;
ALTER TABLE dxd_progressions DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_progressions_revs DROP COLUMN id;
ALTER TABLE dxd_recurrences DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_recurrences_revs DROP COLUMN id;
ALTER TABLE dxd_remissions DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_remissions_revs DROP COLUMN id;
ALTER TABLE dxd_secondaries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_secondaries_revs DROP COLUMN id;
ALTER TABLE dxd_tissues DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_tissues_revs DROP COLUMN id;
ALTER TABLE ed_all_adverse_events_adverse_events DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_adverse_events_adverse_events_revs DROP COLUMN id;
ALTER TABLE ed_all_clinical_followups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_clinical_followups_revs DROP COLUMN id;
ALTER TABLE ed_all_clinical_presentations DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_clinical_presentations_revs DROP COLUMN id;
ALTER TABLE ed_all_comorbidities DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_comorbidities_revs DROP COLUMN id;
ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN id;
ALTER TABLE ed_all_protocol_followups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_protocol_followups_revs DROP COLUMN id;
ALTER TABLE ed_all_study_researches DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_study_researches_revs DROP COLUMN id;
ALTER TABLE ed_breast_lab_pathologies DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_breast_lab_pathologies_revs DROP COLUMN id;
ALTER TABLE ed_breast_screening_mammograms DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_breast_screening_mammograms_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_ampullas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_ampullas_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_colon_biopsies DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_colon_biopsies_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_colon_rectum_resections DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_colon_rectum_resections_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_distalexbileducts DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_distalexbileducts_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_gallbladders DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_gallbladders_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_hepatocellular_carcinomas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_hepatocellular_carcinomas_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_intrahepbileducts DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_intrahepbileducts_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_pancreasendos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_pancreasendos_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_pancreasexos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_pancreasexos_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_perihilarbileducts DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_perihilarbileducts_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_smintestines DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_smintestines_revs DROP COLUMN id;
ALTER TABLE pd_chemos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE pd_chemos_revs DROP COLUMN id;
ALTER TABLE pd_surgeries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE pd_surgeries_revs DROP COLUMN id;
ALTER TABLE pe_chemos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE pe_chemos_revs DROP COLUMN id;
ALTER TABLE sd_der_amp_rnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_amp_rnas_revs DROP COLUMN id;
ALTER TABLE sd_der_ascite_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_ascite_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_ascite_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_ascite_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_b_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_b_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_blood_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_blood_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_bone_marrow_susps DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_bone_marrow_susps_revs DROP COLUMN id;
ALTER TABLE sd_der_cdnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cdnas_revs DROP COLUMN id;
ALTER TABLE sd_der_cell_cultures DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cell_cultures_revs DROP COLUMN id;
ALTER TABLE sd_der_cell_lysates DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cell_lysates_revs DROP COLUMN id;
ALTER TABLE sd_der_cystic_fl_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cystic_fl_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_cystic_fl_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cystic_fl_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_dnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_dnas_revs DROP COLUMN id;
ALTER TABLE sd_der_no_b_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_no_b_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pbmcs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pbmcs_revs DROP COLUMN id;
ALTER TABLE sd_der_pericardial_fl_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pericardial_fl_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pericardial_fl_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pericardial_fl_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_plasmas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_plasmas_revs DROP COLUMN id;
ALTER TABLE sd_der_pleural_fl_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pleural_fl_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pleural_fl_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pleural_fl_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_proteins DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_proteins_revs DROP COLUMN id;
ALTER TABLE sd_der_pw_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pw_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pw_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pw_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_rnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_rnas_revs DROP COLUMN id;
ALTER TABLE sd_der_serums DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_serums_revs DROP COLUMN id;
ALTER TABLE sd_der_tiss_lysates DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_tiss_lysates_revs DROP COLUMN id;
ALTER TABLE sd_der_tiss_susps DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_tiss_susps_revs DROP COLUMN id;
ALTER TABLE sd_der_urine_cents DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_urine_cents_revs DROP COLUMN id;
ALTER TABLE sd_der_urine_cons DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_urine_cons_revs DROP COLUMN id;
ALTER TABLE sd_spe_ascites DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_ascites_revs DROP COLUMN id;
ALTER TABLE sd_spe_bloods DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_bloods_revs DROP COLUMN id;
ALTER TABLE sd_spe_bone_marrows DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_bone_marrows_revs DROP COLUMN id;
ALTER TABLE sd_spe_cystic_fluids DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_cystic_fluids_revs DROP COLUMN id;
ALTER TABLE sd_spe_pericardial_fluids DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_pericardial_fluids_revs DROP COLUMN id;
ALTER TABLE sd_spe_peritoneal_washes DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_peritoneal_washes_revs DROP COLUMN id;
ALTER TABLE sd_spe_pleural_fluids DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_pleural_fluids_revs DROP COLUMN id;
ALTER TABLE sd_spe_tissues DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_tissues_revs DROP COLUMN id;
ALTER TABLE sd_spe_urines DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_urines_revs DROP COLUMN id;
ALTER TABLE sopd_general_alls DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sopd_general_alls_revs DROP COLUMN id;
ALTER TABLE sopd_inventory_alls DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sopd_inventory_alls_revs DROP COLUMN id;
ALTER TABLE sope_general_all DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sope_general_all_revs DROP COLUMN id;
ALTER TABLE sope_inventory_all DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sope_inventory_all_revs DROP COLUMN id;
ALTER TABLE specimen_details DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE specimen_details_revs DROP COLUMN id;
ALTER TABLE spr_breast_cancer_types DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE spr_breast_cancer_types_revs DROP COLUMN id;
ALTER TABLE std_boxs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_boxs_revs DROP COLUMN id;
ALTER TABLE std_cupboards DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_cupboards_revs DROP COLUMN id;
ALTER TABLE std_freezers DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_freezers_revs DROP COLUMN id;
ALTER TABLE std_fridges DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_fridges_revs DROP COLUMN id;
ALTER TABLE std_incubators DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_incubators_revs DROP COLUMN id;
ALTER TABLE std_nitro_locates DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_nitro_locates_revs DROP COLUMN id;
ALTER TABLE std_racks DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_racks_revs DROP COLUMN id;
ALTER TABLE std_rooms DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_rooms_revs DROP COLUMN id;
ALTER TABLE std_shelfs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_shelfs_revs DROP COLUMN id;
ALTER TABLE std_tma_blocks DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_tma_blocks_revs DROP COLUMN id;
ALTER TABLE txd_chemos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txd_chemos_revs DROP COLUMN id;
ALTER TABLE txd_radiations DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txd_radiations_revs DROP COLUMN id;
ALTER TABLE txd_surgeries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txd_surgeries_revs DROP COLUMN id;
ALTER TABLE txe_chemos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txe_chemos_revs DROP COLUMN id;
ALTER TABLE txe_radiations DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txe_radiations_revs DROP COLUMN id;
ALTER TABLE txe_surgeries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txe_surgeries_revs DROP COLUMN id;

ALTER TABLE datamart_batch_sets
 MODIFY COLUMN user_id INT NOT NULL,
 MODIFY COLUMN group_id INT NOT NULL,
 ADD FOREIGN KEY (user_id) REFERENCES users(id),
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);

ALTER TABLE datamart_batch_ids
 ADD FOREIGN KEY (set_id) REFERENCES datamart_batch_sets(id);

DROP VIEW view_aliquot_uses;
CREATE VIEW `view_aliquot_uses` AS select concat(`source`.`id`,1) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'sample derivative creation' AS `use_definition`,`samp`.`sample_code` AS `use_code`,'' AS `use_details`,`source`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`der`.`creation_datetime` AS `use_datetime`,`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,`der`.`creation_by` AS `used_by`,`source`.`created` AS `created`,concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,`samp2`.`id` AS `sample_master_id`,`samp2`.`collection_id` AS `collection_id` from (((((`source_aliquots` `source` 
join `sample_masters` `samp` on(((`samp`.`id` = `source`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) 
join `derivative_details` `der` on((`samp`.`id` = `der`.`sample_master_id`))) 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `source`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp2` on(((`samp2`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`source`.`deleted` <> 1) 
union all 
select concat(`realiq`.`id`,2) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'realiquoted to' AS `use_definition`,`child`.`barcode` AS `use_code`,'' AS `use_details`,`realiq`.`parent_used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`realiq`.`realiquoting_datetime` AS `use_datetime`,`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,`realiq`.`realiquoted_by` AS `used_by`,`realiq`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from ((((`realiquotings` `realiq` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `aliquot_masters` `child` on(((`child`.`id` = `realiq`.`child_aliquot_master_id`) and (`child`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`realiq`.`deleted` <> 1) 
union all 
select concat(`qc`.`id`,3) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'quality control' AS `use_definition`,`qc`.`qc_code` AS `use_code`,'' AS `use_details`,`qc`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`qc`.`date` AS `use_datetime`,`qc`.`date_accuracy` AS `use_datetime_accuracy`,`qc`.`run_by` AS `used_by`,`qc`.`created` AS `created`,concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`quality_ctrls` `qc` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `qc`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`qc`.`deleted` <> 1)
union all 
select concat(`item`.`id`,4) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'aliquot shipment' AS `use_definition`,`sh`.`shipment_code` AS `use_code`,'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`sh`.`datetime_shipped` AS `use_datetime`,`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,`sh`.`shipped_by` AS `used_by`,`sh`.`created` AS `created`,concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`order_items` `item` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `item`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `shipments` `sh` on(((`sh`.`id` = `item`.`shipment_id`) and (`sh`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`item`.`deleted` <> 1) 
union all 
select concat(`alr`.`id`,5) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'specimen review' AS `use_definition`,`spr`.`review_code` AS `use_code`,'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`spr`.`review_date` AS `use_datetime`,`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,'' AS `used_by`,`alr`.`created` AS `created`,concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_review_masters` `alr` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `alr`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `specimen_review_masters` `spr` on(((`spr`.`id` = `alr`.`specimen_review_master_id`) and (`spr`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`alr`.`deleted` <> 1) 
union all 
select concat(`aluse`.`id`,6) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'internal use' AS `use_definition`,`aluse`.`use_code` AS `use_code`,`aluse`.`use_details` AS `use_details`,`aluse`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`aluse`.`use_datetime` AS `use_datetime`,`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,`aluse`.`used_by` AS `used_by`,`aluse`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_internal_uses` `aluse` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `aluse`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`aluse`.`deleted` <> 1);


