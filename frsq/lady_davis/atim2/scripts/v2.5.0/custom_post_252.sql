
REPLACE INTO i18n (id,en,fr) VALUES
('has family history','Has Family History','Possède antécédents familiaux'),
('family history exists - field has family history updated', 
"Family history exists. Field 'Has Family History' has been set to 'yes'.", "Des antécédents familiaux existent. La donnée 'Possède antécédents familiaux' a été mise à jour. "),
("no more family histories exists - update the participant has family history", 
"No more family histories exist for this participant in the system. You may update the participant 'has family history' field at your convenience.",
"Les antécédents familiaux n'existent plus pour ce participant dans le système. Vous pouvez mettre a jour la donnée 'Possède antécédents familiaux'."),
('breast or ovarian cancer','Breast or ovarian cancer','Cancer du sein ou de l''ovaire');

SELECT '*************** CHECK yesrs quit smoking *******************************************' AS MSG;
SELECT IF(COUNT(*) = 0, 
"You have no entries into ed_all_lifestyle_smokings.years_quit_smoking. Drop that column.", 
"You have entries into ed_all_lifestyle_smokings.years_quit_smoking. Column has been deleted"
) AS msg FROM ed_all_lifestyle_smokings WHERE years_quit_smoking IS NOT NULL;

ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN years_quit_smoking;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN years_quit_smoking;

SELECT '*************** Check collection#: Participant having more than one collection *******************************************' AS MSG;
SELECT max_nbr, participant_id FROM (SELECT count(*) as max_nbr, participant_id FROM misc_identifiers WHERE misc_identifier_control_id = 9 AND deleted <> 1 GROUP BY participant_id) AS res WHERE res.max_nbr > 1;

UPDATE participants pa, misc_identifiers mi
SET pa.participant_identifier = mi.identifier_value
WHERE mi.misc_identifier_control_id = 9 AND mi.deleted <> 1
AND mi.participant_id = pa.id;
UPDATE participants pa SET pa.participant_identifier = 'N/A' WHERE pa.participant_identifier IS NULL AND pa.deleted <> 1;
UPDATE structure_formats SET `language_heading`='', `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES 
('participant identifier','Participant#','Participant#');
UPDATE misc_identifiers SET deleted = 1 WHERE misc_identifier_control_id = 9;
UPDATE misc_identifier_controls SET flag_active = 0 WHERE id = 9;

DROP TABLE IF EXISTS qc_lady_supplier_depts2;
DROP VIEW IF EXISTS qc_lady_supplier_depts2;
DROP TABLE IF EXISTS qc_lady_supplier_depts1;
DROP VIEW IF EXISTS qc_lady_supplier_depts1;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='' AND `model`='ViewCollection' AND `tablename`='view_collection' AND `field`='qc_lady_supplier_dept_grouped' AND `language_label`='supplier departments' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='' AND `model`='ViewCollection' AND `tablename`='view_collection' AND `field`='qc_lady_supplier_dept_grouped' AND `language_label`='supplier departments' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='' AND `model`='ViewCollection' AND `tablename`='view_collection' AND `field`='qc_lady_supplier_dept_grouped' AND `language_label`='supplier departments' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='200' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_pre_op' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pre-op' AND `language_tag`=''), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `display_order`='102' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qc_lady_pre_op' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='103' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_banking_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='104' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_visit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='102' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_pre_op' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE collections SET collection_datetime = null, collection_datetime_accuracy = null WHERE collection_datetime LIKE '0000-00-00%';

INSERT INTO `banks` (`name`) VALUES ('Unknown/Inconnue');
INSERT INTO`banks_revs` (`name`, `id`) (SELECT `name`, `id` FROM banks WHERE  name = 'Unknown/Inconnue');
SET @bank_id = (SELECT `id` FROM banks WHERE  name = 'Unknown/Inconnue') ;
UPDATE collections SET bank_id = @bank_id WHERE bank_id IS NULL OR bank_id LIKE '';

TRUNCATE acos;
UPDATE users SET username = 'NicoEn', first_name = 'Nicolas', last_name = 'L', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- NEW REQUESTS
--
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE collections ADD COLUMN misc_identifier_id int(11) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN misc_identifier_id int(11) DEFAULT NULL;
ALTER TABLE `collections`
  ADD CONSTRAINT `collections_ibfk_misc_identifiers` FOREIGN KEY (`misc_identifier_id`) REFERENCES `misc_identifiers` (`id`);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'misc_identifier_value', 'input',  NULL , '0', 'size=20', '', '', 'bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='misc_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank identifier' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'misc_identifier_value', 'input',  NULL , '0', 'size=20', '', '', 'bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='misc_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank identifier' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'misc_identifier_value', 'input',  NULL , '0', 'size=20', '', '', 'bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='misc_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank identifier' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
REPLACE INTO i18n (id,en,fr) VALUES
('bank identifier','Bank identifier','Identifiant de banque'),
('error_fk_frsq_number_linked_collection','Your data cannot be deleted! This identifier is linked to a collection.','Vos données ne peuvent être supprimées! Cet identifiant est attaché à une collection.');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'consent form versions');
INSERT INTO `structure_permissible_values_customs` (`value`, `control_id`, `use_as_input`) 
(SELECT distinct form_version, @control_id, 1 FROM consent_masters WHERE form_version NOT IN (SELECT value FROM structure_permissible_values_customs WHERE control_id = @control_id)  AND form_version NOT LIKE '');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_has_family_history' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES ('last name','Last Name','Nom');
ALTER TABLE participants ADD COLUMN qc_lady_spouse_name varchar(50) default null;
ALTER TABLE participants_revs ADD COLUMN qc_lady_spouse_name varchar(50) default null;
INSERT INTO i18n (id,en,fr) VALUES ('name of spouse','Name of spouse','Nom du conjoint');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_lady_spouse_name', 'input',  NULL , '0', 'size=30', '', '', 'name of spouse', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_spouse_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='name of spouse' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('date_of_referral','route_of_referral','date_first_contact','consent_person','consent_method','process_status','translator_indicator','translator_signature','facility_other','facility'));
ALTER TABLE consent_masters ADD COLUMN qc_lady_form_lang varchar(50) default null;
ALTER TABLE consent_masters_revs ADD COLUMN qc_lady_form_lang varchar(50) default null;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qc_lady_consent_from_lang", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Consent : Form language\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Consent : Form language', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent : Form language');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('en', '', '', '1', @control_id, NOW(), NOW(), 1, 1),
('fr', '', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'qc_lady_form_lang', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_consent_from_lang') , '0', '', '', '', '', 'language');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_lady_form_lang' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_consent_from_lang')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='language'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE treatment_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster'));

UPDATE event_controls SET flag_active = 0 WHERE id NOT IN (30,51);
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Clinical%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lab%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/study%';
UPDATE menus SET  use_link = '/ClinicalAnnotation/EventMasters/listall/lifestyle/%%Participant.id%%', flag_active = 1 WHERE id = 'clin_CAN_4';

UPDATE diagnosis_controls SET flag_active = 0;
UPDATE diagnosis_masters SET deleted = 1;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE consent_controls SET detail_form_alias = CONCAT(detail_form_alias,',qc_lady_breast_consent') WHERE id = 1;
UPDATE consent_controls SET detail_form_alias = CONCAT(detail_form_alias,',qc_lady_qcroc_consent') WHERE id IN (2,3);
ALTER TABLE cd_nationals 
  ADD COLUMN qc_lady_biological_material_use_and_data_access char(1) default '',
  ADD COLUMN qc_lady_allow_blood_collection char(1) default '',
  ADD COLUMN qc_lady_contact_for_additional_data char(1) default '',
  ADD COLUMN qc_lady_use_for_other_research char(1) default '';
ALTER TABLE cd_nationals_revs
  ADD COLUMN qc_lady_biological_material_use_and_data_access char(1) default '',
  ADD COLUMN qc_lady_allow_blood_collection char(1) default '',
  ADD COLUMN qc_lady_contact_for_additional_data char(1) default '',
  ADD COLUMN qc_lady_use_for_other_research char(1) default '';
INSERT INTO structures(`alias`) VALUES ('qc_lady_qcroc_consent'),('qc_lady_breast_consent');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_nationals', 'qc_lady_biological_material_use_and_data_access', 'yes_no',  NULL , '0', '', '', '', 'biological material collection and access clinical data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_nationals', 'qc_lady_allow_blood_collection', 'yes_no',  NULL , '0', '', '', '', 'blood collection', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_nationals', 'qc_lady_contact_for_additional_data', 'yes_no',  NULL , '0', '', '', '', 'contact for additional data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_nationals', 'qc_lady_use_for_other_research', 'yes_no',  NULL , '0', '', '', '', 'use for other research', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_breast_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_nationals' AND `field`='qc_lady_biological_material_use_and_data_access'), '2', '1', 'agreements', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_breast_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_nationals' AND `field`='qc_lady_allow_blood_collection'), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_breast_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_nationals' AND `field`='qc_lady_contact_for_additional_data'), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_lady_qcroc_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_nationals' AND `field`='qc_lady_use_for_other_research'), '2', '4', '', '1', 'agreements', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='agreements', `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_qcroc_consent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_nationals' AND `field`='qc_lady_use_for_other_research' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES
('biological material collection and access clinical data', 'Biological material collection and access clinical data', 'Collecte de matériel biologique et accès données cliniques'),
('blood collection', 'Blood collection', 'Collecte sang'),
('use for other research', 'Use for other research', 'Utilisation pour autre recherche'),
('agreements','Agreements','Accords'),
('contact for additional data','Contact for additional data','Contacter pour données additionnelles');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', 'collection', '1', 'bank identifier', '0', '', '0', '', '0', '', '1', 'size=20', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------------------------------
-- Tissue & Blood collection clean up
-- --------------------------------------------------------------------------------------------------------------------------------

