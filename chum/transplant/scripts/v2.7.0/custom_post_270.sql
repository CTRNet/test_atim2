-- -----------------------------------------------------------------------------------------------------------------------------------
-- Initial Customization for the bank CHUM Kidney/Transplant
-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
--    Developped from an empty database copy of the ATiM - Oncology Axis at the chum (revs - ).
--    The Idea is to have similar database structure to help any fusion in the futur.
--        
--    Please create a first database loading the script 'atim_chum_transplant_270.sql'.
--    Then run this script.
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'Kidney Transplant', 'Transplantation rénale');

UPDATE users SET flag_active = 0, `password` = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', deleted = 1 WHERE username NOT IN ('NicoEn', 'Migration');
UPDATE groups SET deleted = 1 WHERE name NOT IN ('Syst. Admin.', 'Migration');

SET @modified = (SELECT NOW() FROM users WHERE id = '1');
SET @modified_by = (SELECT id FROM users WHERE id = '1');

UPDATE banks SET deleted = 1;
INSERT INTO banks (`name`, `description`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Kidney/Rein Transplant.', '', @modified, @modified, @modified_by, @modified_by);

UPDATE versions SET permissions_regenerated = 0;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Participants
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field` LIKE 'qc_nd_sardo%');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' 
AND `field` IN ('is_anonymous', 'qc_nd_status_at_consent_time', 'anonymous_reason', 'anonymous_precision', 'qc_nd_from_center'));

ALTER TABLE participants ADD COLUMN chum_kidney_transp_vih char(1) DEFAULT '';
ALTER TABLE participants_revs ADD COLUMN chum_kidney_transp_vih char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chum_kidney_transp_vih', 'yes_no',  NULL , '1', '', '', '', 'vih', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_kidney_transp_vih' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='vih' AND `language_tag`=''), '3', '19', 'other information', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_kidney_transp_vih' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add_readonly`='0', `flag_edit_readonly`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_kidney_transp_vih' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('other information', 'Other Information', 'Autre Information'),
('vih', 'HIV', 'VIH');


-- Misc Identifiers
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE misc_identifier_controls SET flag_active = 0 WHERE misc_identifier_name LIKE '% no Lab';
UPDATE misc_identifier_controls SET flag_active = 0 WHERE misc_identifier_name IN ('code-barre', 'family number', 'toronto hereditary cancer number');

INSERT INTO key_increments (key_name ,key_value) VALUES ('kidney transplant bank no lab', '577');
INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('kidney transplant bank no lab','1','1','kidney transplant bank no lab','%%key_increment%%','1','0','1','0','','','0');
UPDATE misc_identifier_controls SET  pad_to_length = 5 WHERE misc_identifier_name = 'kidney transplant bank no lab';
UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'kidney transplant bank no lab') WHERE name = 'Kidney/Rein Transplant.';

INSERT INTO i18n (id,en,fr)
VALUES 
('kidney transplant bank no lab', "Kidney/Transplant Bank #","No banque Rein/Transplant");

INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('other kidney transplant bank no lab','1','1','',null,'0','0','1','0','','','0');
INSERT INTO i18n (id,en,fr)
VALUES 
('other kidney transplant bank no la', "Other Kidney/Transplant Bank #","No banque Rein/Transplant - Autre");

-- Identifiers Report

