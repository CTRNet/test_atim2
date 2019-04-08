-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'MUHC - CIM', 'CUSM - CIM');
UPDATE users 
SET username = 'NicoEn',  first_name = 'Nicolas', last_name = 'Luc', email = 'nicol.luc@gmail.com', job_title = 'ATiM Project Leader', 
password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = '1', force_password_reset = '0'
WHERE id = 1;
UPDATE users 
SET password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979';
UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;

SET @modified = (SELECT NOW() FROM users WHERE id = '1');
SET @modified_by = (SELECT id FROM users WHERE id = '1');

-- Study
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'cusm_cim_study_full_name', 'input',  NULL , '0', 'size=50', '', '', 'full name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='cusm_cim_study_full_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='full name' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr)
VALUES
('study_title', 'Study Number/Short Name', 'Numéro/Nom abrégé de l''étude');
INSERT INTO i18n (id,en,fr)
VALUES
('full name', 'Full Name', 'Nom complet');
ALTER TABLE study_summaries ADD COLUMN cusm_cim_study_full_name VARCHAR(500) DEFAULT NULL;
ALTER TABLE study_summaries_revs ADD COLUMN cusm_cim_study_full_name VARCHAR(500) DEFAULT NULL;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES ('study / project', 'Study', 'Étude');

UPDATE structure_fields SET  `language_label`='study_city',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_city' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study_province',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_province' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study_country',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_country' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study_street',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_street' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='role' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='role') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='contact' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_street' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_validations (structure_field_id, rule)
VALUES
((SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='role'), 'notBlank');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='role' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='role') AND `flag_confidential`='0');

-- Participant
-- ---------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field` IN ('first_name', 'date_of_birth', 'sex', 'notes', 'participant_identifier', 'last_modification', 'created'));
UPDATE structure_formats 
SET `flag_override_label`='1', `language_label`='initials', `flag_override_help`='1', `language_help`='', `flag_override_setting`='1', `setting`='size=5' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `display_column`='3', `display_order`='98', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initials', 'Initials', 'Initiales');
REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'Participant System #', 'Participant - No. système');

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_search_readonly`='1', `flag_addgrid_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE participants
  ADD COLUMN `cusm_cim_participant_study_number` varchar(250) DEFAULT NULL,
  ADD COLUMN `cusm_cim_study_summary_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `FK_cusm_cim_participant_study_summaries` FOREIGN KEY (`cusm_cim_study_summary_id`) REFERENCES `study_summaries` (`id`);
ALTER TABLE participants_revs
  ADD COLUMN `cusm_cim_participant_study_number` varchar(250) DEFAULT NULL,
  ADD COLUMN `cusm_cim_study_summary_id` int(11) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'cusm_cim_autocomplete_participant_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_cim_participant_study_number', 'input',  NULL , '0', 'size=40', '', '', 'participant study number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '1', 'study / project', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='cusm_cim_autocomplete_participant_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_participant_study_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='participant study number' AND `language_tag`=''), '1', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations (structure_field_id, rule)
VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='cusm_cim_autocomplete_participant_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL), 'notBlank'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_participant_study_number'), 'notBlank');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('participant study number', 'Participant Study #', 'No étude du participant'),
('participant study number already assigned to a participant', "The 'ATiM - Participant#' is already assigned to another participant.", "Le 'No étude du participant' est déjà attribué à un autre participant.");

UPDATE structure_formats SET `flag_search_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/Participants/chronology/%';

-- Collection
-- ---------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field` IN ('acquisition_label', 'collection_datetime'));

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr)
VALUES
('acquisition_label', 'Collection System #', 'Collection - No. système');

UPDATE structure_formats SET `flag_override_tag`='1', `language_tag`='#' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