SELECT '*************** List all collections having both blood and tissue before clean up *******************************************' AS MSG;
SELECT distinct col.id AS collection_with_both_tissue_and_blood_that_will_be_cleaned
FROM collections AS col
INNER JOIN sample_masters AS sm_t ON sm_t.collection_id = col.id AND sm_t.deleted <> 1 AND sm_t.sample_control_id = 3
INNER JOIN sample_masters AS sm_b ON sm_b.collection_id = col.id AND sm_b.deleted <> 1 AND sm_b.sample_control_id = 2
WHERE col.deleted <> 1;
SELECT '*************** Check no specimen review exists *******************************************' AS MSG;
SELECT count(*) AS nbr_of_specimen_review_should_be_0 from specimen_review_masters;

ALTER TABLE collections ADD COLUMN tmp_blood_collection_id_to_move int(11) default null;
INSERT INTO `collections` 
(`tmp_blood_collection_id_to_move`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `participant_id`, `diagnosis_master_id`, `consent_master_id`, `treatment_master_id`, `event_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `qc_lady_type`, `qc_lady_follow_up`, `qc_lady_pre_op`, `qc_lady_banking_nbr`, `qc_lady_visit`, `misc_identifier_id`) 
(SELECT `id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `participant_id`, `diagnosis_master_id`, `consent_master_id`, `treatment_master_id`, `event_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `qc_lady_type`, `qc_lady_follow_up`, `qc_lady_pre_op`, `qc_lady_banking_nbr`, `qc_lady_visit`, `misc_identifier_id` FROM collections
WHERE id IN (SELECT distinct col.id
FROM collections AS col
INNER JOIN sample_masters AS sm_t ON sm_t.collection_id = col.id AND sm_t.deleted <> 1 AND sm_t.sample_control_id = 3
INNER JOIN sample_masters AS sm_b ON sm_b.collection_id = col.id AND sm_b.deleted <> 1 AND sm_b.sample_control_id = 2
WHERE col.deleted <> 1));
UPDATE collections SET qc_lady_type = 'blood' WHERE tmp_blood_collection_id_to_move IS NOT NULL;
UPDATE sample_masters sm_b, collections col
SET sm_b.collection_id = col.id 
WHERE col.tmp_blood_collection_id_to_move IS NOT NULL
AND col.tmp_blood_collection_id_to_move = sm_b.collection_id AND sm_b.sample_control_id = 2;
UPDATE sample_masters sm_b, collections col, sample_masters sm_der 
SET sm_der.collection_id = col.id 
WHERE col.tmp_blood_collection_id_to_move IS NOT NULL
AND col.id = sm_b.collection_id AND sm_b.sample_control_id = 2 
AND sm_b.id = sm_der.initial_specimen_sample_id AND sm_der.sample_control_id != 2;
UPDATE sample_masters sm, collections col, aliquot_masters am 
SET am.collection_id = col.id 
WHERE col.tmp_blood_collection_id_to_move IS NOT NULL
AND col.id = sm.collection_id 
AND sm.id = am.sample_master_id;
INSERT INTO `collections_revs` (`bank_id`, `collection_site`, `collection_datetime`, `sop_master_id`, `collection_property`, `collection_notes`, `qc_lady_type`, `qc_lady_follow_up`, `qc_lady_pre_op`, `qc_lady_banking_nbr`, `qc_lady_visit`, `collection_datetime_accuracy`, `modified_by`, `id`, `version_created`)
(SELECT `bank_id`, `collection_site`, `collection_datetime`, `sop_master_id`, `collection_property`, `collection_notes`, `qc_lady_type`, `qc_lady_follow_up`, `qc_lady_pre_op`, `qc_lady_banking_nbr`, `qc_lady_visit`, `collection_datetime_accuracy`, 
`created_by`, `id`, `created` FROM collections WHERE tmp_blood_collection_id_to_move IS NOT NULL);
UPDATE sample_masters_revs sm_r, sample_masters sm, collections col
SET sm_r.collection_id = sm.collection_id
WHERE col.tmp_blood_collection_id_to_move IS NOT NULL AND col.id = sm.collection_id AND sm.id = sm_r.id;
UPDATE sample_masters sm, collections col, aliquot_masters_revs am_r
SET am_r.collection_id = sm.collection_id
WHERE col.tmp_blood_collection_id_to_move IS NOT NULL AND col.id = sm.collection_id AND sm.id = am_r.sample_master_id;
ALTER TABLE collections DROP COLUMN tmp_blood_collection_id_to_move;

UPDATE sample_controls sc, sample_masters sm, specimen_details spe, collections col
SET spe.reception_datetime = col.collection_datetime, spe.reception_datetime_accuracy = col.collection_datetime_accuracy
WHERE sc.sample_type IN ('blood')
AND sm.sample_control_id = sc.id AND sm.deleted <> 1
AND col.id = sm.collection_id AND (col.collection_datetime IS NOT NULL AND col.collection_datetime NOT LIKE '')
AND spe.sample_master_id = sm.id AND (spe.reception_datetime IS NULL OR spe.reception_datetime LIKE '');
UPDATE sample_controls sc, sample_masters sm, derivative_details der, collections col
SET der.creation_datetime = col.collection_datetime, der.creation_datetime_accuracy = col.collection_datetime_accuracy
WHERE sc.sample_type IN ('pbmc','plasma','serum')
AND sm.sample_control_id = sc.id AND sm.deleted <> 1
AND col.id = sm.collection_id AND (col.collection_datetime IS NOT NULL AND col.collection_datetime NOT LIKE '')
AND der.sample_master_id = sm.id AND (der.creation_datetime IS NULL OR der.creation_datetime LIKE '');
UPDATE sample_controls sc, sample_masters sm, derivative_details der, aliquot_masters am
SET am.storage_datetime = der.creation_datetime, am.storage_datetime_accuracy = der.creation_datetime_accuracy
WHERE sc.sample_type IN ('pbmc','plasma','serum')
AND sm.sample_control_id = sc.id AND sm.deleted <> 1
AND der.sample_master_id = sm.id AND (der.creation_datetime IS NOT NULL AND der.creation_datetime NOT LIKE '')
AND am.sample_master_id = sm.id AND (am.storage_datetime IS NULL OR am.storage_datetime LIKE '') AND am.deleted <> 1;

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Collection : Blood type precision', 1, 40),
('Collection : Tissue type precision', 1, 40);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Collection : Blood type precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('unspecified','Unspecified','Non spécifié', '1', @control_id, NOW(), NOW(), 1, 1),
('adjuvant', 'Adjuvant', 'Adjuvant', '1', @control_id, NOW(), NOW(), 1, 1),
('neoadjuvant', 'Neoadjuvant', 'Neoadjuvant', '1', @control_id, NOW(), NOW(), 1, 1),
('metastatic', 'Metastatic', 'Métastatique', '1', @control_id, NOW(), NOW(), 1, 1),
('normal', 'Normal', 'Normal', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Collection : Tissue type precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('unspecified','Unspecified','Non spécifié', '1', @control_id, NOW(), NOW(), 1, 1),
('normal surgery', 'Normal (Surg.)', 'Normal (Chir.)', '1', @control_id, NOW(), NOW(), 1, 1),
('tumor surgery', 'Trumor (Surg.)', 'Tumeur (Chir.)', '1', @control_id, NOW(), NOW(), 1, 1),
('primary biopsy', 'Primary biopsy ', 'Biopsie de primaire', '1', @control_id, NOW(), NOW(), 1, 1),
('metastasis biopsy', 'Metastasis biopsy', 'Biopsie de métastase', '1', @control_id, NOW(), NOW(), 1, 1);
ALTER TABLE collections 
  ADD COLUMN qc_lady_specimen_type VARCHAR(50) DEFAULT null,
  ADD COLUMN qc_lady_specimen_type_precision VARCHAR(50) DEFAULT null;
ALTER TABLE collections_revs
  ADD COLUMN qc_lady_specimen_type VARCHAR(50) DEFAULT null,
  ADD COLUMN qc_lady_specimen_type_precision VARCHAR(50) DEFAULT null;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qc_lady_collection_specimen_type", "", "", NULL),
("qc_lady_collection_specimen_type_precision", "", "", "InventoryManagement.Collection::getSpecimenTypePrecision");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_collection_specimen_type"), (SELECT id FROM structure_permissible_values WHERE value="tissue" AND language_alias="tissue"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_collection_specimen_type"), (SELECT id FROM structure_permissible_values WHERE value="blood" AND language_alias="blood"), "", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qc_lady_specimen_type_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_specimen_type_precision') , '0', '', '', '', 'collection specimen type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_specimen_type_precision'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_specimen_type_precision'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qc_lady_specimen_type_precision'), 'notEmpty', '', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qc_lady_specimen_type_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_specimen_type_precision') , '0', '', '', '', 'collection specimen type', ''), 
('InventoryManagement', 'ViewCollection', '', 'qc_lady_specimen_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_specimen_type') , '0', '', '', '', 'collection specimen type unspecified', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_lady_specimen_type_precision'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_lady_specimen_type'), '1', '98', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
REPLACE INTO i18n (id,en,fr) VALUES 
('collection specimen type','Specimen type','Type de spécimen'),
('collection specimen type unspecified', 'Specimen type (unspecified)','Type de spécimen (non précisé)');

SELECT '*************** List all collections having both blood and tissue after clean up *******************************************' AS MSG;
SELECT distinct col.id AS check_no_collection_with_both_tissue_and_blood
FROM collections AS col
INNER JOIN sample_masters AS sm_t ON sm_t.collection_id = col.id AND sm_t.deleted <> 1 AND sm_t.sample_control_id = 3
INNER JOIN sample_masters AS sm_b ON sm_b.collection_id = col.id AND sm_b.deleted <> 1 AND sm_b.sample_control_id = 2
WHERE col.deleted <> 1;

SELECT '*************** Check sample_type of a collection samples versus col.qc_lady_type *******************************************' AS MSG;
SELECT sc.sample_type, col.qc_lady_type, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
GROUP BY sc.sample_type, col.qc_lady_type; 
SELECT sc.sample_type, col.qc_lady_type, col.id
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
WHERE sc.sample_type = 'tissue' AND col.qc_lady_type = 'blood'; 

UPDATE collections col, sample_masters sm, sample_controls sc
SET col.qc_lady_specimen_type = 'tissue' , col.qc_lady_specimen_type_precision = 'tissue||unspecified'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
AND col.qc_lady_type = 'blood'; 
UPDATE collections col, sample_masters sm, sample_controls sc
SET col.qc_lady_specimen_type = 'tissue' , col.qc_lady_specimen_type_precision = 'tissue||unspecified'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
AND (col.qc_lady_type IS NULL OR col.qc_lady_type LIKE ''); 
UPDATE collections col, sample_masters sm, sample_controls sc
SET col.qc_lady_specimen_type = 'tissue' , col.qc_lady_specimen_type_precision = 'tissue||primary biopsy'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
AND col.qc_lady_type = 'biopsy'; 
UPDATE collections col, sample_masters sm, sample_controls sc
SET col.qc_lady_specimen_type = 'tissue' , col.qc_lady_specimen_type_precision = 'tissue||metastasis biopsy'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
AND col.qc_lady_type = 'metastasis'; 
UPDATE collections col, sample_masters sm, sample_controls sc
SET col.qc_lady_specimen_type = 'tissue' , col.qc_lady_specimen_type_precision = 'tissue||normal surgery'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
AND col.qc_lady_type = 'normal'; 
UPDATE collections col, sample_masters sm, sample_controls sc
SET col.qc_lady_specimen_type = 'tissue' , col.qc_lady_specimen_type_precision = 'tissue||tumor surgery'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
AND col.qc_lady_type = 'tumor'; 

SELECT '*************** Display coll type and precision versus collection samples type for tissue *******************************************' AS MSG;
SELECT sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
GROUP BY sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision; 

SELECT '*************** Display coll type and precision versus collection samples type for blood *******************************************' AS MSG;
SELECT sc.sample_type, col.qc_lady_type, sd.qc_lady_clinical_status, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
INNER JOIN sd_spe_bloods sd ON sm.id = sd.sample_master_id
GROUP BY sc.sample_type, col.qc_lady_type, sd.qc_lady_clinical_status, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision; 

UPDATE collections col, sample_masters sm, sample_controls sc, sd_spe_bloods sd
SET col.qc_lady_specimen_type = 'blood' , col.qc_lady_specimen_type_precision = 'blood||adjuvant'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
AND sm.id = sd.sample_master_id
AND col.qc_lady_type = 'blood'
AND sd.qc_lady_clinical_status = 'adjuvant'; 
UPDATE collections col, sample_masters sm, sample_controls sc, sd_spe_bloods sd
SET col.qc_lady_specimen_type = 'blood' , col.qc_lady_specimen_type_precision = 'blood||metastatic'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
AND sm.id = sd.sample_master_id
AND col.qc_lady_type = 'blood'
AND sd.qc_lady_clinical_status = 'metastatic'; 
UPDATE collections col, sample_masters sm, sample_controls sc, sd_spe_bloods sd
SET col.qc_lady_specimen_type = 'blood' , col.qc_lady_specimen_type_precision = 'blood||neoadjuvant'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
AND sm.id = sd.sample_master_id
AND col.qc_lady_type = 'blood'
AND sd.qc_lady_clinical_status = 'neoadjuvant'; 
UPDATE collections col, sample_masters sm, sample_controls sc, sd_spe_bloods sd
SET col.qc_lady_specimen_type = 'blood' , col.qc_lady_specimen_type_precision = 'blood||unspecified'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
AND sm.id = sd.sample_master_id
AND col.qc_lady_specimen_type IS NULL; 

SELECT '*************** Display collection having more than one blood clinical status *******************************************' AS MSG;
SELECT sc.sample_type, col.qc_lady_type, sd.qc_lady_clinical_status, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
INNER JOIN sd_spe_bloods sd ON sm.id = sd.sample_master_id
GROUP BY sc.sample_type, col.qc_lady_type, sd.qc_lady_clinical_status, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision; 
SELECT res_2.tot AS blood_coll_with_diff_blood_clinical_status, res_2.sample_type, res_2.collection_id
FROM (
	SELECT count(*) as tot, res_1.sample_type, res_1.collection_id
	FROM (
		SELECT distinct sc.sample_type, sd.qc_lady_clinical_status, col.id as collection_id
		FROM collections col
		INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
		INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'blood'
		INNER JOIN sd_spe_bloods sd ON sm.id = sd.sample_master_id
	) res_1
	GROUP BY res_1.sample_type, res_1.collection_id
) res_2
WHERE res_2.tot > 1;

SELECT '*************** Display to check samples type versus collection type *******************************************' AS MSG;
SELECT sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_category = 'specimen'
GROUP BY sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision; 

SELECT '*************** Display all collections having no qc_lady_specimen_type *******************************************' AS MSG;
SELECT col.id AS collection_id_to_check_no_sample_perhaps FROM collections col WHERE col.deleted != 1 AND col.qc_lady_specimen_type IS NULL;

SELECT '*************** Check tissue collection *******************************************' AS MSG;
SELECT sc.sample_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, col.qc_lady_type, sd.qc_lady_from_biopsy, sd.qc_lady_from_surgery, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
INNER JOIN sd_spe_tissues sd ON sm.id = sd.sample_master_id
GROUP BY sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, sd.qc_lady_from_biopsy, sd.qc_lady_from_surgery; 
SELECT col.id AS collection_id, col.qc_lady_specimen_type_precision, col.qc_lady_type, sd.qc_lady_from_biopsy, sd.qc_lady_from_surgery
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
INNER JOIN sd_spe_tissues sd ON sm.id = sd.sample_master_id
WHERE (col.qc_lady_specimen_type_precision = 'tissue||metastasis biopsy' AND col.qc_lady_type = 'metastasis' AND sd.qc_lady_from_surgery = '1')
OR (col.qc_lady_specimen_type_precision = 'tissue||unspecified' AND col.qc_lady_type = 'blood')
OR (col.qc_lady_specimen_type_precision = 'tissue||unspecified' AND sd.qc_lady_from_biopsy = '1');

UPDATE structure_fields SET language_label = CONCAT('**', language_label, ' TO DELETE **') WHERE field IN ('qc_lady_type','qc_lady_from_biopsy','qc_lady_from_surgery','qc_lady_clinical_status');

UPDATE structure_formats SET `language_heading`='blood collection data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_lady_follow_up' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='tissue collection data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qc_lady_visit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='blood collection data' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='tissue collection data' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_visit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='blood collection data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='tissue collection data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_visit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUE ('tissue collection data','Tissue collection data','Données de collection de tissu'),('blood collection data','Blood collection data','Données de collection de sang');

UPDATE collections SET qc_lady_pre_op = '1' WHERE qc_lady_follow_up = '0';

UPDATE collections col, misc_identifiers ide, misc_identifier_controls idc
SET col.misc_identifier_id = ide.id
WHERE col.deleted <> 1 
AND col.participant_id = ide.participant_id AND ide.deleted <> 1
AND idc.id = ide.misc_identifier_control_id AND idc.misc_identifier_name IN ('Breast bank #','Q-CROC-03')
AND (col.misc_identifier_id IS NULL OR col.misc_identifier_id LIKE '')
AND col.participant_id IN (
	SELECT res_2.participant_id FROM 
	(
		SELECT res.participant_id, count(*) AS nbr_ident FROM 
		(
			SELECT part.id AS participant_id, idc.misc_identifier_name, ide.identifier_value
			FROM participants part
			INNER JOIN misc_identifiers ide ON ide.participant_id = part.id AND ide.deleted <> 1 
			INNER JOIN misc_identifier_controls idc ON idc.id = ide.misc_identifier_control_id AND idc.misc_identifier_name IN ('Breast bank #','Q-CROC-03')
		) AS res
		GROUP BY res.participant_id
	) AS res_2 WHERE nbr_ident = 1
);

INSERT INTO cd_nationals (consent_master_id) (SELECT id FROM consent_masters WHERE id NOT IN (SELECT consent_master_id FROM cd_nationals));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_specimen_type_precision'), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_column`='0', `flag_index`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_specimen_type_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_specimen_type_precision') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_specimen_type_precision'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="QUAIAMP Kit" AND spv.language_alias="QUAIAMP Kit";
DELETE FROM structure_permissible_values WHERE value="QUAIAMP Kit" AND language_alias="QUAIAMP Kit";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="other" AND spv.language_alias="other";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="TE BUffer" AND spv.language_alias="TE Buffer";
DELETE FROM structure_permissible_values WHERE value="TE BUffer" AND language_alias="TE Buffer";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Extraction : Method\')" WHERE domain_name = 'qc_lady_dna_extraction_method';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Extraction : Storage solution\')" WHERE domain_name = 'qc_lady_dna_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Extraction : Method', 1, 50),('Extraction : Storage solution', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Extraction : Method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('QUAIAMP Kit', '', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Extraction : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('TE Buffer', '', '', '1', @control_id, NOW(), NOW(), 1, 1),
('other', 'Other', 'Autre', '1', @control_id, NOW(), NOW(), 1, 1);
ALTER TABLE ad_tubes MODIFY `qc_lady_storage_solution` varchar(50) NOT NULL DEFAULT '';
ALTER TABLE ad_tubes_revs MODIFY `qc_lady_storage_solution` varchar(50) NOT NULL DEFAULT '';
ALTER TABLE sd_der_dnas MODIFY `qc_lady_storage_solution` varchar(50) NOT NULL DEFAULT '',MODIFY `qc_lady_extraction_method` varchar(50) NOT NULL DEFAULT '';
ALTER TABLE sd_der_dnas_revs MODIFY `qc_lady_storage_solution` varchar(50) NOT NULL DEFAULT '',MODIFY `qc_lady_extraction_method` varchar(50) NOT NULL DEFAULT '';
UPDATE ad_tubes SET qc_lady_storage_solution = 'TE Buffer' WHERE qc_lady_storage_solution = 'TE BUffer';
UPDATE sd_der_dnas SET qc_lady_storage_solution = 'TE Buffer' WHERE qc_lady_storage_solution = 'TE BUffer';

INSERT INTO i18n (id,en,fr) VALUES ('the collection type and the type of the specimen you are trying to create do not match','The collection type and the type of the specimen you are trying to create do not match','le type de collection et le type de l''échantillon que vous essayez de créer ne correspondent pas');

ALTER TABLE `sd_spe_tissues` MODIFY `qc_lady_tissue_type` varchar(30) DEFAULT NULL;
ALTER TABLE `sd_spe_tissues_revs` MODIFY `qc_lady_tissue_type` varchar(30) DEFAULT NULL;
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="TBR" AND spv.language_alias="TBR";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="NBR" AND spv.language_alias="NBR";
DELETE FROM structure_permissible_values WHERE value="TBR" AND language_alias="TBR";
DELETE FROM structure_permissible_values WHERE value="NBR" AND language_alias="NBR";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Type\')" WHERE domain_name = 'qc_lady_tissue_type';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Type', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('NBR', '', '', '1', @control_id, NOW(), NOW(), 1, 1),
('TBR', '', '', '1', @control_id, NOW(), NOW(), 1, 1),
('metastasis', 'Metastasis', 'Métastase','1', @control_id, NOW(), NOW(), 1, 1);

ALTER TABLE `qc_lady_screening_biopsy_revs` MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `collections` MODIFY `qc_lady_pre_op` char(1) default '';
ALTER TABLE `collections_revs` MODIFY `qc_lady_pre_op` char(1) default '';
UPDATE collections SET qc_lady_pre_op = 'y' WHERE qc_lady_pre_op = '1';
UPDATE collections SET qc_lady_pre_op = '' WHERE qc_lady_pre_op = '0';
UPDATE collections SET qc_lady_pre_op = '' WHERE qc_lady_pre_op IS NULL;
UPDATE collections_revs SET qc_lady_pre_op = 'y' WHERE qc_lady_pre_op = '1';
UPDATE collections_revs SET qc_lady_pre_op = '' WHERE qc_lady_pre_op = '0';
UPDATE collections_revs SET qc_lady_pre_op = '' WHERE qc_lady_pre_op IS NULL;
UPDATE structure_fields SET type = 'yes_no', structure_value_domain = NULL WHERE field = 'qc_lady_pre_op';

SELECT '*************** CHECK collection fields conflicts with type tissue/blood *******************************************' AS MSG;
SELECT id AS collection_id, qc_lady_specimen_type, qc_lady_pre_op, qc_lady_follow_up, qc_lady_banking_nbr FROM collections 
WHERE qc_lady_specimen_type = 'tissue' 
AND (qc_lady_pre_op NOT LIKE '' OR qc_lady_follow_up IS NOT NULL OR qc_lady_banking_nbr IS NOT NULL);
SELECT id AS collection_id, qc_lady_specimen_type, qc_lady_pre_op, qc_lady_follow_up, qc_lady_banking_nbr FROM collections 
WHERE qc_lady_specimen_type = 'blood' 
AND qc_lady_visit NOT LIKE '';

INSERT INTO i18n (id,en,fr) VALUES ('the fields you are completing cannot be used for a collection having %s type', 'The fields you are completing cannot be used for a collection having %s type', 'Les champs que vous remplissez ne peuvent pas être utilisés pour une collection ayant le type %s');

SELECT '*************** CHECK supported sample types *******************************************' AS MSG;
SELECT distinct sc.sample_type FROM sample_controls sc INNER JOIN sample_masters sm ON sm.sample_control_id = sc.id AND sm.deleted <>1;

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(158);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131, 135, 136, 132, 130, 101);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='441' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qc_lady_tissue_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_type') AND `flag_confidential`='0');

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="ganglion" AND spv.language_alias="ganglion";
DELETE FROM structure_permissible_values WHERE value="ganglion" AND language_alias="ganglion";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Source\')" WHERE domain_name = 'tissue_source_list';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Source', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Source');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('ganglion', 'Ganglion', 'Ganglion','1', @control_id, NOW(), NOW(), 1, 1);