UPDATE structure_formats SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field` LIKE '%_bank_no_lab');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'chum_kidney_transp_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'kidney transplant bank no lab', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), 
(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='chum_kidney_transp_bank_no_lab'), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Event/Diagnosis/Treatment/Consent/Family History/Reproductive History
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0 WHERE  controls_type != 'study consent';
 
UPDATE diagnosis_controls SET flag_active = 0;
UPDATE event_controls SET flag_active = 0;
UPDATE treatment_controls SET flag_active = 0;

UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_9', 'clin_CAN_5', 'clin_CAN_4', 'clin_CAN_75', 'clin_CAN_10', 'clin_CAN_68');

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 20 AND id2 =10) OR (id1 = 10 AND id2 =20);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 9 AND id2 =9) OR (id1 = 9 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 10 AND id2 =9) OR (id1 = 9 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 14 AND id2 =9) OR (id1 = 9 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =14) OR (id1 = 14 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 14 AND id2 =4) OR (id1 = 4 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 9 AND id2 =4) OR (id1 = 4 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 10 AND id2 =4) OR (id1 = 4 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =10) OR (id1 = 10 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 11 AND id2 =4) OR (id1 = 4 AND id2 =11);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 19 AND id2 =4) OR (id1 = 4 AND id2 =19);

INSERT INTO `consent_controls` 
VALUES 
(null,'kidney transplant',1,'chum_kidney_transp_cd_generics','chum_kidney_transp_cd_generics',1,'kidney transplant');
CREATE TABLE `chum_kidney_transp_cd_generics` (
  `consent_master_id` int(11) NOT NULL,
  KEY `consent_master_id` (`consent_master_id`),
  CONSTRAINT `chum_kidney_transp_cd_generics_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `chum_kidney_transp_cd_generics_revs` (
  `consent_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO structures(`alias`) VALUES ('chum_kidney_transp_cd_generics');

INSERT INTO i18n (id,en,fr)
VALUES 
('kidney transplant', "Kidney/Transplant","Rein/Transplant.");

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_9');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Inventory
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`= '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` LIKE 'qc_nd_pathology_nbr_from_sardo');

UPDATE structure_formats SET `flag_override_default`='1', `default`= (SELECT id FROM banks WHERE name = 'Kidney/Rein Transplant.') 
WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_default`='1', `default`= (SELECT id FROM banks WHERE name = 'Kidney/Rein Transplant.') 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='bank_id'), 'notBlank', '');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'qc visit label');
UPDATE structure_permissible_values_customs SET en = REPLACE(value, 'V', ''), fr = REPLACE(value, 'V', '') WHERE control_id = @control_id;

-- Collection participant type and time

ALTER TABLE collections 
  ADD COLUMN chum_kidney_transp_collection_part_type VARCHAR(20) DEFAULT NULL,
  ADD COLUMN chum_kidney_transp_collection_time VARCHAR(20) DEFAULT NULL;
ALTER TABLE collections_revs
  ADD COLUMN chum_kidney_transp_collection_part_type VARCHAR(20) DEFAULT NULL,
  ADD COLUMN chum_kidney_transp_collection_time VARCHAR(20) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`)
