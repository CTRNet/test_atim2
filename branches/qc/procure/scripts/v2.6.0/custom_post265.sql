SELECT "Set the core variable 'procure_atim_version'" AS '### MESSAGE ### : Todo'
UNION ALL SELECT "Set the core variable 'procure_bank_id'" AS '### MESSAGE ### : Todo';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- CLINICAL ANNOTATION
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- *** PROFILE ***

-- Flag to define participant has been transferred from one bank to another one

ALTER TABLE participants ADD COLUMN procure_transferred_participant char(1) default 'n';
ALTER TABLE participants_revs ADD COLUMN procure_transferred_participant char(1) default 'n';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_transferred_participant', 'yes_no',  NULL , '0', '', '', '', 'transferred participant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_transferred_participant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transferred participant' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('transferred participant','Transferred Participant','Participant Transféré'),
("the 'transferred participant' value has to be set","The 'transferred participant' value has to be set.","La donnée 'Participant Transféré' doit être complétée");

-- Participant Identifier can not be modified anymore

UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Validate participant identifier

SELECT 'Check participant_identifier with the good procure_bank_id for each atim bank installation (Re-run all other checks on consent, aliquot, etc if you corrected data)' AS '### TODO ###';
SELECT Participant.participant_identifier AS '### TODO ### : Wrong participant idenitifier format : to correct'
FROM participants Participant WHERE Participant.participant_identifier NOT REGEXP '^PS[1-4]P[0-9]{4}$';

-- Validate Form Identification are consistent with the participant identifier

SELECT 'Form Identification Control (should match participant identifier) : Correct data if list below is not empty' AS '### MESSAGE ###';
SELECT CONCAT('ConsentMaster', '.', ConsentMaster.id) AS 'Model.id', Participant.participant_identifier, ConsentMaster.procure_form_identification
FROM participants Participant
INNER JOIN consent_masters ConsentMaster ON Participant.id = ConsentMaster.participant_id AND ConsentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND ConsentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier)
UNION ALL
SELECT CONCAT('TreatmentMaster', '.', TreatmentMaster.id) AS 'Model.id', Participant.participant_identifier, TreatmentMaster.procure_form_identification
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND TreatmentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier)
UNION ALL
SELECT CONCAT('EventMaster', '.', EventMaster.id) AS 'Model.id', Participant.participant_identifier, EventMaster.procure_form_identification
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id AND EventMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND EventMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier);

-- Field used by the central bank

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_banks", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("1", "PS1"),(
"2", "PS2"),
("3", "PS3"),
("4", "PS4"),
("p","PSp");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="PS1"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="PS2"), "", "2"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="PS3"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="PS4"), "", "4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="p" AND language_alias="PSp"), "", "100");
INSERT IGNORE i18n (id,en,fr)
VALUES
("PS1", "PS1", "PS1"),
("PS2", "PS2", "PS2"),
("PS3", "PS3", "PS3"),
("PS4", "PS4", "PS4"),
("PSp","PSp","PSp");

SELECT 'Set default value for field participants.procure_last_modification_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE participants ADD COLUMN procure_last_modification_by_bank CHAR(1) DEFAULT '';
ALTER TABLE participants_revs ADD COLUMN procure_last_modification_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_last_modification_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', '', 'last modification by bank');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_modification_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='last modification by bank'), '3', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('last modification by bank','Last Modification By Bank','Dernière modification par banque');

-- *** MISC IDENTIFIER ***

-- New Identifier: participant study number

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) VALUES
(null, 'participant study number', 0, 0, '', NULL, 
0, 0, 0, 0, '', '', 1);
INSERT INTO i18n (id,en,fr) VALUES ('participant study number','Participant Study #', 'No étude patient');

-- *** CONSENT MASTER ***

SELECT 'Set default value for field consent_masters.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE consent_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE consent_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('created by bank','Created By Bank','Créé par banque');

-- *** EVENT MASTER ***

SELECT 'Set default value for field event_masters.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE event_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE event_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '1', '-6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- *** TREATMENT MASTER ***

SELECT 'Set default value for field treatment_masters.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE treatment_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE treatment_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '1', '-5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY MANAGEMENT
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- *** CLINICAL COLLECTION LINK ***

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('the link cannot be deleted - collection contains at least one aliquot', 'The link cannot be deleted. Collection contains at least one aliquot.', 'Le lien ne peut pas être supprimé. Des aliquots existent dans la colelction.'), 
('a created collection should be linked to a participant', 'A created collection should be linked to a participant', 'La création d''une collection doit être liée à un patient');

-- *** COLLECTION ***

-- No collection can exist with no visit