SELECT '*************** CHECK metastasis biopsy AND qc_lady_tissue_type *******************************************' AS MSG;
SELECT col.id, col.qc_lady_specimen_type_precision, tis.qc_lady_tissue_type
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sd_spe_tissues tis ON tis.sample_master_id = sm.id
WHERE col.qc_lady_specimen_type_precision = 'tissue||metastasis biopsy' AND tis.qc_lady_tissue_type NOT LIKE '';

UPDATE collections col, sample_masters sm, sd_spe_tissues tis
SET tis.qc_lady_tissue_type = 'metastasis'
WHERE sm.collection_id = col.id AND sm.deleted <> 1
AND tis.sample_master_id = sm.id
AND col.qc_lady_specimen_type_precision = 'tissue||metastasis biopsy';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="RNA later" AND spv.language_alias="rna later";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="OCT" AND spv.language_alias="OCT";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="flash freeze" AND spv.language_alias="flash freeze";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="formalin" AND spv.language_alias="formalin";
DELETE FROM structure_permissible_values WHERE value="RNA later" AND language_alias="rna later";
DELETE FROM structure_permissible_values WHERE value="OCT" AND language_alias="OCT";
DELETE FROM structure_permissible_values WHERE value="flash freeze" AND language_alias="flash freeze";
DELETE FROM structure_permissible_values WHERE value="formalin" AND language_alias="formalin";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Storage solution\')" WHERE domain_name = 'qc_lady_tissue_tube_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Storage solution', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('RNA later', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('OCT', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('flash freeze', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('formalin', '', '','1', @control_id, NOW(), NOW(), 1, 1);

