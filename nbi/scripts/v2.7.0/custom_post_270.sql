-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Administration
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Set ATiM installation name

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'Northern Biobank Initiative', 'Northern Biobank Initiative');

-- Users & Groups
-- ...................................................................................................................................

-- Manage users account set by default when IT will install the ATiM custom version
--    . Activate first user
--    . Change second one to 'MigrationScript' with a complex password for any future data migration done by script
--    . Inactivate all the other one and assigned them a complex password

UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1', password_modified = NOW(), force_password_reset = '0' WHERE id = 1;

UPDATE users SET flag_active = 0, username = 'MigrationScript', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 2;
UPDATE groups SET name = 'System' WHERE id = 2;

-- Banks
-- ...................................................................................................................................

-- Change name of the first bank

UPDATE banks SET name = 'Breast', description = '';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Tools
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Menus Update (Unused features)
--    . Hide all tools sub-menus we won't use (protocol, drug, sop)

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Protocol%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Drug%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Sop%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Menus Update (Unused features)
--    . Hide all clinical annotation sub menus we won't use
--    . Keep only participant messages

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Protocol%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Drug%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Sop%';

UPDATE menus SET flag_active = 0  WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/Participants/chronology/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/%';

-- Participant
-- ...................................................................................................................................

-- Participant Profile 
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

-- Misc(Participant)-Identifiers
--    . Hide dates and note fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Misc(Participant)-Identifiers
--    . Add study to identifier forms

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Misc(Participant)-Identifiers
--    . Activate StudySummary to MiscIdentifier databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- EventMaster
--    . 
-- ...................................................................................................................................

UPDATE menus SET flag_active = 0  
WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%'
AND use_link NOT LIKE '/ClinicalAnnotation/EventMasters/listall/lab%'
AND language_title != 'annotation';
UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE language_title = 'annotation' AND use_link LIKE '/ClinicalAnnotation/EventMasters%';

UPDATE event_controls SET flag_active = 0;

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, detail_form_alias, detail_tablename, display_order, databrowser_label, flag_use_for_ccl, use_addgrid, use_detail_form_for_index)
VALUES
('breast', 'lab', 'retrospective cancer specimen annotation', '1', 'bc_nbi_ed_breast_specimen_annotation', 'bc_nbi_ed_breast_specimen_annotations', '0', 'breast|retrospective cancer specimen annotation', '1', '0', '0');

CREATE TABLE `bc_nbi_ed_breast_specimen_annotations` (
   bc_nbi_acquisition_nbr varchar(150) DEFAULT NULL,
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
   bc_nbi_acquisition_nbr varchar(150) DEFAULT NULL,
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
('ClinicalAnnotation', 'EventDetail', 'bc_nbi_ed_breast_specimen_annotations', 'bc_nbi_acquisition_nbr', 'input',  NULL , '1', '', '', '', 'bc nbi acquisition nbr', ''), 
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
((SELECT id FROM structures WHERE alias='bc_nbi_ed_breast_specimen_annotation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='bc_nbi_ed_breast_specimen_annotations' AND `field`='bc_nbi_acquisition_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bc nbi acquisition nbr' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
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


















-- Collections
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', 
`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', 
`flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sop_master_id', 'acquisition_label'));

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

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr)
VALUES
('a created collection should be linked to a participant', 'A created collection should be linked to a participant.', '');

-- Collection copy option (limit to participant data or participant data + event)
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='col_copy_binding_opt' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="nothing");

-- Collection property (limit to participant collection)
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='collection_property' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="independent collection" AND language_alias="independent collection");


SET @modified = (SELECT NOW() FROM users WHERE id = '2');
SET @modified_by = (SELECT id FROM users WHERE id = '2');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('prince george', 'Prince George',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('terrace', 'Terrace',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('fort st. john', 'Fort St. John',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);



-- Sample & Aliquot Controls
-- Keep tissue aliquots only
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 138, 203, 188, 142, 220, 143, 141, 144, 192, 7, 130, 8, 9, 101, 102, 194, 140);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- Tissue Sample

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit') AND `flag_confidential`='0');

-- Use ICD-O-3 Topo codes for the tissue source drop down list

UPDATE structure_value_domains 
SET source = "CodingIcd.CodingIcdo3Topo::getTopoCategoriesCodes"
WHERE domain_name = 'tissue_source_list';
UPDATE structure_fields SET `default`='C50' WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='tissue_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list');

-- barcode

UPDATE structure_formats SET `flag_add`='0',`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- aliquot study

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- aliquot label

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotMaster'  AND `field`='aliquot_label'), 'notBlank', '');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Specimen Review

UPDATE specimen_review_controls SET flag_active = 0 WHERE review_type = 'breast review (simple)';
REPLACE INTO i18n (id,en,fr)
VALUES
('review code', 'Acquisition #', '');


UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='length' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='width' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE aliquot_review_controls SET aliquot_type_restriction = 'all' WHERE review_type = 'breast tissue slide review';




-- Inactivate custom drop down list not used

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'xenog%';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Laboratory Sites';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'SOP Versions';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Quality Control Tools';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Consent Form Versions';


-- Hide Quality Controls and Specimen Reviews

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/QualityCtrls%';

-- Study

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

-- DataBrowser and Report

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_5_name';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'list all related diagnosis';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewCollection' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'print barcodes';
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

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'create participant message (applied to all)';

UPDATE versions SET branch_build_number = '7054' WHERE version_number = '2.7.0';






































