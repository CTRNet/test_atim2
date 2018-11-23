-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Administration
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Set the ATiM installation name

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'Northern Biobank Initiative', 'Northern Biobank Initiative');

-- Users & Groups
-- ...................................................................................................................................

-- Manage users account that will be setup by default after the ATiM installation
-- (Could be done manually after the first installation using the ATiM functionalities of the "> Administration > Groups (Users & Permissions) " tool.)
--    . Activate first user
--    . Change second one to 'MigrationScript' with a complex password for any future data migration done by script
--    . Inactivate all the other one and assigned them a complex password

UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1', password_modified = NOW(), force_password_reset = '0' WHERE id = 1;

UPDATE users SET flag_active = 0, username = 'MigrationScript', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 2;
UPDATE groups SET name = 'System' WHERE id = 2;

UPDATE users SET flag_active = 0, password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id > 2;

UPDATE users SET first_name = username, email = '';

-- Banks
-- ...................................................................................................................................

-- Change name of the first bank from 'Default' to 'Breast'
-- (Could be done manually after the first installation using the ATiM functionalities of the "> Administration > Banks " tool)

UPDATE banks SET name = 'Breast', description = '';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Tools
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Tools menus update (unused features)
-- (Should be completed by setting the permissions of each group using the ATiM functionalities of -- the "> Administration > Groups (Users & Permissions) > Permissions " tool. This action could be suffisant.)
--    . Hide all tools sub-menus we won't use (protocol, drug, sop)

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Protocol%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Drug%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Sop%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Hide Clinical Annotation objects (or sub-menu) that don't have to be used by user in this custom version
--    . Hide all ClinicalAnnotation menus that we won't use
--         (Should be completed by setting the permissions of each group using the ATiM functionalities of the "> Administration > Groups (Users & Permissions) > Permissions " tool. This action could be suffisant.)
--    . Keep only Profile and ParticipantMessages ClinicalAnnotation menus
--    . Inactivate any Participant to unused Model databrowser links
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--         (Files 'datamart_structures_relationships_fr/en.png' in '\app\webroot\img\dataBrowser' have to be updated to match exactly the datamart_browsing_controls content.)
--    . Inactivate any report or action in batch that could be launched from databrowser result set or a batchset gathering these types of record (TreatmentMaster, etc)
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--    . Activate 'create participant message (applied to all)' action that could be launched from databrowser result set or a batchset gathering Participant record
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--    . Inactivate reports that contain data of these unsed objects.
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--    . Hide custom drop down list linked to field that won't be displayed into this custom version
--         (Not required. Will just help administartor working on "> Administration > Dropdown List Configuration " tool.)

UPDATE menus SET flag_active = 0  WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/Participants/chronology/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/%';

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'participant identifiers report';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ConsentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'FamilyHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'QualityCtrl' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ParticipantContact' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentExtendMaster' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'create participant message (applied to all)';

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'list all related diagnosis';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Consent Form Versions';

-- Participant Profile
-- ...................................................................................................................................

-- Manage Profile form fields 
-- (SQL statements build using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Hide unused fields
--    . Participant identifier will be renamed to PHN#


UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('participant_identifier', 'notes', 'sex', 'last_chart_checked_date', 'vital_status', 'date_of_death', 'date_of_birth', 'created', 'ids', 'last_modification'));

REPLACE INTO i18n (id,en,fr)
VALUES
('participant identifier', 'PHN#', 'PHN#');

-- Misc-Identifier (Participant Identifiers)
-- ...................................................................................................................................