UPDATE ad_tubes SET qc_lady_storage_solution = 'flash freeze' WHERE qc_lady_storage_solution = 'flash free';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qc_lady_storage_solution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_storage_solution') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qc_lady_extraction_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_extraction_method') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SELECT '*************** CHECK no DNA tube storage solution *******************************************' AS MSG;
SELECT distinct sc.sample_type, dna.qc_lady_storage_solution, tb.qc_lady_storage_solution
FROM sample_controls sc
INNER JOIN sample_masters sm ON sm.sample_control_id = sc.id AND sm.deleted <>1 AND sc.sample_type = 'DNA'
INNEr JOIN sd_der_dnas dna ON dna.sample_master_id = sm.id
INNER JOIN aliquot_masters am ON am.sample_master_id = sm.id AND am.deleted <>1
INNER JOIN ad_tubes tb ON tb.aliquot_master_id = am.id;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_solution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_storage_solution') AND `flag_confidential`='0');

UPDATE sample_controls SET detail_form_alias = 'qc_lady_sd_der_dnas,derivatives' WHERE sample_type  = 'RNA';
ALTER TABLE sd_der_rnas 
  ADD COLUMN `qc_lady_storage_solution` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_lady_extraction_method` varchar(50) NOT NULL DEFAULT '';
ALTER TABLE sd_der_rnas_revs 
  ADD COLUMN `qc_lady_storage_solution` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_lady_extraction_method` varchar(50) NOT NULL DEFAULT '';