ALTER TABLE collections ADD COLUMN cusm_cim_visit_nbr varchar(30) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN cusm_cim_visit_nbr varchar(30) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'cusm_cim_visit_nbr', 'input',  NULL , '0', 'size=5', '', '', 'visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_cim_visit_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='11', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'title', 'input',  NULL , '0', 'size=40', '', '', 'study', ''), 
('InventoryManagement', 'ViewCollection', '', 'cusm_cim_participant_study_number', 'input',  NULL , '0', 'size=40', '', '', 'participant study number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_cim_participant_study_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='participant study number' AND `language_tag`=''), '0', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'cusm_cim_visit_nbr', 'input',  NULL , '0', 'size=5', '', '', 'visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_cim_visit_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='11', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_cim_visit_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='11', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`=' ' AND `field`='field1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_cim_visit_nbr'), 'notBlank', ''),
((SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_cim_visit_nbr'), 'custom,/^[0-9]*$/', 'cusn_cim_collection_visit_format_message');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('cusn_cim_collection_visit_format_message', 'Wrong format of the collection visit value (integer value expected)', "Mauvais format de la valeur de la visite (valeur entière attendue)");

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_cim_visit_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '1', 'collection', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='41', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_cim_visit_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '0', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`=' ' AND `field`='field1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_value_domains_permissible_values 
SET flag_active = 0
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE language_alias="all (participant, consent, diagnosis and treatment/annotation)");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt') ,  `default`='2' WHERE model='FunctionManagement' AND tablename='' AND field='col_copy_binding_opt' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt');

-- Sample
-- ---------------------------------------------------------------------------------------------------

-- Inventory Configuration

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 203, 188, 142, 220, 143, 141, 144, 139);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(25, 119, 15, 16, 24, 132, 17, 18, 118, 191);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12);
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(216);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(65);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(70);
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(184, 222, 139);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(10);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(44, 68, 1);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(44, 71);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(9, 10);

-- Materials

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='aliquot_label');

ALTER TABLE sample_masters
  ADD COLUMN `cusm_cim_material_id_1` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_2` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_3` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_4` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_5` int(11) DEFAULT NULL,
  ADD CONSTRAINT `FK_cusm_cim_sample_masters_materials_1` FOREIGN KEY (`cusm_cim_material_id_1`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `FK_cusm_cim_sample_masters_materials_2` FOREIGN KEY (`cusm_cim_material_id_2`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `FK_cusm_cim_sample_masters_materials_3` FOREIGN KEY (`cusm_cim_material_id_3`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `FK_cusm_cim_sample_masters_materials_4` FOREIGN KEY (`cusm_cim_material_id_4`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `FK_cusm_cim_sample_masters_materials_5` FOREIGN KEY (`cusm_cim_material_id_5`) REFERENCES `materials` (`id`);
ALTER TABLE sample_masters_revs
  ADD COLUMN `cusm_cim_material_id_1` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_2` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_3` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_4` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_cim_material_id_5` int(11) DEFAULT NULL;
  
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('cusm_cim_material_biological_cabin', "Material.Material::getMaterialsList('biological cabin')"),
('cusm_cim_material_centrifuge', "Material.Material::getMaterialsList('centrifuge')"),
('cusm_cim_material_scale_bench', "Material.Material::getMaterialsList('scale-bench')"),
('cusm_cim_material_universal_mixer', "Material.Material::getMaterialsList('universal mixer')"),
('cusm_cim_material_vortex', "Material.Material::getMaterialsList('vortex')");

-- Sop
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Sop%';

-- Protocol
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Protocol%';

-- Drug
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Drug%';

-- Material
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = '1' WHERE use_link LIKE '/Material/Materials%';

REPLACE INTO i18n (id,en,fr) VALUES ('mat_item name', 'TAG#', 'TAG#');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE model='Material' AND tablename='materials' AND field='item_name'), 'notBlank', '');
UPDATE structure_fields SET  `setting`='size=5' WHERE model='Material' AND tablename='materials' AND field='item_name' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('cusm_cim_material_description', NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("biological cabin", "biological cabin"),
("centrifuge", "centrifuge"),
("scale-bench", "scale-bench"),
("universal mixer", "universal mixer"),
("vortex", "vortex");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_material_description"), (SELECT id FROM structure_permissible_values WHERE value="biological cabin" AND language_alias="biological cabin"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_material_description"), (SELECT id FROM structure_permissible_values WHERE value="centrifuge" AND language_alias="centrifuge"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_material_description"), (SELECT id FROM structure_permissible_values WHERE value="scale-bench" AND language_alias="scale-bench"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_material_description"), (SELECT id FROM structure_permissible_values WHERE value="universal mixer" AND language_alias="universal mixer"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_material_description"), (SELECT id FROM structure_permissible_values WHERE value="vortex" AND language_alias="vortex"), "5", "1");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("biological cabin", "Biological Cabin", ""), 
("centrifuge", "Centrifuge", ""), 
("scale-bench", "Scale-Bench", ""), 
("universal mixer", "Universal mixer", ""), 
("vortex", "Vortex", "");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_description')  WHERE model='Material' AND tablename='materials' AND field='item_type' AND `type`='select' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='details' WHERE model='Material' AND tablename='materials' AND field='description' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_description') ,  `language_label`='description' WHERE model='Material' AND tablename='materials' AND field='item_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_description');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE model='Material' AND tablename='materials' AND field='item_type'), 'notBlank', '');

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE model='Material' AND tablename='materials' AND field='item_name'), 'isUnique', '');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE model='Material' AND tablename='materials' AND field='item_name'), 'custom,/^[0-9]{4}$/', 'cusn_cim_material_code_format_message');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('cusn_cim_material_code_format_message', 'Wrong format of the TAG# (4 digits)', 'Mauvais format du TAG# (4 chiffres)');