(SELECT plugin, model, tablename, 'chum_kidney_transp_collection_part_type', 'input', NULL, '0', 'size=5', '', '', 'collection participant type', '' FROM structure_fields WHERE field = 'visit_label');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`)
(SELECT plugin, model, tablename, 'chum_kidney_transp_collection_time', 'input', NULL, '0', 'size=5', '', '', 'collection time', '' FROM structure_fields WHERE field = 'visit_label');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, language_label, language_tag, language_help,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_id, sfinew.id, display_column, display_order, language_heading, margin, '', '', '',
flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary, flag_float
FROM structure_formats sfo 
INNER JOIN structure_fields sfisource ON sfo.structure_field_id = sfisource.id AND sfisource.field = 'visit_label'
INNER JOIN structure_fields sfinew ON sfinew.field = 'chum_kidney_transp_collection_part_type' AND sfisource.field = 'visit_label' AND sfinew.model = sfisource.model);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, language_label, language_tag, language_help,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_id, sfinew.id, display_column, display_order, language_heading, margin, '', '', '',
flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary, flag_float
FROM structure_formats sfo 
INNER JOIN structure_fields sfisource ON sfo.structure_field_id = sfisource.id AND sfisource.field = 'visit_label'
INNER JOIN structure_fields sfinew ON sfinew.field = 'chum_kidney_transp_collection_time' AND sfisource.field = 'visit_label' AND sfinew.model = sfisource.model);

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='chum_kidney_transp_collection_part_type'), 'notBlank', ''),
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='chum_kidney_transp_collection_time'), 'notBlank', ''),
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='chum_kidney_transp_collection_part_type'), 'custom,/^((DC)|(DV)|(RR))(([1-9])|([1-9][0-9]))$/i', 'chum_kidney_transp_collection_part_type_format_error'),
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='chum_kidney_transp_collection_time'), 'custom,!^(([0-9]+)(([EN])|(N/E))([0-9]*))$!i', 'chum_kidney_transp_collection_time_format_error');

UPDATE structure_formats sfosource, structure_fields sfisource, structure_formats sfonew, structure_fields sfinew
SET sfonew.display_order = sfosource.display_order
WHERE sfisource.field = 'acquisition_label'
AND sfosource.structure_field_id = sfisource.id 
AND sfonew.structure_id = sfosource.structure_id
AND sfonew.structure_field_id = sfinew.id 
AND sfinew.field IN ('chum_kidney_transp_collection_part_type', 'chum_kidney_transp_collection_time') 
AND sfinew.model = sfisource.model;
  
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('chum_kidney_transp_collection_part_type_format_error', 'Value should be compliant with following formats: DC1, DC2, FV1, RR1, etc.', 'Le format de la valeur doit être similaire aux formats suivants: DC1, DC2, FV1, RR1, etc.'),
('chum_kidney_transp_collection_time_format_error', 'Value should be compliant with following formats: 1E, 1E2, 1N, 21N3, 21N/E3, etc.', 'Le format de la valeur doit être similaire aux formats suivants: 1E, 1E2, 1N, 21N3, 21N/E3, etc.'),
('collection participant type', 'Participant Type', 'Type (participant)'),
('collection time', 'Collection Time', 'Temps (collection)');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_tag`='' WHERE field='qc_nd_pathology_nbr' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_nd_pathology_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_nd_pathology_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_nd_pathology_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

-- Clinical Colelction Link
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model` LIKE 'Treatment%');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model` LIKE 'Event%');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_kidney_transp_collection_part_type'), '0', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_kidney_transp_collection_time'), '0', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Inventory Configuration
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('141', '222', '102', '23', '136', '195', '7', '101', '229', '144', '193', '137', '142', '223', '10', '145', '3', '4', '25', '143', '192');
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('217', '219', '218');

-- SampleMaster

UPDATE structure_formats SET`flag_add`='0',  `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_float`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='qc_nd_sample_label');

-- AliquotMaster

REPLACE INTO i18n (id,en,fr)
VALUES
('aliquot barcode', 'Barcode', 'Code-barres');