-- Manage Identifier form fields
-- (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Hide dates and note fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add study identifier
--    . Create a new misc_identifier_controls record called 'patient study id' with field 'flag_link_to_study' set to '1'
--         (SQL statements built using PhpMyAdmin. Will be replaced by a feature of the ATiM tool soon.) 
--    . Changed miscidentifiers fields properties to display study fields into identifier forms
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Activate StudySummary to MiscIdentifier databrowser link
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--         (Files 'datamart_structures_relationships_fr/en.png' in '\app\webroot\img\dataBrowser' have to be updated to match exactly the datamart_browsing_controls content.)

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- EventMaster
-- ...................................................................................................................................

-- EventMaster sub-menus update (unused features)
-- (Should be completed by setting the permissions of each group using the ATiM functionalities of the "> Administration > Groups (Users & Permissions) > Permissions " tool. This action could be suffisant.)
--    . Hide all event sub menus we won't use
--    . Keep only lab menu and display it as the main sub menu of the Annoation Menus.

UPDATE menus SET flag_active = 0  
WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%'
AND use_link NOT LIKE '/ClinicalAnnotation/EventMasters/listall/lab%'
AND language_title != 'annotation';
UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE language_title = 'annotation' AND use_link LIKE '/ClinicalAnnotation/EventMasters%';

-- EventControls management
--    . Inactivate all existing event controls
--    . Create a new event_controls record called 'retrospective cancer specimen annotation' plus the linked detail tablename
--         (SQL statements built using PhpMyAdmin. Will be replaced by a feature of the ATiM tool soon) 
--         (flag_use_for_ccl set to '1' to let user link a participant collection to this type of record)
--    . Create new form for the created event_controls
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)

UPDATE event_controls SET flag_active = 0;

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, detail_form_alias, detail_tablename, display_order, databrowser_label, flag_use_for_ccl, use_addgrid, use_detail_form_for_index)
VALUES
('breast', 'lab', 'retrospective cancer specimen annotation', '1', 'bc_nbi_ed_breast_specimen_annotation', 'bc_nbi_ed_breast_specimen_annotations', '0', 'breast|retrospective cancer specimen annotation', '1', '0', '1');

ALTER TABLE event_masters
  ADD COLUMN bc_nbi_acquisition_nbr varchar(150) DEFAULT NULL;
ALTER TABLE event_masters_revs
  ADD COLUMN bc_nbi_acquisition_nbr varchar(150) DEFAULT NULL;