SELECT Collection.id AS '### MESSAGE ### : Collections with no visit - Has to be corrected'
FROM collections Collection
WHERE Collection.deleted <> 1 AND (Collection.procure_visit IS NULL OR Collection.procure_visit LIKE '');

-- Add collection bank that collected the collection (for central)

SELECT 'Set default value for field collections.procure_collected_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE collections ADD COLUMN procure_collected_by_bank CHAR(1) DEFAULT '';
ALTER TABLE collections_revs ADD COLUMN procure_collected_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'procure_collected_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'collected by bank', ''),
('InventoryManagement', 'ViewCollection', '', 'procure_collected_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'collected by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_collected_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collected by bank' AND `language_tag`=''), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collected by bank' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collected by bank' AND `language_tag`=''), '0', '19', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('collected by bank','Collected By Bank','Collecté par banque');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- *** SAMPLE MASTER ***

-- Add sample_masters.procure_created_by_bank for processing bank

SELECT 'Set default value for field sample_masters.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE sample_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE sample_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', ''),
('InventoryManagement', 'ViewSample', '', 'procure_created_by_bank', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='procure_created_by_bank'), '2', '10002', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0'), '2', '10002', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr)
VALUES
("batch init - at least one sample has been created by the system - you can only create derivatives from aliquots for samples created by the system",
"At least one sample has been created by the system. You can not create directly a derivative sample from this type of sample. You have first to select the used aliquot then create derivative from this one.",
"Au moins un échantillon a été créé par le système. Vous ne pouvez pas créer directement un dérivé à partir d'un tel échantillon. Vous devez sélectionner l'aliquot utilisé et ensuite créer le dérivé à partir de ce dernier."),
("at least one sample has been created by the system - you can only create aliquots from existing aliquots for samples created by the system",
"At least one sample has been created by the system. You can not create directly an aliquot from this type of sample. You have first to select the used aliquot then create the 'realiquoted children' from this one.",
"Au moins un échantillon a été créé par le système. Vous ne pouvez pas créer directement un aliquot à partir d'un tel échantillon. Vous devez sélectionner l'aliquot utilisé et ensuite créer 'l'aliquot enfant' créé à partir de ce dernier.");

-- *** ALIQUOT MASTER ***

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00', 
'Identification (alq.) format errror. This one should start with the participant identification and the visit (PS0P0000 V00 )', 
'Erreur de format de l''identification (alq.). Cette donnée doit commencer avec l''identifiant du patient puis le numéro de visit (PS0P0000 V00 )'),
('visit of the collection cannot be changed - aliquot exists', 
'The visit of the collection cannot be changed : Aliquots are contained into this collection.', 'La visite de la collection ne peut pas être changée : Des aliquots sont contenus dans cette collection.');

-- No aliquot can be created if the collection is not linked to a participant: check existing data

SELECT AliquotMaster.barcode AS '### MESSAGE ### : Aliquots not linked to a participant - Has to be corrected'
FROM aliquot_masters AliquotMaster
INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
WHERE AliquotMaster.deleted <> 1 AND Collection.deleted <> 1 AND (Collection.participant_id IS NULL OR Collection.participant_id LIKE '');

-- Check All Aliquot barcode match the participant identifier + visit

SELECT 'Aliquot Barcode Control : Check barcodes match participant_identifier + visit (Correct data if list below is not empty)' AS '### MESSAGE ###';
SELECT CONCAT('AliquotMaster', '.', AliquotMaster.id) AS 'Model.id', Participant.participant_identifier, Collection.procure_visit, AliquotMaster.barcode
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\ ');

-- barcode read only

UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add aliquot_masters.procure_created_by_bank for processing bank

SELECT 'Set default value for field aliquot_masters.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE aliquot_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE aliquot_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', ''),
('InventoryManagement', 'ViewAliquot', '', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank'), '1', '1202', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='procure_created_by_bank'), '1', '1202', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND `field`='procure_created_by_bank'), 'notEmpty');

INSERT INTO i18n (id,en,fr)
VALUES
('no aliquot could be defined as realiquoted child for the following parent aliquot(s) ceated in another bank',
'No aliquot could be defined as realiquoted child for the following parent aliquot(s) created in another bank',
'Aucun aliquot ne peut actuellement être défini comme aliquot enfant pour les aliquots parents suivants créés dans une autre banque');

-- Create form used by processing bank to create participant, collection, sample then aliquot (transfer process)

INSERT INTO structures(`alias`) VALUES ('procure_transferred_aliquots_details_file');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'procure_transferred_aliquots_details_file', 'file',  NULL , '0', '', '', '', 'list of transferred aliquots', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details_file'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_details_file' AND `type`='file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='list of transferred aliquots' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details_file'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_separator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details_file'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank'), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details_file');
INSERT INTO i18n (id,en,fr)
VALUES
('list of transferred aliquots','List of Transferred Aliquots','Liste des aliquots transférés'),
('add transferred aliquots - from csv', 'Add Transferred Aliquots (from file)', 'Créer aliquots transférés (à partir d''un fichier)'),
('add transferred aliquots - direct', 'Add Transferred Aliquots', 'Créer aliquots transférés'),
('some aliquot data is missing - check csv separator', 'Some aliquot data is missing! Please check the CSV separator is correctly set!', 'Certaines données d''aliquots sont manquantes! Vérifier le séparateur de CSV!'),
('no file has been selected', 'No file has been selected!', 'Aucun fichier n''a été sélectionné!'),
('see CSV line(s) %s', 'see CSV Line(s) %s', 'Voire ligne(s) du CSV %s');

