
REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'PROCURE - Central', 'PROCURE - Central');

-- ================================================================================================================================================================
--
-- CLINICAL ANNOTATION
--
-- ================================================================================================================================================================

SELECT 'Participant.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'Participant.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'Participant.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'MiscIdentifier.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'MiscIdentifier.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'MiscIdentifier.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
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
UNION ALL SELECT 'CLinicalCollectionLink.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
UNION ALL SELECT 'CLinicalCollectionLink.Delete' as '### TODO ### : Buttons of the Clinical annotation module to inactivate';

-- UNION ALL SELECT 'Collection.Add' as '### TODO ### : Buttons of the Clinical annotation module to inactivate'
-- UNION ALL SELECT 'Collection.Edit' as '### TODO ### : Buttons of the Clinical annotation module to inactivate';

-- PROFILE

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_modification_by_bank');

-- CONSENT

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_create_by_bank');

-- EVENT

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- TREATMENT

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- MISCIDENTIFIERS

UPDATE misc_identifier_controls SET flag_active = 1;

-- DATAMART LINKED TO CLINICAL ANNOTATION

UPDATE datamart_structure_functions SET flag_active = '0'
WHERE label = 'number of elements per participant'
AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN (
	'DiagnosisMaster',
	'TreatmentExtendMaster',
	'ParticipantContact',
	'ReproductiveHistory',
	'FamilyHistory',
	'ParticipantMessage'));
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN (
	'DiagnosisMaster',
	'TreatmentExtendMaster',
	'ParticipantContact',
	'ReproductiveHistory',
	'FamilyHistory',
	'ParticipantMessage'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN (
	'DiagnosisMaster',
	'TreatmentExtendMaster',
	'ParticipantContact',
	'ReproductiveHistory',
	'FamilyHistory',
	'ParticipantMessage'));



























SELECT "end central bank" AS MSG;
exit










echo "end";
exit;











-- Collections

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_patient_identity_verified' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_visit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_collection_visit') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_patient_identity_verified' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_patient_identity_verified' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('procure_processing_bank_transferred_aliquots_details');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'procure_processing_bank_transferred_aliquots_descriptions_list', 'open', '', 'InventoryManagement.AliquotControl::getTransferredAliquotsDescriptionsList');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'procure_processing_bank_transferred_aliquots_description', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_processing_bank_transferred_aliquots_descriptions_list') , '0', '', '', '', 'aliquot description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,class=range file' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_collection_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_processing_bank_transferred_aliquots_description' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_processing_bank_transferred_aliquots_descriptions_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot description' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='aliquot procure identification' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '0', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0');	
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `field`='procure_processing_bank_transferred_aliquots_description'), 'notEmpty');

INSERT INTO structures(`alias`) VALUES ('procure_processing_bank_transferred_aliquots_details_file');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'procure_processing_bank_transferred_aliquots_details_file', 'file',  NULL , '0', '', '', '', 'list of transferred aliquots', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details_file'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_processing_bank_transferred_aliquots_details_file' AND `type`='file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='list of transferred aliquots' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_processing_bank_transferred_aliquots_details_file'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_separator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('aliquot description','Aliquot Description','Description de l''aliquot'),
('list of transferred aliquots','List of Transferred Aliquots','Liste des aliquots transférés'),
('some aliquot data is missing - check csv separator', 'Some aliquot data is missing! Please check the CSV separator is correctly set!', 'Certaines données d''aliquots sont manquantes! Vérifier le séparateur de CSV!'),
('format of the participant identifier is wrong','The participant identification format is wrong!','Le format de l''identification du patient n''est pas supporté!'),
('format of the visite is wrong','Format of the visite is wrong!','Le format de la visite n''est pas supporté!'),
('format of the aliquot description is wrong','The aliquot description is wrong!','La description de l''aliquot n''est pas supportée!'),
('no file has been selected', 'No file has been selected!', 'Aucun fichier n''a été sélectionné!'),
('add transferred aliquots - from csv', 'Add Transferred Aliquots (from file)', 'Créer aliquots transférés (à partir d''un fichier)'),
('add transferred aliquots - direct', 'Add Transferred Aliquots', 'Créer aliquots transférés'),
('see CSV line(s) %s', 'see CSV Line(s) %s', 'Voire ligne(s) du CSV %s');

ALTER TABLE sample_masters ADD COLUMN procure_processing_bank_created_by_system  char(1) DEFAULT 'n';
ALTER TABLE sample_masters_revs ADD COLUMN procure_processing_bank_created_by_system  char(1) DEFAULT 'n';