CREATE TABLE `bc_nbi_ed_breast_specimen_annotations` (
   bc_nbi_pathology_specimen_id varchar(150) DEFAULT NULL,
   bc_nbi_specimen_type_ffpe tinyint(1) DEFAULT '0',
   bc_nbi_specimen_type_he_slide tinyint(1) DEFAULT '0',
   bc_nbi_procedure varchar(150) DEFAULT NULL,
   bc_nbi_tumour_site varchar(150) DEFAULT NULL,
   bc_nbi_laterality varchar(50) DEFAULT NULL,
   bc_nbi_tumour_size varchar(150) DEFAULT NULL,
   bc_nbi_tumour_focality varchar(150) DEFAULT NULL,
   bc_nbi_histological_type varchar(150) DEFAULT NULL,
   bc_nbi_histological_grade varchar(20) DEFAULT NULL,
   bc_nbi_lymph_nodes_examined int(3) DEFAULT NULL,
   bc_nbi_lymph_nodes_involved int(3) DEFAULT NULL,
   bc_nbi_pathological_staging_T varchar(20) DEFAULT NULL,
   bc_nbi_pathological_staging_N varchar(20) DEFAULT NULL,
   bc_nbi_pathological_staging_M varchar(20) DEFAULT NULL,
   bc_nbi_estrogen_receptors varchar(150) DEFAULT NULL,
   bc_nbi_progesterone_receptors varchar(150) DEFAULT NULL,
   bc_nbi_human_epidermal_growth_factor_receptor2 varchar(150) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `bc_nbi_ed_breast_specimen_annotations_revs` (
   bc_nbi_pathology_specimen_id varchar(150) DEFAULT NULL,
   bc_nbi_specimen_type_ffpe tinyint(1) DEFAULT '0',
   bc_nbi_specimen_type_he_slide tinyint(1) DEFAULT '0',
   bc_nbi_procedure varchar(150) DEFAULT NULL,
   bc_nbi_tumour_site varchar(150) DEFAULT NULL,
   bc_nbi_laterality varchar(50) DEFAULT NULL,
   bc_nbi_tumour_size varchar(150) DEFAULT NULL,
   bc_nbi_tumour_focality varchar(150) DEFAULT NULL,
   bc_nbi_histological_type varchar(150) DEFAULT NULL,
   bc_nbi_histological_grade varchar(20) DEFAULT NULL,
   bc_nbi_lymph_nodes_examined int(3) DEFAULT NULL,
   bc_nbi_lymph_nodes_involved int(3) DEFAULT NULL,
   bc_nbi_pathological_staging_T varchar(20) DEFAULT NULL,
   bc_nbi_pathological_staging_N varchar(20) DEFAULT NULL,
   bc_nbi_pathological_staging_M varchar(20) DEFAULT NULL,
   bc_nbi_estrogen_receptors varchar(150) DEFAULT NULL,
   bc_nbi_progesterone_receptors varchar(150) DEFAULT NULL,
   bc_nbi_human_epidermal_growth_factor_receptor2 varchar(150) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_ed_breast_specimen_annotations`
  ADD KEY `event_master_id` (`event_master_id`);
ALTER TABLE `bc_nbi_ed_breast_specimen_annotations_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `bc_nbi_ed_breast_specimen_annotations_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `bc_nbi_ed_breast_specimen_annotations`
  ADD CONSTRAINT `bc_nbi_ed_breast_specimen_annotations_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('bc_nbi_ed_breast_specimen_annotation');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'bc_nbi_acquisition_nbr', 'input',  NULL , '1', '', '', '', 'bc nbi acquisition nbr', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_pathology_specimen_id', 'input',  NULL , '1', '', '', '', 'bc nbi pathology specimen id', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_specimen_type_ffpe', 'checkbox',  NULL , '0', '', '', '', 'bc nbi specimen type', 'bc nbi specimen type ffpe'), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_specimen_type_he_slide', 'checkbox',  NULL , '0', '', '', '', '', 'h and e slide'), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_procedure', 'input',  NULL , '0', '', '', '', 'bc nbi procedure', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_tumour_site', 'input',  NULL , '0', '', '', '', 'bc nbi tumour site', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', '', 'bc nbi laterality', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_tumour_size', 'input',  NULL , '0', 'size=10', '', '', 'bc nbi tumour size', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_tumour_focality', 'input',  NULL , '0', '', '', '', 'bc nbi tumour focality', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_histological_type', 'input',  NULL , '0', '', '', '', 'bc nbi histological type', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_histological_grade', 'input',  NULL , '0', 'size=5', '', '', 'bc nbi histological grade', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_lymph_nodes_examined', 'integer',  NULL , '0', '', '', '', 'bc nbi lymph nodes examined', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_lymph_nodes_involved', 'integer',  NULL , '0', '', '', '', 'bc nbi lymph nodes involved', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_pathological_staging_T', 'input',  NULL , '0', 'size=5', '', '', 'bc nbi pathological staging T', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_pathological_staging_N', 'input',  NULL , '0', 'size=5', '', '', 'bc nbi pathological staging N', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_pathological_staging_M', 'input',  NULL , '0', 'size=5', '', '', 'bc nbi pathological staging M', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_estrogen_receptors', 'input',  NULL , '0', '', '', '', 'bc nbi estrogen receptors', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_progesterone_receptors', 'input',  NULL , '0', '', '', '', 'bc nbi progesterone receptors', ''), 
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_human_epidermal_growth_factor_receptor2', 'input',  NULL , '0', '', '', '', 'bc nbi human epidermal growth factor receptor2', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `field`='bc_nbi_acquisition_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi acquisition nbr' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_pathology_specimen_id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi pathology specimen id' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_specimen_type_ffpe' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi specimen type' AND `language_tag`='bc nbi specimen type ffpe'), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_specimen_type_he_slide' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='h and e slide'), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_procedure' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi procedure' AND `language_tag`=''), '1', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_tumour_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi tumour site' AND `language_tag`=''), '2', '15', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi laterality' AND `language_tag`=''), '2', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_tumour_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi tumour size' AND `language_tag`=''), '2', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_tumour_focality' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi tumour focality' AND `language_tag`=''), '2', '18', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_histological_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi histological type' AND `language_tag`=''), '2', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_histological_grade' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi histological grade' AND `language_tag`=''), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_lymph_nodes_examined' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi lymph nodes examined' AND `language_tag`=''), '2', '21', 'lymph nodes', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_lymph_nodes_involved' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi lymph nodes involved' AND `language_tag`=''), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_pathological_staging_T' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi pathological staging T' AND `language_tag`=''), '3', '23', 'pathological staging', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_pathological_staging_N' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi pathological staging N' AND `language_tag`=''), '3', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_pathological_staging_M' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi pathological staging M' AND `language_tag`=''), '3', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_estrogen_receptors' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi estrogen receptors' AND `language_tag`=''), '3', '26', 'ancillary studies', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_progesterone_receptors' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi progesterone receptors' AND `language_tag`=''), '3', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_human_epidermal_growth_factor_receptor2' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi human epidermal growth factor receptor2' AND `language_tag`=''), '3', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='EventMaster'  AND `field`='bc_nbi_acquisition_nbr'), 'notBlank', '');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('lymph nodes', "Lymph Nodes", ""),
('bc nbi lymph nodes examined', "Sentinel Lymph Nodes Examined", ""), 
('bc nbi lymph nodes involved', "Sentinel Lymph Nodes Involved", ""), 
('pathological staging', "Pathological Staging", ""),
('bc nbi specimen type', "Specimen Type", ""),	
('bc nbi specimen type ffpe', "FFPE", ""),	
('ffpe', "FFPE", ""),
('h and e slide', "H&E Slide", ""),
('retrospective cancer specimen annotation', "Retrospective Cancer Specimen Annotation", ""),
('bc nbi tumour size', "Tumour Size", ""),
('bc nbi tumour site', "Tumour Site", ""),
('bc nbi tumour focality', "Tumour Focality", ""),
('bc nbi progesterone receptors', "Progesterone receptors (PR)", ""),
('bc nbi procedure', "Procedure", ""),
('bc nbi pathology specimen id', "Pathology Specimen ID", ""),
('bc nbi pathological staging T', "pT", ""),
('bc nbi pathological staging N', "pN", ""),
('bc nbi pathological staging M', "pM", ""),
('bc nbi laterality', "Laterality", ""),
('bc nbi human epidermal growth factor receptor2', "Human epidermal growth factor receptor-2 (HER2)", ""),
('bc nbi histological type', "Histological Type", ""),
('bc nbi histological grade', "Histological Grade", ""),
('bc nbi estrogen receptors', "Estrogen receptors (ER)", ""),
('bc nbi acquisition nbr', "Acquisition#", "");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Inventory Management
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Hide custom drop down list linked to inventory field that won't be displayed into this custom version
-- (Not required. Will just help administartor working on "> Administration > Dropdown List Configuration " tool.)

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'xenog%';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Laboratory Sites';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'SOP Versions';