INSERT INTO structures(`alias`) VALUES ('procure_transferred_aliquots_details');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'procure_transferred_aliquots_descriptions_list', 'open', '', 'InventoryManagement.AliquotControl::getTransferredAliquotsDescriptionsList');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'procure_transferred_aliquots_description', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_transferred_aliquots_descriptions_list') , '0', '', '', '', 'aliquot description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_description' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_transferred_aliquots_descriptions_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot description' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='aliquot procure identification' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '0', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank'), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `field`='procure_transferred_aliquots_description'), 'notEmpty');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('aliquot description','Aliquot Description','Description de l''aliquot'),
('format of the aliquot barcode is not supported','The format of the aliquot identification is not supported!','Le format de l''identification de l''aliquot n''est pas supporté!'),
('format of the aliquot description is wrong','The aliquot description is wrong!','La description de l''aliquot n''est pas supportée!'),
('you can not select the processing bank as bank sending sample', 'You can not select the ''Processing Site'' as bank sending sample', 'Vous ne pouvez pas choisir le ''Site de traitement'' comme banque ayant envoyé les échantillons');

-- QUALITY CTRLS

SELECT 'Set default value for field quality_ctrls.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE quality_ctrls ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE quality_ctrls_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '1', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES
("at least one sample has been created by the system - you have to select first a tested aliquot if this one exists",
"At least one sample has been created by the system. You have to select first a tested aliquot if this one exists.",
"Au moins un échantillon a été créé par le système. Vous devez dans ce cas sélectionner un aliquote testé si ce dernier existe."); 

-- INTERNAL USE

SELECT 'Set default value for field aliquot_internal_uses.procure_created_by_bank for each BANK installation' AS '### TODO ###';
ALTER TABLE aliquot_internal_uses ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE aliquot_internal_uses_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '10001', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquotUse', '', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('sent to processing site','Sent To Processing Site','Envoyé au site de traitment',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from processing site','Received From Processing Site','Recu du site de traitment',  '1', @control_id, NOW(), NOW(), 1, 1);
SELECT "Set intarnal uses 'sent to processing site' and 'received from processing site' if applicable" AS '### TODO ###';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- DRUG
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ORDER
-- ----------------------------------------------------------------------------------------------------------------------------------------

SELECT count(*) AS '### MESSAGE ### : Nbr of existing orders : Should be equal to 0.' FROM orders;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Order/%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- STUDY
-- ----------------------------------------------------------------------------------------------------------------------------------------

SELECT count(*) AS '### MESSAGE ### : Nbr of existing studies : Should be equal to 0.' FROM study_summaries;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Study/%';