UPDATE sample_controls sc, aliquot_controls ac
SET ac.aliquot_type_precision = NULL,
ac.detail_form_alias = 'ad_der_tubes_qc_lady_dnas',
ac.detail_tablename  = 'ad_tubes',	
ac.volume_unit = 'ml',
ac.comment = 'derivative tube specifid to rna'
WHERE ac.sample_control_id = sc.id AND sc.sample_type = 'RNA';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE quality_ctrls ADD COLUMN `concentration` decimal(10,2) DEFAULT NULL, ADD COLUMN  `concentration_unit` varchar(20) DEFAULT NULL;
ALTER TABLE quality_ctrls_revs ADD COLUMN `concentration` decimal(10,2) DEFAULT NULL, ADD COLUMN  `concentration_unit` varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'concentration', 'float_positive',  NULL , '0', 'size=5', '', '', 'concentration', ''), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'concentration_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='concentration' AND `language_tag`=''), '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='concentration_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('concentration','Concentration','Concentration');

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="unknown" AND spv.language_alias="unknown";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="EDTA" AND spv.language_alias="EDTA";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="gel CSA" AND spv.language_alias="gel CSA";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="heparin" AND spv.language_alias="heparin";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="paxgene" AND spv.language_alias="paxgene";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="ZCSA" AND spv.language_alias="ZCSA";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="serum" AND spv.language_alias="serum";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="CTAD" AND spv.language_alias="CTAD";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="P100" AND spv.language_alias="P100";
DELETE FROM structure_permissible_values WHERE value="EDTA" AND language_alias="EDTA";
DELETE FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA";
DELETE FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin";
DELETE FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene";
DELETE FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA";
DELETE FROM structure_permissible_values WHERE value="serum" AND language_alias="serum";
DELETE FROM structure_permissible_values WHERE value="CTAD" AND language_alias="CTAD";
DELETE FROM structure_permissible_values WHERE value="P100" AND language_alias="P100";

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Blood : Type\')" WHERE domain_name = 'blood_type';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Blood : Type', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood : Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('EDTA', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('gel CSA', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('serum', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('CTAD', '', '','1', @control_id, NOW(), NOW(), 1, 1),
('P100', '', '','1', @control_id, NOW(), NOW(), 1, 1);

ALTER TABLE collections
  ADD COLUMN qc_lady_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qc_lady_sop_deviations text AFTER qc_lady_sop_followed;  
 ALTER TABLE collections_revs
  ADD COLUMN qc_lady_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qc_lady_sop_deviations text AFTER qc_lady_sop_followed;  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qc_lady_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'Collection', 'collections', 'qc_lady_sop_deviations', 'textarea',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_deviations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_followed' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_deviations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_sop_followed' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qc_lady_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'ViewCollection', '', 'qc_lady_sop_deviations', 'textarea',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_lady_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_lady_sop_deviations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

ALTER TABLE sample_masters
  ADD COLUMN qc_lady_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qc_lady_sop_deviations text AFTER qc_lady_sop_followed;  
 ALTER TABLE sample_masters_revs
  ADD COLUMN qc_lady_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qc_lady_sop_deviations text AFTER qc_lady_sop_followed;  
INSERT INTO structures(`alias`) VALUES ('qc_lady_derivative_sop');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qc_lady_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qc_lady_sop_deviations', 'textarea',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_derivative_sop'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_lady_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_derivative_sop'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sop' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_derivative_sop'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_lady_sop_deviations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',qc_lady_derivative_sop') WHERE detail_form_alias LIKE '%qc_lady_sd_der_dnas%' OR detail_form_alias LIKE '%sd_der_cell_cultures%';

INSERT IGNORE INTO i18n (id,en, fr) VALUES 
('sop deviations', 'SOP deviations', 'SOP déviations'),
('sop followed', 'SOP followed', 'SOP suivi');

ALTER TABLE ad_tubes 
  ADD COLUMN qc_lady_hemoysis_color VARCHAR(30) DEFAULT null,
  ADD COLUMN qc_lady_hemoysis_color_other VARCHAR(30) DEFAULT null;
ALTER TABLE ad_tubes_revs 
  ADD COLUMN qc_lady_hemoysis_color VARCHAR(30) DEFAULT null,
  ADD COLUMN qc_lady_hemoysis_color_other VARCHAR(30) DEFAULT null;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_hemoysis_color", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("yellow", "yellow");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_hemoysis_color"), (SELECT id FROM structure_permissible_values WHERE value="yellow" AND language_alias="yellow"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pink", "pink");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_hemoysis_color"), (SELECT id FROM structure_permissible_values WHERE value="pink" AND language_alias="pink"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("red", "red");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_hemoysis_color"), (SELECT id FROM structure_permissible_values WHERE value="red" AND language_alias="red"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_hemoysis_color"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'qc_lady_hemoysis_color', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_hemoysis_color') , '0', '', '', '', 'hemolysis signs', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'qc_lady_hemoysis_color_other', 'input',  NULL , '0', 'size-10', '', '', '', 'other specify');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_hemolysis'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_lady_hemoysis_color' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_hemoysis_color')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hemolysis signs' AND `language_tag`=''), '1', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_hemolysis'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_lady_hemoysis_color_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size-10' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other specify'), '1', '91', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_hemolysis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='hemolysis_signs' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
Replace INTO i18n (id,en, fr) VALUES 
("yellow", "Yellow",'Jaune'),
("pink", "Pink",'Rose'),
("red", "Red",'Rouge'),
('other specify', 'Specify (other)', 'Spécifier (autre)'); 
UPDATE ad_tubes SET qc_lady_hemoysis_color = 'yellow' WHERE hemolysis_signs = 'n';
UPDATE ad_tubes SET qc_lady_hemoysis_color = 'red' WHERE hemolysis_signs = 'y';

UPDATE collections SET  qc_lady_specimen_type_precision = 'tissue||tumor surgery' WHERE participant_id IN (
SELECT participant_id from misc_identifiers WHERE identifier_value REGEXP "^T-[0-9]$|^T-[0-9][0-9]$|^T-1[0-9][0-9]$" AND deleted <> 1) AND deleted <> 1 AND qc_lady_specimen_type = 'tissue';

SELECT '*************** TODO Done *******************************************' AS MSG;
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('qc_lady_type','qc_lady_from_biopsy','qc_lady_from_surgery','qc_lady_clinical_status'));
DELETE FROM structure_fields WHERE field IN ('qc_lady_type','qc_lady_from_biopsy','qc_lady_from_surgery','qc_lady_clinical_status');
ALTER TABLE sd_spe_tissues DROP COLUMN qc_lady_from_biopsy, DROP COLUMN qc_lady_from_surgery;
ALTER TABLE sd_spe_tissues_revs DROP COLUMN qc_lady_from_biopsy, DROP COLUMN qc_lady_from_surgery;
ALTER TABLE sd_spe_bloods DROP COLUMN qc_lady_clinical_status;
ALTER TABLE sd_spe_bloods_revs DROP COLUMN qc_lady_clinical_status;
ALTER TABLE collections DROP COLUMN qc_lady_type;
ALTER TABLE collections_revs DROP COLUMN qc_lady_type;

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', "<FONT color='red'>Lady Davis - Breast - Test</FONT>",  "<FONT color='red'>Lady Davis - Sein - Test</FONT>");

UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',qc_lady_derivative_sop') WHERE sample_type LIKE 'blood';

SELECT '*************** Merg collections surgery tum. & surgery norm. : Patient # to check *******************************************' AS MSG;
SELECT '--- Without Date conditions --' AS conditions;
SELECT participant_identifier FROM participants 
WHERE id IN (SELECT participant_id FROM collections WHERE deleted <> 1 AND qc_lady_specimen_type_precision = 'tissue||tumor surgery') 
AND id IN (SELECT participant_id FROM collections WHERE deleted <> 1 AND qc_lady_specimen_type_precision = 'tissue||normal surgery') 
AND deleted <> 1 ORDER BY participant_identifier;
SELECT '--- With same collection date --' AS conditions;
SELECT participants.participant_identifier, tum_col.id AS tum_col_id, norm_col.id AS norm_col_id,
CONCAT(norm_col.collection_site,'|',tum_col.collection_site) AS collection_site ,
CONCAT(norm_col.bank_id,'|',tum_col.bank_id) AS bank_id,
CONCAT(norm_col.sop_master_id,'|',tum_col.sop_master_id) AS sop_master_id,
CONCAT(norm_col.qc_lady_visit,'|',tum_col.qc_lady_visit) AS qc_lady_visit
FROM collections AS tum_col
INNER JOIN collections AS norm_col ON tum_col.participant_id = norm_col.participant_id
INNER JOIN participants  ON norm_col.participant_id = participants.id
WHERE tum_col.deleted <> 1 AND tum_col.qc_lady_specimen_type_precision = 'tissue||tumor surgery'
AND  norm_col.deleted <> 1 AND norm_col.qc_lady_specimen_type_precision = 'tissue||normal surgery'
AND norm_col.collection_datetime = tum_col.collection_datetime
AND norm_col.collection_datetime_accuracy = tum_col.collection_datetime_accuracy
ORDER BY participant_identifier;