-- location

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Material', 'Material', 'materials', 'cusm_cim_supplier', 'input',  NULL , '0', 'size=20', '', '', 'supplier', ''), 
('Material', 'Material', 'materials', 'cusm_cim_brand', 'input',  NULL , '0', 'size=20', '', '', 'brand', ''), 
('Material', 'Material', 'materials', 'cusm_cim_asset_classification', 'input',  NULL , '0', 'size=20', '', '', 'asset classification', ''), 
('Material', 'Material', 'materials', 'cusm_cim_model', 'input',  NULL , '0', 'size=20', '', '', 'model / version', ''), 
('Material', 'Material', 'materials', 'cusm_cim_serial_number', 'input',  NULL , '0', 'size=20', '', '', 'serial number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_supplier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='supplier' AND `language_tag`=''), '2', '104', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_brand' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='brand' AND `language_tag`=''), '1', '30', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_asset_classification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='asset classification' AND `language_tag`=''), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_model' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='model / version' AND `language_tag`=''), '1', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_serial_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='serial number' AND `language_tag`=''), '1', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_supplier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr)
VALUES
('supplier', 'Supplier', ''),
('brand', 'Brand', ''),
('asset classification', 'Asset Classification', ''),
('model / version', 'Model / Version', ''),
('serial number', 'Serial Number', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Material', 'Material', 'materials', 'cusm_cim_certification_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('Material', 'Material', 'materials', 'cusm_cim_certification_next_date', 'date',  NULL , '0', '', '', '', 'next', ''), 
('Material', 'Material', 'materials', 'cusm_cim_certification_type', 'input',  NULL , '0', 'size=20', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_certification_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '2', '300', 'certification', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_certification_next_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='next' AND `language_tag`=''), '2', '301', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_certification_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '302', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
REPLACE INTO i18n (id,en,fr)
VALUES
('certification', 'Certification', '');
ALTER TABLE materials
  ADD COLUMN cusm_cim_asset_classification varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_brand varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_certification_type varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_model varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_serial_number varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_supplier varchar(250) DEFAULT NULL;
ALTER TABLE materials_revs
  ADD COLUMN cusm_cim_asset_classification varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_brand varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_certification_type varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_model varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_serial_number varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_cim_supplier varchar(250) DEFAULT NULL;
ALTER TABLE materials
  ADD COLUMN cusm_cim_certification_date date DEFAULT NULL,
  ADD COLUMN cusm_cim_certification_next_date date DEFAULT NULL;
ALTER TABLE materials_revs
  ADD COLUMN cusm_cim_certification_date date DEFAULT NULL,
  ADD COLUMN cusm_cim_certification_next_date date DEFAULT NULL;
  
-- New customisation Start on 2018-02-19
-- ---------------------------------------------------------------------------------------------------------------------------------------------

-- Inventory configuration

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(7, 19, 133, 135, 134, 20, 21, 193, 196, 197, 198, 199, 200, 130, 8, 9, 101, 102, 194);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(9, 33, 10);
  
-- Materials

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_brand' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_asset_classification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_model' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_serial_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_supplier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Material', 'Material', 'materials', 'cusm_cim_user_guide', 'file',  NULL , '0', '', '', '', 'user guide', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='materials'), (SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_user_guide' AND `type`='file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='user guide' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
ALTER TABLE materials ADD COLUMN cusm_cim_user_guide varchar(1000) DEFAULT NULL;
ALTER TABLE materials_revs ADD COLUMN cusm_cim_user_guide varchar(1000) DEFAULT NULL;
  
-- Bank

UPDATE banks SET name = 'Oncology group', description = '', modified_by = @modified_by, modified = @modified WHERE id = 1;
INSERT INTO banks (name, created, created_by, modified, modified_by, description)
VALUES
("Women's Health Research Unit", @modified, @modified_by, @modified, @modified_by, ''),
("Dr. Olivstein Pulmonary studies", @modified, @modified_by, @modified, @modified_by, ''),
("Dr. Bourbeau's Studies", @modified, @modified_by, @modified, @modified_by, ''),
("Hematology Studies", @modified, @modified_by, @modified, @modified_by, '');
INSERT INTO banks_revs (id, name, description, misc_identifier_control_id, modified_by, version_created)
(SELECT id, name, description, misc_identifier_control_id, modified_by, modified FROM banks WHERE modified = @modified AND modified_by = @modified_by);

ALTER TABLE study_summaries
  ADD COLUMN `cusm_cim_bank_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `FK_cusm_cim_study_summaries_banks` FOREIGN KEY (`cusm_cim_bank_id`) REFERENCES `banks` (`id`);
ALTER TABLE study_summaries_revs
  ADD COLUMN `cusm_cim_bank_id` int(11) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'cusm_cim_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'cusm cim bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='cusm_cim_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cusm cim bank' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations (structure_field_id, rule)
VALUES
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='cusm_cim_bank_id'), 'notBlank');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('cusm cim bank', 'Bank/Group', 'Banque/Groupe');

ALTER TABLE participants
  ADD COLUMN `cusm_cim_bank_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `FK_cusm_cim_participants_banks` FOREIGN KEY (`cusm_cim_bank_id`) REFERENCES `banks` (`id`);
ALTER TABLE participants_revs
  ADD COLUMN `cusm_cim_bank_id` int(11) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_cim_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'cusm cim bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cusm cim bank' AND `language_tag`=''), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='cusm_cim_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
  
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_participant_study_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('visit', 'Visit', 'Visite'),
('at least one study is linked to that bank', 'At least one study is linked to that bank', 'Au moins une étude est attachée à cette banque');

