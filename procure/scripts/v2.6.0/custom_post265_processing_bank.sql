
REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'PROCURE - Processing Site', 'PROCURE - Site de traitement');

-- ================================================================================================================================================================
--
-- CLINICAL ANNOTATION
--
-- ================================================================================================================================================================

SELECT 'Participant.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'Participant.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
-- UNION ALL SELECT 'Participant.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'ConsentMaster.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'ConsentMaster.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'ConsentMaster.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'EventMaster.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'EventMaster.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'EventMaster.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'TreatmentMaster.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'TreatmentMaster.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'TreatmentMaster.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'CLinicalCollectionLink.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'CLinicalCollectionLink.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate';

-- PROFILE

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' ,
`flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_float`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id  NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('participant_identifier', 'created', 'last_modification'));
UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- CONSENT

UPDATE consent_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/ConsentMasters%';

-- EVENT

UPDATE event_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/EventMasters%';

-- TREATMENT

UPDATE treatment_controls SET flag_active = 0;
UPDATE treatment_extend_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/TreatmentMasters%';

-- MISCIDENTIFIERS

UPDATE misc_identifier_controls SET flag_active = 0;
UPDATE misc_identifier_controls SET flag_active = 1 WHERE misc_identifier_name = 'participant study number';
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

-- DATAMART LINKED TO CLINICAL ANNOTATION

UPDATE datamart_structure_functions SET flag_active = '0'
WHERE label = 'number of elements per participant'
AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN (
	'ConsentMaster',
	'DiagnosisMaster',
	'TreatmentMaster',
	'TreatmentExtendMaster',
	'EventMaster',
	'ParticipantContact',
	'ReproductiveHistory',
	'FamilyHistory',
	'ParticipantMessage'));
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN (
	'ConsentMaster',
	'DiagnosisMaster',
	'TreatmentMaster',
	'TreatmentExtendMaster',
	'EventMaster',
	'ParticipantContact',
	'ReproductiveHistory',
	'FamilyHistory',
	'ParticipantMessage'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN (
	'ConsentMaster',
	'DiagnosisMaster',
	'TreatmentMaster',
	'TreatmentExtendMaster',
	'EventMaster',
	'ParticipantContact',
	'ReproductiveHistory',
	'FamilyHistory',
	'ParticipantMessage'));

-- ================================================================================================================================================================
--
-- INVENTORY MANAGEMENT
--
-- ================================================================================================================================================================

SELECT 'Collection.Add' as '### TODO ### : Buttons of the Inventory Management Module to inactivate'
UNION ALL SELECT 'Collection.Edit' as '### TODO ### : Buttons of the Inventory Management Module to inactivate'
UNION ALL SELECT 'Collection.Template' as '### TODO ### : Buttons of the Inventory Management Module to inactivate';

-- COLLECTION

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_patient_identity_verified' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- SAMPLE MASTER

ALTER TABLE sample_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT 'p';
ALTER TABLE sample_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT 'p';
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- ALIQUOT MASTER

ALTER TABLE aliquot_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT 'p';
ALTER TABLE aliquot_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT 'p';
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- QUALITY CONTROL

ALTER TABLE quality_ctrls MODIFY procure_created_by_bank CHAR(1) DEFAULT 'p';
ALTER TABLE quality_ctrls_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT 'p';








Creer maintenant les aliquots, sample avec regle de gestion
procure_processing_bank_created_by_system



-- ----------------------------------------------------------------------------------------------------------------------------------------
-- DRUG
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Drug/%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ORDER
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/Order/%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- STUDY
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/Study/%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- COLLECTION TEMPLATE
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Tools/Template/%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- DATAMART & REPORT
-- ----------------------------------------------------------------------------------------------------------------------------------------


-- Activate Report

UPDATE datamart_reports SET flag_active = 0;
UPDATE datamart_reports SET flag_active = 1 
WHERE name in ('initial specimens display',
	'all derivatives display',
	'list all children storages',
	'list all related diagnosis',
	'number of elements per participant');

-- Activate function

UPDATE datamart_structure_functions SET flag_active = 0;
UPDATE datamart_structure_functions SET flag_active = 1
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('ViewAliquot',
		'ViewCollection',
		'ViewStorageMaster',
		'Participant',
		'ViewSample',
		'MiscIdentifier',
		'ViewAliquotUse',
		'QualityCtrl',
		'OrderItem',
		'Shipment'))
AND label IN ('add to order',
	'all derivatives display',
	'create aliquots',
	'create derivative',
	'create quality control',
	'create use/event (applied to all)',
	'create uses/events (aliquot specific)',
	'define realiquoted children',
	'edit',
	'initial specimens display',
	'list all children storages',
	'number of elements per participant',
	'realiquot');

-- Inactivate databrower

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1;
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('AliquotReviewMaster',
		'ConsentMaster',
		'DiagnosisMaster',
		'EventMaster',
		'FamilyHistory',
		'ParticipantContact',
		'ParticipantMessage',
		'ReproductiveHistory',
		'SpecimenReviewMaster',
		'TreatmentExtendMaster')
) OR id2 IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('AliquotReviewMaster',
		'ConsentMaster',
		'DiagnosisMaster',
		'EventMaster',
		'FamilyHistory',
		'ParticipantContact',
		'ParticipantMessage',
		'ReproductiveHistory',
		'SpecimenReviewMaster',
		'TreatmentExtendMaster'));























-- report

'all derivatives display',
'initial specimens display',
'list all children storages',
'list all related diagnosis',
'number of elements per participant',
'participant identifiers',
'procure aliquots summary',
'procure bcr detection',
'procure diagnosis and treatments summary',
'procure followup summary',
'procure next followup report',
'report_3_name',
'report_4_name',
'report_5_name',
'report_ctrnet_catalogue_name',

-- Structures

'AliquotReviewMaster',
'ConsentMaster',
'DiagnosisMaster',
'EventMaster',
'FamilyHistory',
'MiscIdentifier',
'OrderItem',
'Participant',
'ParticipantContact',
'ParticipantMessage',
'QualityCtrl',
'ReproductiveHistory',
'Shipment',
'SpecimenReviewMaster',
'TreatmentExtendMaster',
'TreatmentMaster',
'ViewAliquot',
'ViewAliquotUse',
'ViewCollection',
'ViewSample',
'ViewStorageMaster',

-- functions

'add to order',
'all derivatives display',
'create aliquots',
'create derivative',
'create quality control',
'create use/event (applied to all)',
'create uses/events (aliquot specific)',
'define realiquoted children',
'edit',
'initial specimens display',
'list all children storages',
'list all related diagnosis',
'number of elements per participant',
'participant identifiers report',
'print barcodes',
'procure aliquots summary',
'procure bcr detection',
'procure diagnosis and treatments summary',
'procure followup summary',
'procure next followup report',
'realiquot',











-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6189' WHERE version_number = '2.6.5';