UPDATE aliquot_controls SET flag_active=true WHERE id IN('77');
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('66');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='1', `language_tag`='#' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'aliquot_label' AND model = 'AliquotMaster');
-- aliquot_masters
UPDATE structure_formats SET `display_column`='0', `display_order`='8', `flag_add`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- used_aliq_in_stock_details
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- view_aliquot_joined_to_sample_and_collection
UPDATE structure_formats SET `display_column`='0', `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
-- qctestedaliquots
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- view_aliquot_joined_to_sample
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- aliquot_masters_for_collection_tree_view
UPDATE structure_formats SET `display_order`='2', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- aliquot_masters_for_storage_tree_view
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- orderitems
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Tissue

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='type_code' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_labo_type_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='sequence_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='labo_laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_labo_tissue_laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tmp_buffer_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tmp_on_ice' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tissue_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_nd_surgery_biopsy_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tissue_nature') AND `flag_confidential`='0');

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Sources List')" WHERE domain_name = 'tissue_source_list';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Sources List', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sources List');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('spleen', 'Spleen',  'Rate', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('kidney', 'Kidney',  'Rein', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
UPDATE structure_fields SET  `default`='spleen' WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='tissue_source';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_gleason_primary_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gleason_grade_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_gleason_secondary_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gleason_grade_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_tissue_primary_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tissue_primary_desc') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_tissue_secondary_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tissue_primary_desc') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_origin_of_slice' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_slice_origins') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='tumor_presence' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Blood

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='type_code' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_labo_type_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='sequence_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_value_domains AS svd 
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id 
INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id 
SET `flag_active`="0" WHERE svd.domain_name='blood_type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Blood Types')" WHERE domain_name='blood_type';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Blood Types', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('edta (lavender)', 'EDTA (Lavender)',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('heparin (green)', 'Heparin (Green)',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('paxgene', 'PAXGene',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('none (red)', 'None (Red - Serum)',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

-- DNA

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas'); 
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas'); 

-- Urine

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='type_code' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_labo_type_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='sequence_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Quality Control And Path Review

UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_2224', 'inv_CAN_224', 'inv_CAN_225');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Storage
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 0;
UPDATE storage_controls SET flag_active = 1 WHERE storage_type IN ('box100', 'rack24', 'shelf', 'nitrogen locator', 'freezer', 'blocks box', 'room');

INSERT INTO `storage_controls` 
VALUES 
(null,'box100 1A-10J','column','integer',10,'row','alphabetical',10,0,0,0,0,0,0,0,1,'','std_boxs','custom#storage types#box100 1A-10J',1),
(null, 'rack24 4x6', 'position', 'integer', 24, NULL, NULL, NULL, 4, 6, 0, 0, 0, 0, 0, 1, '', 'std_customs', 'custom#storage types#rack24 4x6', 1),
(null, 'freezer24 6x4', 'position', 'integer', 24, NULL, NULL, NULL, 6, 4, 0, 0, 1, 0, 0, 1, '', 'std_customs', 'custom#storage types#freezer24 6x4', 1);
--
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('box100 1A-10J', 'Box100 1A-10J',  'Boîte100 1A-10J', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('rack24 4x6', 'Rack24 4x6',  'Râtelier24 4x6', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('freezer24 6x4', 'Freezer24 6x4',  'Congélateur100 1A-10J', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Other
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET flag_active = 0;
UPDATE structure_permissible_values_custom_controls SET flag_active = 1 WHERE name IN ('Aliquot Use and Event Types','Amp. RNA : Amp. method','Blood cell : Storage solution','Collection Times','DNA : Extraction method','DNA RNA : Storage solution','Family History Diagnosis List',
'information source','Institutions & Laboratories','Laboratory Sites','Laboratory Staff','laterality','Orders Contacts','Orders Institutions','Participant Message Types','Password Reset Questions',
'qc visit label','researchers','RNA : Extraction method','rna purification method',' cie','Specimen Collection Sites','Specimen Supplier Departments','Storage Coordinate Titles','Storage Types','Study Fundings',
'Study Status','Tissue : Storage method','Tissue : Storage solution','Tissue Core Natures','Tissue Sources List', 'qc consent version');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'qc consent version');
UPDATE structure_permissible_values_customs SET deleted = 1 WHERE control_id = @control_id;

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 13 AND id2 =5) OR (id1 = 5 AND id2 =13);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 13 AND id2 =1) OR (id1 = 1 AND id2 =13);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 16 AND id2 =26) OR (id1 = 26 AND id2 =16);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 26 AND id2 =22) OR (id1 = 22 AND id2 =26);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 26 AND id2 =25) OR (id1 = 25 AND id2 =26);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 21 AND id2 =1) OR (id1 = 1 AND id2 =21);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 21 AND id2 =15) OR (id1 = 15 AND id2 =21);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 15 AND id2 =5) OR (id1 = 5 AND id2 =15);

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'Report the RAMQ problems';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'list all related diagnosis';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'participant identifiers report';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ConsentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'FamilyHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'QualityCtrl' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'EventMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'SpecimenReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentExtendMaster' AND label = 'number of elements per participant';

SET @modified = (SELECT NOW() FROM users WHERE id = '1');
SET @modified_by = (SELECT id FROM users WHERE id = '1');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('hotel-dieu hospital', 'Hôtel-Dieu Hospital',  'Hôpital Hôtel-Dieu', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('notre-dame hospital', 'Notre-Dame Hospital',  'Hôpital Notre-Dame', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('saint-luc hospital', 'Saint-Luc Hospital',  'Hôpital Saint-Luc', '1', @control_id, @modified, @modified, @modified_by, @modified_by);