UPDATE structure_formats SET `display_order`='-3', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_fields SET language_label = 'cusm cim bank' WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id';

UPDATE structure_formats SET `display_order`='9000', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9001' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'cusm_cim_visit_nbr', 'input',  NULL , '0', 'size=5', '', '', 'visit', ''), 
('InventoryManagement', 'ViewSample', '', 'title', 'input',  NULL , '0', 'size=40', '', '', 'study', ''), 
('InventoryManagement', 'ViewSample', '', 'cusm_cim_participant_study_number', 'input',  NULL , '0', 'size=40', '', '', 'participant study number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='cusm_cim_visit_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='cusm_cim_participant_study_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='participant study number' AND `language_tag`=''), '0', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE menus SET flag_active = 0  WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'Order') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Order/%';

UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='cusm_cim_user_guide' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `setting`='class=upload' WHERE model='Material' AND tablename='materials' AND field='cusm_cim_user_guide' AND `type`='file' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='materials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Material' AND `tablename`='materials' AND `field`='item_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_description') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_material_id_1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_universal_mixer') , '0', '', '', '', 'mixer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_universal_mixer')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mixer' AND `language_tag`=''), '1', '440', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET `language_label`='universal mixer' WHERE model='SampleMaster' AND tablename='sample_masters' AND field='cusm_cim_material_id_1' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_universal_mixer');

UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='cusm_cim_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

ALTER TABLE collections
  ADD COLUMN `cusm_cim_study_summary_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `FK_cusm_cim_collections_study_summaries` FOREIGN KEY (`cusm_cim_study_summary_id`) REFERENCES `study_summaries` (`id`);
ALTER TABLE collections_revs
  ADD COLUMN `cusm_cim_study_summary_id` int(11) DEFAULT NULL;

ALTER TABLE aliquot_masters
  ADD COLUMN `cusm_cim_bank_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `FK_cusm_cim_aliquot_masters_banks` FOREIGN KEY (`cusm_cim_bank_id`) REFERENCES `banks` (`id`);