-- Collections
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Manage collection fields displayed in many forms accross ATiM ('collections', 'collections_for_collection_tree_view', 'linked_collections', 'clinicalcollectionlinks', 'view_collection', 'collections_adv_search')
--    . Manage fields display
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Add validation on collection field 'Bank' to make it 'required'
--    . Hide any fields linked to objects (Consent, Diagnosis and Treatment) of the of 'clinicalcollectionlinks' form
--         (Object defined above can not be linked to a participant collection with the customized verison of ATiM)
--    . Populate 'Specimen Collection Sites' custom drop down list by default values
--         (Could be done manually after the first installation using the ATiM functionalities of the "> Administration > Dropdown List Configuration " tool.)

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', 
`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', 
`flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sop_master_id'));

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('acquisition_label'))
AND `flag_add`='1' AND `flag_add_readonly`='0';

UPDATE structure_formats 
SET `flag_edit`='1', `flag_edit_readonly`='1'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('acquisition_label'))
AND `flag_edit`='1' AND `flag_edit_readonly`='0';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('system generated a duplicated acquisition number - please try to save data again', 'System generated a duplicated acquisition number! Please try again or contact your administrator if the problem persists!', '');

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='bank_id'), 'notBlank', '');
UPDATE structure_formats SET `flag_override_default`='1', `default`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `field`='bc_nbi_acquisition_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi acquisition nbr' AND `language_tag`=''), '1', '403', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