ALTER TABLE aliquot_masters ADD COLUMN procure_processing_bank_created_by_system  char(1) DEFAULT 'n';
ALTER TABLE aliquot_masters_revs ADD COLUMN procure_processing_bank_created_by_system  char(1) DEFAULT 'n';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'procure_processing_bank_created_by_system', 'checkbox',  NULL , '0', '', '', '', 'created by the system', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='procure_processing_bank_created_by_system' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by the system' AND `language_tag`=''), '2', '10002', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', 'sample_masters', 'procure_processing_bank_created_by_system', 'checkbox',  NULL , '0', '', '', '', 'created by the system', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='sample_masters' AND `field`='procure_processing_bank_created_by_system' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by the system' AND `language_tag`=''), '2', '10001', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'procure_processing_bank_created_by_system', 'checkbox',  NULL , '0', '', '', '', 'created by the system', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='procure_processing_bank_created_by_system' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by the system' AND `language_tag`=''), '1', '1202', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', 'aliquot_masters', 'procure_processing_bank_created_by_system', 'checkbox',  NULL , '0', '', '', '', 'created by the system', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='aliquot_masters' AND `field`='procure_processing_bank_created_by_system' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by the system' AND `language_tag`=''), '1', '1203', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '1', '1', '0', '0', '1', '1', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES ('created by the system', 'Created By The System', 'Créé par le système');

UPDATE structure_fields SET  `type`='yes_no' WHERE field='procure_processing_bank_created_by_system';

INSERT INTO i18n (id,en,fr)
VALUES
("batch init - at least one sample has been created by the system - you can only create derivatives from aliquots for samples created by the system",
"At least one sample has been created by the system. You can not create directly a derivative sample from this type of sample. You have first to select the used aliquot then create derivative from this one.",
"Au moins un échantillon a été créé par le système. Vous ne pouvez pas créer directement un dérivé à partir d'un tel échantillon. Vous devez sélectionner l'aliquot utilisé et ensuite créer le dérivé à partir de ce dernier."),
("at least one sample has been created by the system - you can only create aliquots from existing aliquots for samples created by the system",
"At least one sample has been created by the system. You can not create directly an aliquot from this type of sample. You have first to select the used aliquot then create the 'realiquoted children' from this one.",
"Au moins un échantillon a été créé par le système. Vous ne pouvez pas créer directement un aliquot à partir d'un tel échantillon. Vous devez sélectionner l'aliquot utilisé et ensuite créer 'l'aliquot enfant' créé à partir de ce dernier.");

UPDATE datamart_structure_functions 
SET flag_active = '0' WHERE label IN ('participant identifiers report','procure diagnosis and treatments summary','rocure followup summary','procure aliquots summary', 'procure bcr detection', 'procure next followup report');

UPDATE datamart_reports
SET flag_active = 0
WHERE name in ('participant identifiers', 'procure diagnosis and treatments summary', 'procure followup summary', 'procure bcr detection', 'procure next followup report');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_yes_no_system_record", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("y", "system record");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_yes_no_system_record"), (SELECT id FROM structure_permissible_values WHERE value="y" AND language_alias="system record"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("n", "-");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_yes_no_system_record"), (SELECT id FROM structure_permissible_values WHERE value="n" AND language_alias="-"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'procure_processing_bank_created_by_system', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_yes_no_system_record') , '0', '', '', '', 'system', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_processing_bank_created_by_system' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_yes_no_system_record')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='system' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'procure_processing_bank_created_by_system', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_yes_no_system_record') , '0', '', '', '', 'system', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_processing_bank_created_by_system' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_yes_no_system_record')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='system' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('system record', 'System', 'Système');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_processing_bank_created_by_system' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_yes_no_system_record') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');




-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- 2015-06-??
-- ------------------------------------------------------------------------------------------------------------------------------------------------

Aliquot Label pas modifiable dans toutes les versions de procure
Créer un tache qui le permet par un administartor peut-etre.
Regler probleme si patients change de banque. Comment cela va fonctionner?
Créer Rapport pour l'envoie des échantillons à la bank de charles dans la version de procure...

Pouvoir recevir des slide pour l'annotation et les lier a un block?







TODO: Can an aliquot label changed in any version?
TODO: Generate file from other system

Monter la notion de projet/etude
Créer des identifiants d'étude par patient....












UPDATE versions SET branch_build_number = '6189' WHERE version_number = '2.6.5';