ALTER TABLE aliquot_masters_revs
  ADD COLUMN `cusm_cim_bank_id` int(11) DEFAULT NULL;

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='cusm_cim_autocomplete_participant_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_cim_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('user guide', 'User Guide', 'Guide d''utilisation'), 
('the link cannot be deleted - collection contains at least one sample', 'The link cannot be deleted. Collection contains at least one sample.', 'Le lien ne peut pas être supprimé. Des échantillons existent dans la collection.'), 
('a created collection should be linked to a participant', 'A created collection should be linked to a participant', 'La création d''une collection doit être liée à un patient');

UPDATE structure_value_domains_permissible_values 
SET flag_active = 0
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="blood_type");
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Blood Types')" WHERE domain_name="blood_type";
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Blood Types', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('EDTA', 'EDTA',  'EDTA', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('no additif', 'No additif',  'Pas d''additif', '1', @control_id, NOW(), NOW(), 1, 1),
('heparin', 'Heparin',  'Heparine', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
INSERT INTO structure_validations (structure_field_id, rule)
VALUES
((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='blood_type'), 'notBlank');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit') AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('cusm_cim_sd_centrifuged_derivative');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_material_id_1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_biological_cabin') , '0', '', '', '', 'biological cabin', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_material_id_2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_centrifuge') , '0', '', '', '', 'centrifuge', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_material_id_3', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_scale_bench') , '0', '', '', '', 'scale-bench', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_material_id_4', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_vortex') , '0', '', '', '', 'vortex', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_biological_cabin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biological cabin' AND `language_tag`=''), '1', '390', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_centrifuge')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='centrifuge' AND `language_tag`=''), '1', '391', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_3' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_scale_bench')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='scale-bench' AND `language_tag`=''), '1', '392', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_4' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_vortex')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='vortex' AND `language_tag`=''), '1', '393', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',cusm_cim_sd_centrifuged_derivative') 
WHERE sample_type IN ('blood cell', 'pbmc', 'plasma', 'serum', 'centrifuged urine', 'buffy coat');
UPDATE structure_formats SET `language_heading`='sop_materials and equipment' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_biological_cabin') AND `flag_confidential`='0');
UPDATE structure_formats SET display_column = '3', display_order = (100 + display_order) WHERE structure_id = (SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative');
UPDATE structure_formats SET `display_column`='3', `display_order`='600', `language_heading`='sop_materials and equipment' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_material_id_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_material_universal_mixer') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `field`='creation_datetime');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE sample_masters
  ADD COLUMN cusm_cim_centrifuge_duration_mn int(5) DEFAULT NULL;
ALTER TABLE sample_masters_revs
  ADD COLUMN cusm_cim_centrifuge_duration_mn int(5) DEFAULT NULL;  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_centrifuge_duration_mn', 'integer_positive',  NULL , '0', '', '', '', 'centrifuge duration (mn)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_centrifuge_duration_mn'), '1', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('centrifuge duration (mn)', 'Centrifuge Duration (mn)', 'Durée centrifugation (mn)');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');

UPDATE structure_value_domains_permissible_values 
SET flag_active = 0
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE language_alias="reserved for study");

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/QualityCtrls%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'list all related diagnosis';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'create quality control';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewCollection' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'print barcodes';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'participant identifiers report';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'MiscIdentifier' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ConsentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'FamilyHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ParticipantMessage' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'QualityCtrl' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'EventMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'SpecimenReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ParticipantContact' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentExtendMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaBlock' AND label = 'create tma slide';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add tma slide use';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlideUse' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';

ALTER TABLE aliquot_masters ADD COLUMN cusm_cim_backup tinyint(1) DEFAULT '0';
ALTER TABLE aliquot_masters_revs ADD COLUMN cusm_cim_backup tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'cusm_cim_backup', 'checkbox',  NULL , '0', '', '', '', 'backup', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='cusm_cim_backup' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='backup' AND `language_tag`=''), '0', '399', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1', '1', '1', '1', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('backup', 'Backup', 'Sauvegarde');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_internal_use_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) 
VALUES
((SELECT id FROM datamart_structures WHERE model = 'ViewCollection'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), '1', '1', 'cusm_cim_study_summary_id'),
((SELECT id FROM datamart_structures WHERE model = 'Participant'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), '1', '1', 'cusm_cim_study_summary_id');