SET @modified = (SELECT NOW() FROM users WHERE id = '2');
SET @modified_by = (SELECT id FROM users WHERE id = '2');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('prince george', 'Prince George',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('terrace', 'Terrace',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('fort st. john', 'Fort St. John',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

-- Collection can only be linked to a participant meaning that no unlinked collection or 'independant collection' can b created
--    . Hide option "independent collection" of the 'collection_property' list (see collection property field)
--         (SQL statements built using the ATiM Formbuilder tool, tab 'Value Domain' [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Hide option "nothing" of the 'col_copy_binding_opt' list (see option when user is copying a collection))
--         (SQL statements built using the ATiM Formbuilder tool, tab 'Value Domain' [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Inactivate any Collection to unused Model databrowser links
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--         (Files 'datamart_structures_relationships_fr/en.png' in '\app\webroot\img\dataBrowser' have to be updated to match exactly the datamart_browsing_controls content.)

UPDATE structure_value_domains AS svd 
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id 
INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id 
SET `flag_active`="0" 
WHERE svd.domain_name='collection_property' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="independent collection" AND language_alias="independent collection");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id 
INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id 
SET `flag_active`="0" 
WHERE svd.domain_name='col_copy_binding_opt' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="nothing");

INSERT INTO i18n (id,en,fr)
VALUES
('a created collection should be linked to a participant', 'A created collection should be linked to a participant.', '');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');

-- Update fields labels

REPLACE INTO i18n (id,en,fr) VALUES ('acquisition_label', 'Acquisition#', '');

-- Sample
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Keep only Tissue sample as sample that could be created into the system
--         (SQL statements built using the ATiM Inventory Configuration tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/inventory_config/].)

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 138, 203, 188, 142, 220, 143, 141, 144, 192, 7, 130, 8, 9, 101, 102, 194, 140);

-- Sample Master form update
--    . Hide 'problematic' field
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Tissue Sample
--    . Hide 'pathology_reception_datetime' & 'tissue_size' & 'tissue_weight' fields
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Use ICD-O-3 Topo codes for the tissue source drop down list

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit') AND `flag_confidential`='0');

UPDATE structure_value_domains 
SET source = "CodingIcd.CodingIcdo3Topo::getTopoCategoriesCodes"
WHERE domain_name = 'tissue_source_list';
UPDATE structure_fields SET `default`='C50' WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='tissue_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list');

-- Aliquot
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Aliquot barcode
--    . Aliquot Barcode field should not let user to set or modify the vlaue (value generated by the system)
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)

UPDATE structure_formats SET `flag_add`='0',`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid_readonly`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Aliquot label
--    . Aliquot label should be comptled
--    . Aliquot label should always be visibale (on left side) for any data creation in batch (flag_float property)

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotMaster'  AND `field`='aliquot_label'), 'notBlank', '');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Hide aliquot study field 
--    . Aliquot Barcode field should not let user to set or modify the vlaue (value generated by the system)
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Inactivate StudySummary to AliquotMaster databrowser link
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--         (Files 'datamart_structures_relationships_fr/en.png' in '\app\webroot\img\dataBrowser' have to be updated to match exactly the datamart_browsing_controls content.)

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Print Barcodes
--    . Add Aliquot Label field to the output
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].) 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_barcode'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Hide aliquot lots number field field 
-- (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Specimen Review
--    . Inactivate the 'breast review (simple)' report
--    . Rename 'Review Code' to 'Acquisition #'
--    . Hide fields of the aliquot review form
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)
--    . Let any type of tissue aliquot to be linked to a brest tissue review (setting aliquot_type_restriction = 'all')

