
REPLACE INTO i18n (id,en,fr) VALUES
('has family history','Has Family History','Possède antécédents familiaux'),
('family history exists - field has family history updated', 
"Family history exists. Field 'Has Family History' has been set to 'yes'.", "Des antécédents familiaux existent. La donnée 'Possède antécédents familiaux' a été mise à jour. "),
("no more family histories exists - update the participant has family history", 
"No more family histories exist for this participant in the system. You may update the participant 'has family history' field at your convenience.",
"Les antécédents familiaux n'existent plus pour ce participant dans le système. Vous pouvez mettre a jour la donnée 'Possède antécédents familiaux'."),
('breast or ovarian cancer','Breast or ovarian cancer','Cancer du sein ou de l''ovaire');

SELECT IF(COUNT(*) = 0, 
"You have no entries into ed_all_lifestyle_smokings.years_quit_smoking. Drop that column.", 
"You have entries into ed_all_lifestyle_smokings.years_quit_smoking. Column has been deleted"
) AS msg FROM ed_all_lifestyle_smokings WHERE years_quit_smoking IS NOT NULL;

ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN years_quit_smoking;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN years_quit_smoking;

SELECT 'Check collection#: Participant having more than one collection#' as MSG;
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

SELECT distinct col.id AS collection_with_both_tissue_and_blood_that_will_be_cleaned
FROM collections AS col
INNER JOIN sample_masters AS sm_t ON sm_t.collection_id = col.id AND sm_t.deleted <> 1 AND sm_t.sample_control_id = 3
INNER JOIN sample_masters AS sm_b ON sm_b.collection_id = col.id AND sm_b.deleted <> 1 AND sm_b.sample_control_id = 2
WHERE col.deleted <> 1;
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







-- >> full_breast_dev.sql
SELECT 'exit >> full_breast_dev.sql' as msg;
exit 









SELECT distinct col.id AS check_no_collection_with_both_tissue_and_blood
FROM collections AS col
INNER JOIN sample_masters AS sm_t ON sm_t.collection_id = col.id AND sm_t.deleted <> 1 AND sm_t.sample_control_id = 3
INNER JOIN sample_masters AS sm_b ON sm_b.collection_id = col.id AND sm_b.deleted <> 1 AND sm_b.sample_control_id = 2
WHERE col.deleted <> 1;
SELECT count(*) AS nbr_of_specimen_review_should_be_0 from specimen_review_masters;

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
SELECT sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
GROUP BY sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision; 

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
SELECT sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision, count(*)
FROM collections col
INNER JOIN sample_masters sm ON sm.collection_id = col.id AND sm.deleted <> 1
INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_category = 'specimen'
GROUP BY sc.sample_type, col.qc_lady_type, col.qc_lady_specimen_type, col.qc_lady_specimen_type_precision; 

SELECT col.id AS collection_id_to_check_no_sample_perhaps FROM collections col WHERE col.deleted != 1 AND col.qc_lady_specimen_type IS NULL;

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
OR (col.qc_lady_specimen_type_precision = 'tissue||unspecified' AND sd.qc_lady_from_biopsy = '1')

UPDATE structure_fields SET language_label = CONCAT('**', language_label, ' TO DELETE **') WHERE field IN ('qc_lady_type','qc_lady_from_biopsy','qc_lady_from_surgery','qc_lady_clinical_status');
SELECT "DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('qc_lady_type','qc_lady_from_biopsy','qc_lady_from_surgery','qc_lady_clinical_status'));
DELETE FROM structure_fields WHERE field IN ('qc_lady_type','qc_lady_from_biopsy','qc_lady_from_surgery','qc_lady_clinical_status');
ALTER TABLE sd_spe_tissues DROP COLUMN qc_lady_from_biopsy, DROP COLUMN qc_lady_from_surgery;
ALTER TABLE sd_spe_tissues_revs DROP COLUMN qc_lady_from_biopsy, DROP COLUMN qc_lady_from_surgery;
ALTER TABLE sd_spe_bloods DROP COLUMN qc_lady_clinical_status;
ALTER TABLE sd_spe_bloods_revs DROP COLUMN qc_lady_clinical_status;
ALTER TABLE collections DROP COLUMN qc_lady_type;
ALTER TABLE collections_revs DROP COLUMN qc_lady_type;"AS RUN_FOLLWING_QUERY_AFTER_MIGRATION ;

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
















