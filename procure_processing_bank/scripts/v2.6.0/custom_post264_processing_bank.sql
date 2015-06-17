UPDATE users SET flag_active = 0, password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', email = '';
UPDATE users SET flag_active = 1, username = 'NicoEn', first_name = 'NicoEn' WHERE id = 1;

-- Clinical Annotation

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', 
`flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_float`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id  NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('participant_identifier', 'ids', 'created', 'last_modification', 'notes'));

UPDATE structure_formats SET `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_addgrid_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE consent_controls SET flag_active = 0;
UPDATE event_controls SET flag_active = 0;
UPDATE treatment_controls SET flag_active = 0;
UPDATE treatment_extend_controls SET flag_active = 0;
UPDATE misc_identifier_controls SET flag_active = 0;

UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/ConsentMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/EventMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/TreatmentMasters%';

UPDATE datamart_structure_functions SET flag_active = '0'
WHERE label = 'number of elements per participant'
AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','ParticipantMessage','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'));

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','ParticipantMessage','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','ParticipantMessage','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'));

SELECT "Set permissions to 'deny' for 'Add' particpant and 'Search' identifier." AS '### TODO ###';

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

ALTER TABLE sample_masters ADD COLUMN procure_processing_bank_created_by_system  tinyint(1) DEFAULT '0';
ALTER TABLE sample_masters_revs ADD COLUMN procure_processing_bank_created_by_system  tinyint(1) DEFAULT '0';

ALTER TABLE aliquot_masters ADD COLUMN procure_processing_bank_created_by_system  tinyint(1) DEFAULT '0';
ALTER TABLE aliquot_masters_revs ADD COLUMN procure_processing_bank_created_by_system  tinyint(1) DEFAULT '0';







n'afficher que le detail
inserer info dans vu?
aliquot avec procure_processing_bank_created_by_system ne peut pas être children
aliquot label pas modifiable
generer le fichier au niveau des autre bank













UPDATE versions SET branch_build_number = '6189' WHERE version_number = '2.6.4';