ALTER TABLE collections ADD COLUMN tmp_new_collection_id int(11) default null;
UPDATE collections AS tum_col, collections AS norm_col
SET norm_col.tmp_new_collection_id = tum_col.id
WHERE tum_col.participant_id = norm_col.participant_id
AND tum_col.deleted <> 1 AND tum_col.qc_lady_specimen_type_precision = 'tissue||tumor surgery'
AND  norm_col.deleted <> 1 AND norm_col.qc_lady_specimen_type_precision = 'tissue||normal surgery'
AND norm_col.collection_datetime = tum_col.collection_datetime
AND norm_col.collection_datetime_accuracy = tum_col.collection_datetime_accuracy;
UPDATE sample_masters sm, collections col
SET sm.collection_id = col.tmp_new_collection_id 
WHERE col.tmp_new_collection_id IS NOT NULL
AND col.id = sm.collection_id AND sm.deleted <> 1;
UPDATE aliquot_masters am, collections col
SET am.collection_id = col.tmp_new_collection_id 
WHERE col.tmp_new_collection_id IS NOT NULL
AND col.id = am.collection_id AND am.deleted <> 1;
UPDATE sample_masters_revs sm_r, sample_masters sm
SET sm_r.collection_id = sm.collection_id
WHERE sm_r.collection_id != sm.collection_id AND sm_r.id = sm.id
AND sm.collection_id IN (SELECT tmp_new_collection_id FROM collections WHERE tmp_new_collection_id IS NOT NULL);
UPDATE aliquot_masters_revs am_r, aliquot_masters am
SET am_r.collection_id = am.collection_id
WHERE am_r.collection_id != am.collection_id AND am_r.id = am.id
AND am.collection_id IN (SELECT tmp_new_collection_id FROM collections WHERE tmp_new_collection_id IS NOT NULL);
UPDATE collections SET deleted = 1 WHERE tmp_new_collection_id IS NOT NULL;
ALTER TABLE collections DROP COLUMN tmp_new_collection_id;
SELECT '--- Last collections with normal chir changed to chir: to check --' AS conditions;
SELECT col.id, part.participant_identifier FROM collections col INNER JOIN participants part ON part.id = col.participant_id WHERE qc_lady_specimen_type_precision = 'tissue||normal surgery' AND col.deleted <> 1;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Collection : Tissue type precision');
UPDATE structure_permissible_values_customs SET value = 'surgery', `en` = 'Surgery', `fr` = 'Chirurgie'
WHERE control_id = @control_id AND value = 'tumor surgery';
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value = 'normal surgery';

UPDATE collections SET qc_lady_specimen_type_precision = 'tissue||surgery' WHERE qc_lady_specimen_type_precision LIKE 'tissue||% surgery' AND deleted <> 1;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- New requests (2012-10-09)
-- ---------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE sd_spe_tissues ADD COLUMN qc_lady_tumor_location varchar(50) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN qc_lady_tumor_location varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qc_lady_tissue_tumor_location", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Tumor location\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Tumor location', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Tumor location');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('q upper inside', 'Q Upper Inside', '', '1', @control_id, NOW(), NOW(), 1, 1),
('q upper outside', 'Q Upper Outside', '', '1', @control_id, NOW(), NOW(), 1, 1),
('q lower inside', 'Q Lower Inside', '', '1', @control_id, NOW(), NOW(), 1, 1),
('q lower outside', 'Q Lower Outside', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'qc_lady_tumor_location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tumor_location') , '0', '', '', '', 'tumor location', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qc_lady_tumor_location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tumor_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor location' AND `language_tag`=''), '1', '444', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('tumor location','Tumor Location','Localisation de la tumeur');