SELECT 'aliquot_internal_uses' AS table_name, count(*) AS 'nbr_of_record_linked_to_study (should be 0)' FROM aliquot_internal_uses WHERE study_summary_id IS NOT NULL AND study_summary_id NOT LIKE '' AND deleted <> 1
UNION ALL
SELECT 'aliquot_masters' AS table_name, count(*) AS 'nbr_of_record_linked_to_study (should be 0)' FROM aliquot_masters WHERE study_summary_id IS NOT NULL AND study_summary_id NOT LIKE '' AND deleted <> 1
UNION ALL
SELECT 'order_lines' AS table_name, count(*) AS 'nbr_of_record_linked_to_study (should be 0)' FROM order_lines WHERE study_summary_id IS NOT NULL AND study_summary_id NOT LIKE '' AND deleted <> 1
UNION ALL
SELECT 'consent_masters' AS table_name, count(*) AS 'nbr_of_record_linked_to_study (should be 0)' FROM consent_masters WHERE study_summary_id IS NOT NULL AND study_summary_id NOT LIKE '' AND deleted <> 1
UNION ALL
SELECT 'misc_identifiers' AS table_name, count(*) AS 'nbr_of_record_linked_to_study (should be 0)' FROM misc_identifiers WHERE study_summary_id IS NOT NULL AND study_summary_id NOT LIKE '' AND deleted <> 1;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_batchedit`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list_for_view') AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- COLLECTION TEMPLATE
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- DATAMART & REPORT
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = 0;
UPDATE datamart_reports SET flag_active = 1 
WHERE name in ('all derivatives display',
	'initial specimens display',
	'list all children storages',
	'list all related diagnosis',
	'number of elements per participant',
	'participant identifiers',
	'procure aliquots summary',
	'procure bcr detection',
	'procure diagnosis and treatments summary',
	'procure followup summary',
	'procure next followup report');

UPDATE datamart_structure_functions SET flag_active = 0;
UPDATE datamart_structure_functions SET flag_active = 1
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('ConsentMaster',
		'EventMaster',
		'MiscIdentifier',
		'Participant',
		'QualityCtrl',
		'TreatmentMaster',
		'ViewAliquot',
		'ViewAliquotUse',
		'ViewCollection',
		'ViewSample',
		'ViewStorageMaster'))
AND label IN ('all derivatives display',
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
	'participant identifiers report',
	'procure aliquots summary',
	'procure bcr detection',
	'procure diagnosis and treatments summary',
	'procure followup summary',
	'procure next followup report',
	'realiquot');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1;
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('AliquotReviewMaster',
		'DiagnosisMaster',
		'FamilyHistory',
		'OrderItem',
		'ParticipantContact',
		'ParticipantMessage',
		'ReproductiveHistory',
		'Shipment',
		'SpecimenReviewMaster',
		'TreatmentExtendMaster')
) OR id2 IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('AliquotReviewMaster',
		'DiagnosisMaster',
		'FamilyHistory',
		'OrderItem',
		'ParticipantContact',
		'ParticipantMessage',
		'ReproductiveHistory',
		'Shipment',
		'SpecimenReviewMaster',
		'TreatmentExtendMaster'));

-- Generate Aliquot Transfer File

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) VALUES
(null, 'procure aliquots transfer file creation', 'procure aliquots transfer file creation description', 'procure_aliquots_selection_criteria', 'procure_transferred_aliquots_details', 'index', 'procureCreateAliquotTransferFile', 1, NULL, 0, NULL, 0, (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 0);
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 'create aliquots transfer file', CONCAT('/Datamart/Reports/manageReport/',(SELECT id FROM datamart_reports WHERE name = 'procure aliquots transfer file creation')), 1, '');
INSERT INTO structures(`alias`) VALUES ('procure_aliquots_selection_criteria');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_aliquots_selection_criteria'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '300', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=30,class=file', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_description' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_transferred_aliquots_descriptions_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Generated', '', 'procure_sample_aliquot_ctrl_ids_sequence', 'input',  NULL , '0', 'size=30', '', '', 'procure control ids sequence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='procure_sample_aliquot_ctrl_ids_sequence' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='procure control ids sequence' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('procure aliquots transfer file creation', 'PROCURE - Aliquots Transfer File Creation', 'PROCURE - Création du fichier de transfert d''aliquots'),
('procure aliquots transfer file creation description', 
"Generate file used by 'PROCURE Processing Site' to download into ATiM the information of the aliquots transferred (from bank to site).", 
"Génére le fichier utilisé par le 'Site de Traitement PROCURE' afin de télécharger dans ATiM l'information relative aux aliquots transféré (de la banque vers le site)."),
('create aliquots transfer file', 'Create Aliquots Transfer File', 'Créer le fichier de transfert d''aliquots'),
('you are going to transfer %s aliquots flagged as not in stock',
"'You are going to transfer %s aliquots flagged as 'not in stock'",
"Vous allez transférer %s aliquotes definis comme 'pas en stock'"),
('procure control ids sequence','System Code','Code système'),
('%s lines have been imported - check line format and data if some data are missing',
'%s lines have been imported. Check line format and data if some data are missing.',
'%s lignes de ont été importées. Vérifiez le format des données et si certaines données sont manquantes.');





































SELECT 'Corriger bug sur le copy/past du load transferred aliquot (check box)' AS '### TODO ###';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

SELECT "ALTER TABLE participants MODIFY procure_last_modification_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE participants_revs MODIFY procure_last_modification_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE consent_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE consent_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE event_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE event_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE treatment_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE treatment_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';

ALTER TABLE collections MODIFY procure_collected_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE collections_revs MODIFY procure_collected_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE sample_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE sample_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE aliquot_masters MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE aliquot_masters_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE aliquot_internal_uses MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE aliquot_internal_uses_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE quality_ctrls MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';
ALTER TABLE quality_ctrls_revs MODIFY procure_created_by_bank CHAR(1) DEFAULT '?';" AS "### TODO ### Statements summray to set default bank values.";

UPDATE versions SET branch_build_number = '6???' WHERE version_number = '2.6.5';