UPDATE specimen_review_controls SET flag_active = 0 WHERE review_type = 'breast review (simple)';

REPLACE INTO i18n (id,en,fr)
VALUES
('review code', 'Acquisition #', '');

UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='length' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='width' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE aliquot_review_controls SET aliquot_type_restriction = 'all' WHERE review_type = 'breast tissue slide review';

-- Hide Quality Controls
--    . Hide Quality Controls sub-menus (unused features)
--         (Should be completed by setting the permissions of each group using the ATiM functionalities of the "> Administration > Groups (Users & Permissions) > Permissions " tool. This action could be suffisant.)
--    . Inactivate custom drop down list not used
--    . Inactivate QualityControl to AliquotMaster & SampleMaster databrowser links
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--         (Files 'datamart_structures_relationships_fr/en.png' in '\app\webroot\img\dataBrowser' have to be updated to match exactly the datamart_browsing_controls content.)
--    . Inactivate any report or action in batch that could be launched from databrowser result set or a batchset gathering QualityControl records
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/QualityCtrls%';

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Quality Control Tools';

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'create quality control';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Study
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Hide unsued field (disease site) 
-- (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Storage and TMA slide
-- -----------------------------------------------------------------------------------------------------------------------------------

-- TMA slide will be part of the data that a user can create
--    . Activate TmaSlideUse & TmaSlide to specific objects databrowser links
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/db_validation/].)
--         (Files 'datamart_structures_relationships_fr/en.png' in '\app\webroot\img\dataBrowser' have to be updated to match exactly the datamart_browsing_controls content.)

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Additional Customisation
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Inactivate 'Bank Activity Report (Per Period)' report

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_5_name';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Track Install Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7054' WHERE version_number = '2.7.0';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='spr_breast_cancer_types') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='breast_review_type') AND `flag_confidential`='0');
ALTER TABLE spr_breast_cancer_types
   ADD COLUMN bc_nbi_ductal char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_lobular char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_d_l_mix char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_tubular char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_mucinous char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_dcis char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_other char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_other_precision varchar(250) DEFAULT NULL;
ALTER TABLE spr_breast_cancer_types_revs
   ADD COLUMN bc_nbi_ductal char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_lobular char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_d_l_mix char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_tubular char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_mucinous char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_dcis char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_other char(1) DEFAULT NULL,
   ADD COLUMN bc_nbi_other_precision varchar(250) DEFAULT NULL;
UPDATE structure_formats SET display_order = (display_order+30) WHERE structure_id=(SELECT id FROM structures WHERE alias='spr_breast_cancer_types');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_ductal', 'yes_no',  NULL , '0', '', '', '', 'ductal', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_lobular', 'yes_no',  NULL , '0', '', '', '', 'lobular', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_d_l_mix', 'yes_no',  NULL , '0', '', '', '', 'd-l mix', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_tubular', 'yes_no',  NULL , '0', '', '', '', 'tubular', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_mucinous', 'yes_no',  NULL , '0', '', '', '', 'mucinous', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_dcis', 'yes_no',  NULL , '0', '', '', '', 'dcis', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_other', 'yes_no',  NULL , '0', '', '', '', 'other', ''), 
('InventoryManagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'bc_nbi_other_precision', 'input',  NULL , '0', 'size=20', '', '', '', 'precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_ductal' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ductal' AND `language_tag`=''), '1', '20', 'type', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_lobular' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lobular' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_d_l_mix' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='d-l mix' AND `language_tag`=''), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_tubular' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tubular' AND `language_tag`=''), '1', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_mucinous' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mucinous' AND `language_tag`=''), '1', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_dcis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dcis' AND `language_tag`=''), '1', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_other' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other' AND `language_tag`=''), '1', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='bc_nbi_other_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='precision'), '1', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE versions SET branch_build_number = '7112' WHERE version_number = '2.7.0';