UPDATE structure_permissible_values_custom_controls
SET flag_active = '0'
WHERE name IN ('Quality Control Tools',
'SOP Versions',
'Consent Form Versions',
'Orders Institutions',
'Orders Contacts',
'Xenograft Species',
'Xenograft Implantation Sites',
'Xenograft Tissues Sources',
'Participant Message Types');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('paxgene', 'Paxgene',  'Paxgene', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Shipment');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'Shipment') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');

UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE sample_masters
  ADD COLUMN cusm_cim_centrifuge_speed decimal(10,3) DEFAULT NULL,
  ADD COLUMN cusm_cim_centrifuge_speed_unit varchar(5) DEFAULT NULL;
ALTER TABLE sample_masters_revs
  ADD COLUMN cusm_cim_centrifuge_speed decimal(10,3) DEFAULT NULL,
  ADD COLUMN cusm_cim_centrifuge_speed_unit varchar(5) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('cusm_cim_centrifuge_speed_unit', NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("RPM", "RPM"),
("Gys", "Gys");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_centrifuge_speed_unit"), 
(SELECT id FROM structure_permissible_values WHERE value="RPM" AND language_alias="RPM"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="cusm_cim_centrifuge_speed_unit"), 
(SELECT id FROM structure_permissible_values WHERE value="Gys" AND language_alias="Gys"), "1", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_centrifuge_speed', 'float_positive',  NULL , '0', '', '', '', 'centrifuge speed', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'cusm_cim_centrifuge_speed_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_centrifuge_speed_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_centrifuge_speed' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='centrifuge speed' AND `language_tag`=''), '1', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cim_sd_centrifuged_derivative'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='cusm_cim_centrifuge_speed_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_cim_centrifuge_speed_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '103', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('centrifuge speed', 'Centrifuge Speed', 'Vitesse de centrifugation'),
("RPM", "RPM", "RPM"),
("Gys", "Gys", "Gys");

UPDATE structure_formats SET `flag_addgrid_readonly`='0', `flag_editgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='cusm_cim_backup' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/%';

-- Aliquot Internal Use :: Order

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('incident', 'Incident',  'Incident', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('shipping', 'Shipping',  'Envoi', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_internal_use_type') AND `flag_confidential`='0');

ALTER TABLE aliquot_internal_uses 
  ADD COLUMN `cusm_cim_datetime_remove_from_storage` datetime DEFAULT NULL,
  ADD COLUMN `cusm_cim_datetime_remove_from_storage_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `cusm_cim_time_packaged` time DEFAULT NULL;
ALTER TABLE aliquot_internal_uses_revs
  ADD COLUMN `cusm_cim_datetime_remove_from_storage` datetime DEFAULT NULL,
  ADD COLUMN `cusm_cim_datetime_remove_from_storage_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `cusm_cim_time_packaged` time DEFAULT NULL;
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='date (event/shipping)' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('date (event/shipping)', 'Date (Event/Shipping)', 'Date (Evenement/Livraison)');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'cusm_cim_datetime_remove_from_storage', 'datetime',  NULL , '0', '', '', '', 'removed from freezer', ''), 
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'cusm_cim_time_packaged', 'time',  NULL , '0', '', '', '', 'time packaged', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='cusm_cim_datetime_remove_from_storage' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='removed from freezer' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='cusm_cim_time_packaged' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='time packaged' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES
('removed from freezer', 'Removed From Freezer (if applicable)', 'Retiré du congélateur (cas échéant)'),
('time packaged', 'Time Packaged (if applicable)', 'emballé (cas échéant)');
REPLACE INTO i18n (id,en,fr)
VALUES
('aliquot internal use code', 'Precision/Mail#', 'Précision/Courrier#'),
("add uses/events", "Add Events/Shippings", "Ajouter événements/envois"),
("aliquot use/event", "Aliquot Event/Shipping", "Événement/envoi d'aliquot"),
("aliquot uses and events", "Aliquot Events/Shippings", "Événements/envois d'aliquot"),
("create use/event (applied to all)", "Create event/shipping (applied to all)", "Créer événement/envoi (applicabl à tous)"),
("create uses/events (aliquot specific)", "Create events/shippings (aliquot specific)", "Créer événements/envois (aliquot spécifique)"),
("use and/or event", "Event/Shipping", "Événement/envoi"),
("use counter", "Events/Shippings", "Événements/envois"),
("use/event creation", "Events/Shipping Creation", "Création événement/envoi"),
("uses and events", "Events/Shippings", "Événements/envois"),
("you are about to create an use/event for %d aliquot(s)", "You are about to create an event/shipping for %d aliquot(s)", "Vous êtes sur le point de créer un(e) événement/envoi pour %d aliquots"),
("you are about to create an use/event for %s aliquot(s) contained into %s", "You are about to create an event/shipping for %s aliquot(s) contained into %s", "Vous êtes sur le point de créer un(e) envoi/événement pour %d aliquots contenus dans %s");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquotUse', 'view_aliquot_uses', 'cusm_cim_datetime_remove_from_storage', 'datetime',  NULL , '0', '', '', '', 'removed from freezer', ''), 
('InventoryManagement', 'ViewAliquotUse', 'view_aliquot_uses', 'cusm_cim_time_packaged', 'time',  NULL , '0', '', '', '', 'time packaged', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='cusm_cim_datetime_remove_from_storage' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='removed from freezer' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='cusm_cim_time_packaged' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='time packaged' AND `language_tag`=''), '0', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='cusm_cim_datetime_remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='cusm_cim_time_packaged' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='date (event/shipping)' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='cusm_cim_datetime_remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'add to order';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'OrderItem' AND label = 'defined as returned';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'OrderItem' AND label = 'edit';

UPDATE structure_permissible_values SET `value` = 'G', language_alias = 'G' WHERE `value` = 'Gys' AND language_alias = 'Gys';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("G", "G", "G");


-- -----------------------------------------------------------------------------------------------

INSERT INTO structure_permissible_values_customs_revs (`id`, `value`, `en`, `fr`, `use_as_input`, `control_id`, `modified_by`, `version_created`)
(SELECT `id`, `value`, `en`, `fr`, `use_as_input`, `control_id`, `modified_by`, `modified` FROM structure_permissible_values_customs WHERE modified = @modified AND modified_by = @modified_by);

UPDATE versions SET branch_build_number = '9999' WHERE version_number = '2.7.0';




Some have barcode. Some have just labels (free text). To manage.
Material and freezer: Both material user guide and certification.
Rapports to create.






SELECT 'SOME DEMO DATA ARE INSERTED' AS '### WARNING ###';

-- -----------------------------------------------------------------------------------------------
-- For demo
-- -----------------------------------------------------------------------------------------------

INSERT INTO `cusmcim`.`materials` (`item_name`, `item_type`, `description`, `cusm_cim_certification_date`, `cusm_cim_certification_next_date`, `cusm_cim_certification_type`, `cusm_cim_brand`, `cusm_cim_asset_classification`, `cusm_cim_model`, `cusm_cim_serial_number`, `cusm_cim_supplier`, `cusm_cim_user_guide`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('7221', 'biological cabin', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('7443', 'biological cabin', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),

('9222', 'biological cabin', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('9254', 'biological cabin', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('9424', 'biological cabin', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),

('8022', 'centrifuge', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('8736', 'centrifuge', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('8773', 'centrifuge', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),

('6775', 'scale-bench', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('6744', 'scale-bench', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),

('2557', 'universal mixer', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('2555', 'universal mixer', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),

('1145', 'vortex', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('1545', 'vortex', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1),
('1577', 'vortex', '', '2018-01-01', '2020-02-11', '', '', '', '', '', '', '', '2018-02-21 19:58:28', '2018-02-21 19:58:28', 1, 1);


INSERT INTO `cusmcim`.`study_summaries` (`cusm_cim_bank_id`, `title`, `cusm_cim_study_full_name`, `start_date`, `end_date`, `summary`, `start_date_accuracy`, `end_date_accuracy`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
(4, 'Bs-45368', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),
(4, 'Bs-45676', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),
(4, 'Bs-45658', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),

(1, 'Onco-22323', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),
(1, 'Onco-423238', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),
(1, 'Onco-41166', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),

(2, 'Wom-5784', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1),
(2, 'Wom-38982', '', NULL, NULL, '', '', '', '2018-02-21 20:03:32', '2018-02-21 20:03:32', 1, 1);