UPDATE structure_formats SET `display_order`='450', `language_heading`='tissue from OR' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE sd_spe_tissues ADD COLUMN qc_lady_under_radiological_guidance char(1) DEFAULT '';
ALTER TABLE sd_spe_tissues_revs ADD COLUMN qc_lady_under_radiological_guidance char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qc_lady_under_radiological_guidance', 'yes_no',  NULL , '0', '', '', '', 'under radiological guidance', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_lady_under_radiological_guidance' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='under radiological guidance' AND `language_tag`=''), '1', '455', 'bx primary / metastasis', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES 
('under radiological guidance', 'Under radiological guidance', 'Sous guidage radiologique'),
('bx primary / metastasis', 'Bx primary/metastasis', 'Biopsie prim./métas.'),
('tissue from OR', 'Tissue from OR', 'Tissu de la Salle d''OP.');

REPLACE INTO i18n (id,en,fr) VALUE ('pbmc', 'Buffy coat','Buffy coat'), ('PBMC Tube', 'Buffy coat Tube', 'Tube de Buffy coat');

-- ALTER TABLE sd_der_plasmas DROP COLUMN qc_lady_centri_1, DROP COLUMN qc_lady_centri_1_duration_min, DROP COLUMN qc_lady_centri_1_unit;
-- ALTER TABLE sd_der_plasmas_revs DROP COLUMN qc_lady_centri_1, DROP COLUMN qc_lady_centri_1_duration_min, DROP COLUMN qc_lady_centri_1_unit;
-- ALTER TABLE sd_der_serums DROP COLUMN qc_lady_coagulation_time_sec, DROP COLUMN qc_lady_centri_1_rpm, DROP COLUMN qc_lady_centri_1_duration_min, DROP COLUMN qc_lady_centri_2_rpm, DROP COLUMN qc_lady_centri_2_duration_min;
-- ALTER TABLE sd_der_serums_revs DROP COLUMN qc_lady_coagulation_time_sec, DROP COLUMN qc_lady_centri_1_rpm, DROP COLUMN qc_lady_centri_1_duration_min, DROP COLUMN qc_lady_centri_2_rpm, DROP COLUMN qc_lady_centri_2_duration_min;
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename IN ('sd_der_serums','sd_der_plasmas') AND field LIKE 'qc_lady_centri_%');
DELETE FROM structure_fields WHERE tablename IN ('sd_der_serums','sd_der_plasmas') AND field LIKE 'qc_lady_centri_%';
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field LIKE 'qc_lady_coagulation_time_sec');
DELETE FROM structure_fields WHERE field LIKE 'qc_lady_coagulation_time_sec';

REPLACE INTO i18n (id,en,fr) VALUES ('creation date','Processing date','Date du traitement');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('hemolysis signs','Color','Couleur');

INSERT INTO structures(`alias`) VALUES ('qc_lady_ad_der_pbmc');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_der_pbmc'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE sample_controls sc, aliquot_controls ac SET ac.detail_form_alias = 'qc_lady_ad_der_pbmc' WHERE sc.sample_type = 'pbmc' AND sc.id = ac.sample_control_id;

ALTER TABLE ad_tubes ADD COLUMN qc_lady_storage_method VARCHAR(50) DEFAULT '';
ALTER TABLE ad_tubes_revs ADD COLUMN qc_lady_storage_method VARCHAR(50) DEFAULT '';
UPDATE ad_tubes SET qc_lady_storage_solution = '', qc_lady_storage_method = 'flash freeze' WHERE qc_lady_storage_solution = 'flash freeze ';
UPDATE ad_tubes_revs SET qc_lady_storage_solution = '', qc_lady_storage_method = 'flash freeze' WHERE qc_lady_storage_solution = 'flash freeze ';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Storage solution');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value = 'flash freeze';
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qc_lady_tissue_tube_storage_method", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Storage method\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Storage method', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Storage method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('flash freeze', '', '','1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'qc_lady_storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_method') , '0', '', '', '', 'storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('storage method','Storage method', 'Méthode d''entreposage');

SELECT '*************** Collections with type undefined: to complete *******************************************' AS MSG;
select id AS collection_id from collections where (qc_lady_specimen_type_precision is null or qc_lady_specimen_type_precision like '') OR (qc_lady_specimen_type_precision is null or qc_lady_specimen_type_precision like '');
SELECT '-------- Collections with type undefined with sample (should be empty) -------- ' AS MSG;
SELECT id AS collection_id_issue FROM sample_masters 
WHERE collection_id IN (
select id from collections where (qc_lady_specimen_type_precision is null or qc_lady_specimen_type_precision like '') OR (qc_lady_specimen_type_precision is null or qc_lady_specimen_type_precision like '')
)
AND deleted != 1;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='tool' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_qc_tool') AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qc_lady_quality_control_type", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Quality Ctrl : Type\')");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_quality_control_type')  WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_type');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Quality Ctrl : Type', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Quality Ctrl : Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT id,en,fr,'1', @control_id, NOW(), NOW(), 1, 1 FROM i18n WHERE id IN ('bioanalyzer','spectrophotometer','pcr','agarose gel','immunohistochemistry'));

UPDATE aliquot_controls ac, sample_controls sc
SET ac.volume_unit = 'ul'
WHERE ac.sample_control_id = sc.id AND sc.sample_type IN ('rna','dna');
UPDATE aliquot_masters am, aliquot_controls ac, sample_controls sc
SET am.initial_volume = am.initial_volume*1000, am.current_volume = am.current_volume*1000
WHERE am.deleted <> 1 AND am.aliquot_control_id = ac.id AND ac.sample_control_id = sc.id AND  sc.sample_type IN ('rna','dna')
AND (am.initial_volume IS NOT NULL AND am.initial_volume NOT LIKE '');
SELECT '*************** DNA RNA uses to check no volume has to be changed to ul *******************************************' AS MSG;
SELECT aliquot_master_id, use_definition, use_code, used_volume, aliquot_volume_unit FROM view_aliquot_uses WHERE aliquot_master_id IN (
	SELECT am.id
	FROM aliquot_masters am, aliquot_controls ac, sample_controls sc
	WHERE am.deleted <> 1 AND am.aliquot_control_id = ac.id AND ac.sample_control_id = sc.id AND  sc.sample_type IN ('rna','dna')
	AND (am.initial_volume IS NOT NULL AND am.initial_volume NOT LIKE '')
);

REPLACE INTO i18n (id,en,fr) VALUES 
("the barcode [%s] has already been recorded","The barcode [%s] has already been recorded!","Le code à barres [%s] a déjà été enregistré!"),
("you can not record barcode [%s] twice","You can not record barcode [%s] twice!","Vous ne pouvez enregistrer le code à barres [%s] deux fois!");

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/adhocs/%';

UPDATE versions SET build_number = '4914' WHERE build_number = '4882' AND version_number = '2.5.2';

