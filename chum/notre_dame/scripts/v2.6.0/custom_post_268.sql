
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Removed link to 'xenograft' (See Samples/Aliquots Controls)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'xenograft');
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'cord blood');
SET @control_id = (SELECT id 
FROM realiquoting_controls 
WHERE parent_aliquot_control_id = (select id from aliquot_controls WHERE databrowser_label LIKE 'tissue|block')
AND child_aliquot_control_id IN (select id from aliquot_controls WHERE databrowser_label LIKE 'tissue|tube') LIMIT 0 ,1);
DELETE FROM realiquoting_controls WHERE id = @control_id;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Changed way consent is linked to study : Use trunk method
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_masters SET study_summary_id = qc_nd_study_summary_id;
UPDATE consent_masters_revs SET study_summary_id = qc_nd_study_summary_id;

ALTER TABLE `consent_masters` DROP FOREIGN KEY `FK_consent_masters_study_summaries`;
ALTER TABLE `consent_masters` DROP FOREIGN KEY `FK_consent_masters_study_summaries_2`;
ALTER TABLE `consent_masters` DROP COLUMN qc_nd_study_summary_id;
ALTER TABLE `consent_masters_revs` DROP COLUMN qc_nd_study_summary_id;
ALTER TABLE `consent_masters`
  ADD CONSTRAINT `FK_consent_masters_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);

UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_cd_study', 'consent_masters_study');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_study');
DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id';
DELETE FROM  structures WHERE alias='qc_nd_cd_study';

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='1', `language_tag`='-' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_consent_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Removed Annotation>Study forms
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Moved Annotation>Study values to to MiscIdentifier when idenitifer value is set
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO misc_identifier_controls (misc_identifier_name, flag_active, flag_link_to_study) VALUES ('study number', 1, 1);
SET @misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'study number');
UPDATE misc_identifier_controls SET flag_unique = 0, flag_confidential = 0 WHERE id = @misc_identifier_control_id;
INSERT INTO i18n (id,en,fr) VALUES ('study number', 'Study #', 'Étude #');

UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, created, created_by, modified, modified_by, flag_unique, study_summary_id)
(SELECT identifier, @misc_identifier_control_id, participant_id, created, created_by, modified, modified_by, null, study_summary_id
FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id 
WHERE identifier IS NOT NULL AND identifier NOT LIKE '' AND deleted <> 1);
INSERT INTO misc_identifiers_revs (id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, study_summary_id, version_created, modified_by)
(SELECT id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, study_summary_id, created, created_by FROM misc_identifiers WHERE misc_identifier_control_id = @misc_identifier_control_id);
INSERT INTO misc_identifiers_revs (id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, study_summary_id, version_created, modified_by)
(SELECT id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, study_summary_id, modified, modified_by FROM misc_identifiers WHERE misc_identifier_control_id = @misc_identifier_control_id AND modified != created);

SET @date=(SELECT NOW() FROM users WHERE id = 2);
UPDATE event_masters SET deleted = 1, modified = @date, modified_by = 2 WHERE id IN (
SELECT event_master_id FROM (
	SELECT event_master_id FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id  WHERE identifier IS NOT NULL AND identifier NOT LIKE '' AND deleted <> 1
) res);

-- Moved Annotation>Study values flagged as 'CE:15.247%' to Aliquot (APS project)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT event_master_id 'ERR #6674889484: Study Event To Manage (Not an APS project)'
FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id 
WHERE deleted <> 1 AND (event_summary NOT LIKE 'CE:15.247%' OR study_summary_id != (SELECT id FROM study_summaries WHERE title = 'Projet APS'));

UPDATE aliquot_internal_uses 
SET study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS'), modified = @date, modified_by = 2
WHERE use_code = 'Projet APS' AND deleted <> 1 AND study_summary_id IS NULL;
INSERT INTO aliquot_internal_uses_revs (id,aliquot_master_id,type,use_code,use_details,used_volume,use_datetime,use_datetime_accuracy,
duration,duration_unit,used_by,study_summary_id,modified_by,version_created)
(SELECT id,aliquot_master_id,type,use_code,use_details,used_volume,use_datetime,use_datetime_accuracy,
duration,duration_unit,used_by,study_summary_id,modified_by,modified FROM aliquot_internal_uses WHERE modified = @date AND modified_by = 2);

SELECT DISTINCT participant_id 'ERR #6674889484: Participant linked to APS project with no aliquot linked to APS'
FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id
WHERE deleted <> 1 AND study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS')
AND participant_id NOT IN (
	SELECT DISTINCT participant_id 
	FROM collections INNER JOIN aliquot_masters ON collections.id = aliquot_masters.collection_id INNER JOIN aliquot_internal_uses ON aliquot_masters.id = aliquot_internal_uses.aliquot_master_id 
	WHERE aliquot_internal_uses.deleted <> 1 AND aliquot_internal_uses.study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS')
);
UPDATE aliquot_masters 
SET study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS') 
WHERE (study_summary_id = (SELECT id FROM study_summaries WHERE title ='CHUM - Prostate') OR  study_summary_id IS NULL)
AND deleted <> 1
AND id IN (SELECT aliquot_master_id
FROM aliquot_internal_uses WHERE aliquot_internal_uses.deleted <> 1 AND aliquot_internal_uses.study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS'));
UPDATE aliquot_masters_revs
SET study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS') 
WHERE (study_summary_id = (SELECT id FROM study_summaries WHERE title ='CHUM - Prostate') OR  study_summary_id IS NULL)
AND id IN (SELECT aliquot_master_id
FROM aliquot_internal_uses WHERE aliquot_internal_uses.deleted <> 1 AND aliquot_internal_uses.study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Projet APS'));

-- End of the update
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE event_masters SET deleted = 1, modified = @date, modified_by = 2 WHERE id IN (
SELECT event_master_id FROM (
	SELECT event_master_id FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id  WHERE deleted <> 1
) res);

INSERT INTO event_masters_revs (id,event_control_id,event_status,event_summary,event_date,event_date_accuracy,information_source,urgency,date_required,date_required_accuracy,date_requested,date_requested_accuracy,
reference_number,modified_by,participant_id,diagnosis_master_id,version_created)
(SELECT id,event_control_id,event_status,event_summary,event_date,event_date_accuracy,information_source,urgency,date_required,date_required_accuracy,date_requested,date_requested_accuracy,
reference_number,modified_by,participant_id,diagnosis_master_id,modified FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id WHERE modified = @date);
INSERT INTO qc_nd_ed_studies_revs (study_summary_id, identifier, event_master_id, version_created)
(SELECT study_summary_id, identifier, event_master_id, modified FROM event_masters INNER JOIN qc_nd_ed_studies ON id = event_master_id WHERE modified = @date);

UPDATE event_controls SET flag_active = 0 WHERE event_type = 'study';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Study%';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_studies');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_study_participants');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_studies' AND `field`='study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_studies' AND `field`='identifier' AND `language_label`='patient identifier' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_studies' AND `field`='study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='qc_nd_ed_studies' AND `field`='identifier' AND `language_label`='patient identifier' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structures WHERE alias='qc_nd_ed_studies';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Hided Annotation > Lifestyle
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

select id 'ERR#43434343: Lifestyle data exists' from event_masters WHERE event_control_id = (SELECT id FROM event_controls WHERE event_type = 'questionnaire' AND flag_active = 1);
UPDATE event_controls SET flag_active = 0 WHERE event_type = 'study';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lifestyle%';
UPDATE event_controls SET flag_Active = 0 WHERE event_type = 'questionnaire' AND flag_active = 1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Added option to create Message in batch
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Order:
--   - Display barcode for shipped items
--   - Display all fields of order from in search and index mode
--   - Removed microarray field and add information to the title
--   - Order contact is now a text field
--   - Created 'Institutions & Laboratories' custom list
--   - Added order reasearcher field
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0', `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='comments' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_order_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='microarray_chip' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='default_required_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='comments' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_order_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='microarray_chip' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='default_required_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE orders MODIFY short_title VARCHAR(200) DEFAULT null;
ALTER TABLE orders_revs MODIFY short_title VARCHAR(200) DEFAULT null;

UPDATE orders SET short_title = null WHERE short_title = '' OR short_title = 'NULL';
UPDATE orders SET type = null WHERE type = '' OR type = 'NULL';
UPDATE orders SET microarray_chip = null WHERE microarray_chip = '' OR microarray_chip = 'NULL';
UPDATE orders SET short_title = CONCAT('Microarray : ',short_title) WHERE type = 'microarray' AND short_title IS NOT NULL AND microarray_chip IS NULL;
UPDATE orders SET short_title = CONCAT('Microarray [',microarray_chip,'] : ',short_title) WHERE type = 'microarray' AND short_title IS NOT NULL AND microarray_chip IS NOT NULL;
UPDATE orders SET short_title = microarray_chip WHERE (type != 'microarray' OR type IS NULL) AND microarray_chip IS NOT NULL AND short_title IS NULL;
UPDATE orders SET short_title = CONCAT(short_title, ' [',microarray_chip,']') WHERE (type != 'microarray' OR type IS NULL) AND microarray_chip IS NOT NULL AND short_title IS NOT NULL;
UPDATE orders SET short_title = 'Microarray' WHERE type = 'microarray' AND short_title IS NULL AND microarray_chip IS NULL;
UPDATE orders SET short_title = CONCAT('Microarray [',microarray_chip,']') WHERE type = 'microarray' AND short_title IS NULL AND microarray_chip IS NOT NULL;

UPDATE orders_revs SET short_title = null WHERE short_title = '' OR short_title = 'NULL';
UPDATE orders_revs SET type = null WHERE type = '' OR type = 'NULL';
UPDATE orders_revs SET microarray_chip = null WHERE microarray_chip = '' OR microarray_chip = 'NULL';
UPDATE orders_revs SET short_title = CONCAT('Microarray : ',short_title) WHERE type = 'microarray' AND short_title IS NOT NULL AND microarray_chip IS NULL;
UPDATE orders_revs SET short_title = CONCAT('Microarray [',microarray_chip,'] : ',short_title) WHERE type = 'microarray' AND short_title IS NOT NULL AND microarray_chip IS NOT NULL;
UPDATE orders_revs SET short_title = microarray_chip WHERE (type != 'microarray' OR type IS NULL) AND microarray_chip IS NOT NULL AND short_title IS NULL;
UPDATE orders_revs SET short_title = CONCAT(short_title, ' [',microarray_chip,']') WHERE (type != 'microarray' OR type IS NULL) AND microarray_chip IS NOT NULL AND short_title IS NOT NULL;
UPDATE orders_revs SET short_title = 'Microarray' WHERE type = 'microarray' AND short_title IS NULL AND microarray_chip IS NULL;
UPDATE orders_revs SET short_title = CONCAT('Microarray [',microarray_chip,']') WHERE type = 'microarray' AND short_title IS NULL AND microarray_chip IS NOT NULL;

ALTER TABLE orders DROP COLUMN microarray_chip;
ALTER TABLE orders_revs DROP COLUMN microarray_chip;
ALTER TABLE orders DROP COLUMN type;
ALTER TABLE orders_revs DROP COLUMN type;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id IN (SELECT id FROM structure_fields WHERE`model`='Order' AND `field` IN ('type', 'microarray_chip'));
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE`model`='Order' AND `field` IN ('type', 'microarray_chip'));
DELETE FROM structure_fields WHERE `model`='Order' AND `field` IN ('type', 'microarray_chip');

UPDATE structure_fields SET  `type`='input',  `structure_value_domain`= NULL  WHERE model='Order' AND tablename='orders' AND field='contact' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'orders contacts');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_customs_revs WHERE control_id = @control_id;
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE id = @control_id;

ALTER TABLE orders MODIFY institution VARCHAR(100) DEFAULT NULL;
ALTER TABLE orders_revs MODIFY institution VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_institutions_and_laboratories', "StructurePermissibleValuesCustom::getCustomDropdown('Institutions & Laboratories')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Institutions & Laboratories', 1, 100, 'order');
SET @control_id_new_institution_and_lab = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories');
SET @control_id_order_institution = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'orders institutions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT `value`, `en`, `fr`, `use_as_input`, @control_id_new_institution_and_lab, `modified`, `created`, `created_by`, `modified_by`
FROM structure_permissible_values_customs WHERE control_id = @control_id_order_institution);
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified_by`, `version_created`)
(SELECT `value`, `en`, `fr`, `use_as_input`, @control_id_new_institution_and_lab, `modified_by`, `version_created`
FROM structure_permissible_values_customs_revs WHERE control_id = @control_id_order_institution
ORDER BY version_id ASC);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id_order_institution;
DELETE FROM structure_permissible_values_customs_revs WHERE control_id = @control_id_order_institution;
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE id = @control_id_order_institution;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_institutions_and_laboratories') ,  `language_label`='laboratory / institution' WHERE model='Order' AND tablename='orders' AND field='institution' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution');
INSERT INTO i18n (id,en,fr) VALUES ('laboratory / institution','Laboratory/Institution','Laboratoire/Institution');

ALTER TABLE orders ADD COLUMN qc_nd_researcher VARCHAR(50) DEFAULT NULL;
ALTER TABLE orders_revs ADD COLUMN qc_nd_researcher VARCHAR(50) DEFAULT NULL;
UPDATE structure_value_domains SET domain_name = 'qc_nd_researchers' WHERE domain_name = 'custom_researchers';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Order', 'orders', 'qc_nd_researcher', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') , '0', '', '', '', 'researcher', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orders'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='qc_nd_researcher' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='researcher' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='institution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_institutions_and_laboratories') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='qc_nd_researcher' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='default_study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
SET @control_id_institution_and_lab = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories');
SET @control_id_researcher = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'researchers');
UPDATE orders order_to_update, structure_permissible_values_customs c_list_institution, structure_permissible_values_customs c_list_researcher
SET order_to_update.qc_nd_researcher = c_list_researcher.value
WHERE c_list_institution.control_id = @control_id_institution_and_lab AND c_list_researcher.control_id = @control_id_researcher
AND c_list_researcher.en = c_list_institution.en
AND order_to_update.institution = c_list_institution.value;
UPDATE orders_revs order_to_update, structure_permissible_values_customs c_list_institution, structure_permissible_values_customs c_list_researcher
SET order_to_update.qc_nd_researcher = c_list_researcher.value
WHERE c_list_institution.control_id = @control_id_institution_and_lab_and_lab AND c_list_researcher.control_id = @control_id_researcher
AND c_list_researcher.en = c_list_institution.en
AND order_to_update.institution = c_list_institution.value;
UPDATE orders SET institution = '' WHERE qc_nd_researcher IS NOT NULL;
UPDATE orders_revs SET institution = '' WHERE qc_nd_researcher IS NOT NULL;
SET @control_id_institution_and_lab = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id_institution_and_lab AND value NOT IN (SELECT DISTINCT institution FROM orders);
DELETE FROM structure_permissible_values_customs_revs WHERE control_id = @control_id_institution_and_lab AND value NOT IN (SELECT DISTINCT institution FROM orders);

SET @control_id_institution_and_lab = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories');
SET @control_id_researcher = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'researchers');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT REPLACE(value, 'Labo ', 'Dr '), en, fr, `use_as_input`, @control_id_researcher, `modified`, `created`, `created_by`, `modified_by`
FROM structure_permissible_values_customs WHERE control_id = @control_id_institution_and_lab AND value LIKE 'Labo %' AND value NOT LIKE 'Labo Dr%');
INSERT INTO `structure_permissible_values_customs_revs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `version_created`)
(SELECT REPLACE(value, 'Labo ', 'Dr '), en, fr, `use_as_input`, @control_id_researcher, `modified_by`, `version_created`
FROM structure_permissible_values_customs_revs WHERE control_id = @control_id_institution_and_lab AND value LIKE 'Labo %' AND value NOT LIKE 'Labo Dr%'
ORDER BY version_id);
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT REPLACE(value, 'Labo Dr ', 'Dr '), en, fr, `use_as_input`, @control_id_researcher, `modified`, `created`, `created_by`, `modified_by`
FROM structure_permissible_values_customs WHERE control_id = @control_id_institution_and_lab AND value LIKE 'Labo Dr %');
INSERT INTO `structure_permissible_values_customs_revs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `version_created`)
(SELECT REPLACE(value, 'Labo Dr ', 'Dr '), en, fr, `use_as_input`, @control_id_researcher, `modified_by`, `version_created`
FROM structure_permissible_values_customs_revs WHERE control_id = @control_id_institution_and_lab AND value LIKE 'Labo Dr %'
ORDER BY version_id);
UPDATE orders SET qc_nd_researcher = REPLACE(institution, 'Labo ', 'Dr ') WHERE qc_nd_researcher IS NULL AND institution LIKE 'Labo %' AND institution NOT LIKE 'Labo Dr%';
UPDATE orders_revs SET qc_nd_researcher = REPLACE(institution, 'Labo ', 'Dr ') WHERE qc_nd_researcher IS NULL AND institution LIKE 'Labo %' AND institution NOT LIKE 'Labo Dr%';
UPDATE orders SET qc_nd_researcher = REPLACE(institution, 'Labo Dr ', 'Dr ') WHERE qc_nd_researcher IS NULL AND institution LIKE 'Labo Dr%';
UPDATE orders_revs SET qc_nd_researcher = REPLACE(institution, 'Labo Dr ', 'Dr ') WHERE qc_nd_researcher IS NULL AND institution LIKE 'Labo Dr%';
UPDATE orders SET institution = '' WHERE qc_nd_researcher IS NOT NULL;
UPDATE orders_revs SET institution = '' WHERE qc_nd_researcher IS NOT NULL;

SET @control_id_institution_and_lab = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id_institution_and_lab AND value NOT IN (SELECT DISTINCT institution from orders);
DELETE FROM structure_permissible_values_customs_revs WHERE control_id = @control_id_institution_and_lab AND value NOT IN (SELECT DISTINCT institution from orders);

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study (I)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `type`='input',  `structure_value_domain`= NULL  WHERE model='StudySummary' AND tablename='study_summaries' AND field='qc_nd_contact' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff');
SET @control_id_lab_staff = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff');
UPDATE structure_permissible_values_customs, study_summaries
SET study_summaries.qc_nd_contact = structure_permissible_values_customs.en
WHERE study_summaries.qc_nd_contact = structure_permissible_values_customs.value 
AND structure_permissible_values_customs.en IS NOT NULL AND structure_permissible_values_customs.en NOT LIKE ''
AND structure_permissible_values_customs.control_id = @control_id_lab_staff;
UPDATE structure_permissible_values_customs, study_summaries_revs
SET study_summaries_revs.qc_nd_contact = structure_permissible_values_customs.en
WHERE study_summaries_revs.qc_nd_contact = structure_permissible_values_customs.value 
AND structure_permissible_values_customs.en IS NOT NULL AND structure_permissible_values_customs.en NOT LIKE ''
AND structure_permissible_values_customs.control_id = @control_id_lab_staff;

SET @control_id_lab_staff = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff');
DELETE FROM structure_permissible_values_customs 
WHERE value NOT IN (
	SELECT DISTINCT staff FROM (
		SELECT DISTINCT added_by as staff FROM order_items
		UNION ALL
		SELECT DISTINCT shipped_by as staff FROM shipments
		UNION ALL
		SELECT DISTINCT run_by as staff FROM quality_ctrls
		UNION ALL
		SELECT DISTINCT used_by as staff FROM aliquot_internal_uses
		UNION ALL
		SELECT DISTINCT stored_by as staff FROM aliquot_masters
		UNION ALL
		SELECT DISTINCT realiquoted_by as staff FROM realiquotings
		UNION ALL
		SELECT DISTINCT used_by as staff FROM view_aliquot_uses
		UNION ALL
		SELECT DISTINCT realiquoted_by as staff FROM lbd_slide_creations
		UNION ALL
		SELECT DISTINCT creation_by as staff FROM lbd_dna_extractions
		UNION ALL
		SELECT DISTINCT reception_by as staff FROM specimen_details
		UNION ALL
		SELECT DISTINCT creation_by as staff FROM derivative_details
	) res WHERE staff IS NOT NULL)
AND control_id = @control_id_lab_staff;
DELETE FROM structure_permissible_values_customs_revs
WHERE value NOT IN (
	SELECT DISTINCT staff FROM (
		SELECT DISTINCT added_by as staff FROM order_items
		UNION ALL
		SELECT DISTINCT shipped_by as staff FROM shipments
		UNION ALL
		SELECT DISTINCT run_by as staff FROM quality_ctrls
		UNION ALL
		SELECT DISTINCT used_by as staff FROM aliquot_internal_uses
		UNION ALL
		SELECT DISTINCT stored_by as staff FROM aliquot_masters
		UNION ALL
		SELECT DISTINCT realiquoted_by as staff FROM realiquotings
		UNION ALL
		SELECT DISTINCT used_by as staff FROM view_aliquot_uses
		UNION ALL
		SELECT DISTINCT realiquoted_by as staff FROM lbd_slide_creations
		UNION ALL
		SELECT DISTINCT creation_by as staff FROM lbd_dna_extractions
		UNION ALL
		SELECT DISTINCT reception_by as staff FROM specimen_details
		UNION ALL
		SELECT DISTINCT creation_by as staff FROM derivative_details
	) res WHERE staff IS NOT NULL)
AND control_id = @control_id_lab_staff;

ALTER TABLE study_summaries ADD COLUMN qc_nd_institution VARCHAR(100) DEFAULT NULL;
ALTER TABLE study_summaries_revs ADD COLUMN qc_nd_institution VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_institutions_and_laboratories') , '0', '', '', '', 'laboratory / institution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_institutions_and_laboratories')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laboratory / institution' AND `language_tag`=''), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

ALTER TABLE study_summaries 
  ADD COLUMN qc_nd_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN qc_nd_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_mta_data_sharing_approved_file_name varchar(500) DEFAULT null;
ALTER TABLE study_summaries_revs 
  ADD COLUMN qc_nd_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN qc_nd_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_mta_data_sharing_approved_file_name varchar(500) DEFAULT null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_ethical_approved', 'yes_no',  NULL , '0', '', '', '', 'ethic', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_ethical_approval_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_mta_data_sharing_approved', 'yes_no',  NULL , '0', '', '', '', 'mta data sharing', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_mta_data_sharing_approved_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_ethical_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethic' AND `language_tag`=''), '2', '1', 'approval', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_ethical_approval_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_mta_data_sharing_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta data sharing' AND `language_tag`=''), '2', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_mta_data_sharing_approved_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='30', `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
VALUES
('approval', 'Approval', 'Approbation'),
('ethic', 'Ethic', 'éthique'),
('file name', 'File Name', 'Nom du fichier'),
('mta data sharing', 'MTA Data Sharing', 'Partage de matériels et de données');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Institution
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

SET @control_id_new_institution_and_lab = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories');
INSERT INTO `structure_permissible_values_customs` (`value`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("Walter Reed National Military Centre Department of Research", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Université du Québec à Trois-Rivières", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("CHUQ", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Centre de recherche en reproduction animale - UdeM", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Garvan Institute of Medical Research", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Child and Family Research Institute, Vancouver", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Hôpital Maisonneuve-Rosemont", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("CRCHUM", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Harvard Medical School - Massachusetts General Hospital", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Xceed Molecular Corporation", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Kansas City VA Medical Center", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Dalhousie University", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Ottawa Hospital Research Institute", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Alethia Biotherapeutics", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Jewish General Hospital", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Roswell Park Cancer Institute, Buffalo", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("UdeM", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Lady Davis Institute, Jewish General Hospital", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("University of Texas MD Anderson Cancer Center", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Oregon Health & Science University", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("University of Vermont College", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("CTAG", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("McGill", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Mount Sinai School of Medecine", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Mount Sinai Hospital Foundation of Toronto", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Fox Chase Cancer Center", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Queen's University, Kingston", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("IRCM", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("University of Pittsburgh Cancer Institute", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Institute of Cancer Research Gene Function Lab", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("IRIC", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("CRCHUQ", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Duke University Medical Center", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("University of Manitoba", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("CRCHUS", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Université de Miami", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("MaRS", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("London Regional Cancer Program", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Department of Experimantal Pathology Mayo Clinic College of Rochester", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("University Hospital of Würzburg", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("OvCaRe and CTAG", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("INRS", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Imperial College London OCARC", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("CUSM", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW()),
("Johns Hopkins Medical Institutions, Baltimore", '1', @control_id_new_institution_and_lab, '9', NOW(),'9', NOW());

UPDATE orders SET institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Adrian Lee%";
UPDATE orders SET institution = "Walter Reed National Military Centre Department of Research" WHERE qc_nd_researcher LIKE "Dr Anderson%";
UPDATE orders SET institution = "Université du Québec à Trois-Rivières" WHERE qc_nd_researcher LIKE "Dr Asselin%";		
UPDATE orders SET institution = "CHUQ" WHERE qc_nd_researcher LIKE "Dr Batchvarov%";
UPDATE orders SET institution = "Centre de recherche en reproduction animale - UdeM" WHERE qc_nd_researcher LIKE "Dr Boerboom%";
UPDATE orders SET institution = "Garvan Institute of Medical Research" WHERE qc_nd_researcher LIKE "Dr Bowtell%";
UPDATE orders SET institution = "Child and Family Research Institute, Vancouver" WHERE qc_nd_researcher LIKE "Dr Carey%";
UPDATE orders SET institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Carmona%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Christopoulos%";
UPDATE orders SET institution = "Harvard Medical School - Massachusetts General Hospital" WHERE qc_nd_researcher LIKE "Dr Dae-Yeon Kim%";
UPDATE orders SET institution = "Xceed Molecular Corporation" WHERE qc_nd_researcher LIKE "Dr Dan Wilson%";
UPDATE orders SET institution = "Kansas City VA Medical Center" WHERE qc_nd_researcher LIKE "Dr De%";
UPDATE orders SET institution = "Dalhousie University" WHERE qc_nd_researcher LIKE "Dr Dellaire%";
UPDATE orders SET institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Diallo%";
UPDATE orders SET institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Drobetsky%";
UPDATE orders SET institution = "Alethia Biotherapeutics" WHERE qc_nd_researcher LIKE "Dr Filion%";
UPDATE orders SET institution = "Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Foulkes%";
UPDATE orders SET institution = "Roswell Park Cancer Institute, Buffalo" WHERE qc_nd_researcher LIKE "Dr Gelman%";
UPDATE orders SET institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Gerardo Ferbeyre%";
UPDATE orders SET institution = "Lady Davis Institute, Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Gotlieb%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Guy Cloutier%";
UPDATE orders SET institution = "University of Texas MD Anderson Cancer Center" WHERE qc_nd_researcher LIKE "Dr Hannessy%";
UPDATE orders SET institution = "Oregon Health & Science University" WHERE qc_nd_researcher LIKE "Dr Hays%";
UPDATE orders SET institution = "University of Vermont College" WHERE qc_nd_researcher LIKE "Dr Howe%";
UPDATE orders SET institution = "CTAG" WHERE qc_nd_researcher LIKE "Dr Huntsman%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Isabelle Royal%";
UPDATE orders SET institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Jean-Claude%";
UPDATE orders SET institution = "Mount Sinai School of Medecine" WHERE qc_nd_researcher LIKE "Dr John Martignetti%";
UPDATE orders SET institution = "Mount Sinai Hospital Foundation of Toronto" WHERE qc_nd_researcher LIKE "Dr Jurisicova%";
UPDATE orders SET institution = "Fox Chase Cancer Center" WHERE qc_nd_researcher LIKE "Dr Karakasheva%";		
UPDATE orders SET institution = "Queen's University, Kingston" WHERE qc_nd_researcher LIKE "Dr Koti%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Lattouf%";
UPDATE orders SET institution = "IRCM" WHERE qc_nd_researcher LIKE "Dr LÃ©cuyer%";
UPDATE orders SET institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Lee%";
UPDATE orders SET institution = "Institute of Cancer Research Gene Function Lab " WHERE qc_nd_researcher LIKE "Dr Lord%";
UPDATE orders SET institution = "IRIC" WHERE qc_nd_researcher LIKE "Dr Mader%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Manuela Santos%";
UPDATE orders SET institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Masson%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Maugard%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Mes-Masson%";
UPDATE orders SET institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Michel Lebel%";
UPDATE orders SET institution = "Duke University Medical Center " WHERE qc_nd_researcher LIKE "Dr Murphy%";
UPDATE orders SET institution = "University of Manitoba" WHERE qc_nd_researcher LIKE "Dr Nachtigal%";
UPDATE orders SET institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Nadeau%";			
UPDATE orders SET institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Nepveu%";			
UPDATE orders SET institution = "Université de Miami" WHERE qc_nd_researcher LIKE "Dr Podack%";
UPDATE orders SET institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Ramotar%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Richard Bertrand%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Rodier%";
UPDATE orders SET institution = "MaRS" WHERE qc_nd_researcher LIKE "Dr Rottapel%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Saad%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Schmitt%";
UPDATE orders SET institution = "London Regional Cancer Program" WHERE qc_nd_researcher LIKE "Dr Shepherd%";
UPDATE orders SET institution = "Department of Experimantal Pathology Mayo Clinic College of Rochester" WHERE qc_nd_researcher LIKE "Dr Shridhar%";
UPDATE orders SET institution = "University Hospital of Würzburg" WHERE qc_nd_researcher LIKE "Dr Siegmund%";
UPDATE orders SET institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Sirard%";
UPDATE orders SET institution = "OvCaRe and CTAG" WHERE qc_nd_researcher LIKE "Dr Sohrab Shah%";
UPDATE orders SET institution = "INRS" WHERE qc_nd_researcher LIKE "Dr St-Pierre%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Stagg%";
UPDATE orders SET institution = "Imperial College London OCARC" WHERE qc_nd_researcher LIKE "Dr Stronach%";
UPDATE orders SET institution = "CUSM" WHERE qc_nd_researcher LIKE "Dr Tonin%";
UPDATE orders SET institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Vanderhyden%";
UPDATE orders SET institution = "Johns Hopkins Medical Institutions, Baltimore" WHERE qc_nd_researcher LIKE "Dr Wang%";
UPDATE orders SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr R%jean Lapointe%";
UPDATE orders SET institution = "CRCHUS" WHERE qc_nd_researcher LIKE "Dr Pich%";

UPDATE orders_revs SET institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Adrian Lee%";
UPDATE orders_revs SET institution = "Walter Reed National Military Centre Department of Research" WHERE qc_nd_researcher LIKE "Dr Anderson%";
UPDATE orders_revs SET institution = "Université du Québec à Trois-Rivières" WHERE qc_nd_researcher LIKE "Dr Asselin%";		
UPDATE orders_revs SET institution = "CHUQ" WHERE qc_nd_researcher LIKE "Dr Batchvarov%";
UPDATE orders_revs SET institution = "Centre de recherche en reproduction animale - UdeM" WHERE qc_nd_researcher LIKE "Dr Boerboom%";
UPDATE orders_revs SET institution = "Garvan Institute of Medical Research" WHERE qc_nd_researcher LIKE "Dr Bowtell%";
UPDATE orders_revs SET institution = "Child and Family Research Institute, Vancouver" WHERE qc_nd_researcher LIKE "Dr Carey%";
UPDATE orders_revs SET institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Carmona%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Christopoulos%";
UPDATE orders_revs SET institution = "Harvard Medical School - Massachusetts General Hospital" WHERE qc_nd_researcher LIKE "Dr Dae-Yeon Kim%";
UPDATE orders_revs SET institution = "Xceed Molecular Corporation" WHERE qc_nd_researcher LIKE "Dr Dan Wilson%";
UPDATE orders_revs SET institution = "Kansas City VA Medical Center" WHERE qc_nd_researcher LIKE "Dr De%";
UPDATE orders_revs SET institution = "Dalhousie University" WHERE qc_nd_researcher LIKE "Dr Dellaire%";
UPDATE orders_revs SET institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Diallo%";
UPDATE orders_revs SET institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Drobetsky%";
UPDATE orders_revs SET institution = "Alethia Biotherapeutics" WHERE qc_nd_researcher LIKE "Dr Filion%";
UPDATE orders_revs SET institution = "Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Foulkes%";
UPDATE orders_revs SET institution = "Roswell Park Cancer Institute, Buffalo" WHERE qc_nd_researcher LIKE "Dr Gelman%";
UPDATE orders_revs SET institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Gerardo Ferbeyre%";
UPDATE orders_revs SET institution = "Lady Davis Institute, Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Gotlieb%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Guy Cloutier%";
UPDATE orders_revs SET institution = "University of Texas MD Anderson Cancer Center" WHERE qc_nd_researcher LIKE "Dr Hannessy%";
UPDATE orders_revs SET institution = "Oregon Health & Science University" WHERE qc_nd_researcher LIKE "Dr Hays%";
UPDATE orders_revs SET institution = "University of Vermont College" WHERE qc_nd_researcher LIKE "Dr Howe%";
UPDATE orders_revs SET institution = "CTAG" WHERE qc_nd_researcher LIKE "Dr Huntsman%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Isabelle Royal%";
UPDATE orders_revs SET institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Jean-Claude%";
UPDATE orders_revs SET institution = "Mount Sinai School of Medecine" WHERE qc_nd_researcher LIKE "Dr John Martignetti%";
UPDATE orders_revs SET institution = "Mount Sinai Hospital Foundation of Toronto" WHERE qc_nd_researcher LIKE "Dr Jurisicova%";
UPDATE orders_revs SET institution = "Fox Chase Cancer Center" WHERE qc_nd_researcher LIKE "Dr Karakasheva%";		
UPDATE orders_revs SET institution = "Queen's University, Kingston" WHERE qc_nd_researcher LIKE "Dr Koti%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Lattouf%";
UPDATE orders_revs SET institution = "IRCM" WHERE qc_nd_researcher LIKE "Dr LÃ©cuyer%";
UPDATE orders_revs SET institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Lee%";
UPDATE orders_revs SET institution = "Institute of Cancer Research Gene Function Lab " WHERE qc_nd_researcher LIKE "Dr Lord%";
UPDATE orders_revs SET institution = "IRIC" WHERE qc_nd_researcher LIKE "Dr Mader%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Manuela Santos%";
UPDATE orders_revs SET institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Masson%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Maugard%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Mes-Masson%";
UPDATE orders_revs SET institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Michel Lebel%";
UPDATE orders_revs SET institution = "Duke University Medical Center " WHERE qc_nd_researcher LIKE "Dr Murphy%";
UPDATE orders_revs SET institution = "University of Manitoba" WHERE qc_nd_researcher LIKE "Dr Nachtigal%";
UPDATE orders_revs SET institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Nadeau%";			
UPDATE orders_revs SET institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Nepveu%";			
UPDATE orders_revs SET institution = "Université de Miami" WHERE qc_nd_researcher LIKE "Dr Podack%";
UPDATE orders_revs SET institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Ramotar%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Richard Bertrand%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Rodier%";
UPDATE orders_revs SET institution = "MaRS" WHERE qc_nd_researcher LIKE "Dr Rottapel%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Saad%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Schmitt%";
UPDATE orders_revs SET institution = "London Regional Cancer Program" WHERE qc_nd_researcher LIKE "Dr Shepherd%";
UPDATE orders_revs SET institution = "Department of Experimantal Pathology Mayo Clinic College of Rochester" WHERE qc_nd_researcher LIKE "Dr Shridhar%";
UPDATE orders_revs SET institution = "University Hospital of Würzburg" WHERE qc_nd_researcher LIKE "Dr Siegmund%";
UPDATE orders_revs SET institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Sirard%";
UPDATE orders_revs SET institution = "OvCaRe and CTAG" WHERE qc_nd_researcher LIKE "Dr Sohrab Shah%";
UPDATE orders_revs SET institution = "INRS" WHERE qc_nd_researcher LIKE "Dr St-Pierre%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Stagg%";
UPDATE orders_revs SET institution = "Imperial College London OCARC" WHERE qc_nd_researcher LIKE "Dr Stronach%";
UPDATE orders_revs SET institution = "CUSM" WHERE qc_nd_researcher LIKE "Dr Tonin%";
UPDATE orders_revs SET institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Vanderhyden%";
UPDATE orders_revs SET institution = "Johns Hopkins Medical Institutions, Baltimore" WHERE qc_nd_researcher LIKE "Dr Wang%";
UPDATE orders_revs SET institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr R%jean Lapointe%";
UPDATE orders_revs SET institution = "CRCHUS" WHERE qc_nd_researcher LIKE "Dr Pich%";

UPDATE study_summaries SET qc_nd_institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Adrian Lee%";
UPDATE study_summaries SET qc_nd_institution = "Walter Reed National Military Centre Department of Research" WHERE qc_nd_researcher LIKE "Dr Anderson%";
UPDATE study_summaries SET qc_nd_institution = "Université du Québec à Trois-Rivières" WHERE qc_nd_researcher LIKE "Dr Asselin%";		
UPDATE study_summaries SET qc_nd_institution = "CHUQ" WHERE qc_nd_researcher LIKE "Dr Batchvarov%";
UPDATE study_summaries SET qc_nd_institution = "Centre de recherche en reproduction animale - UdeM" WHERE qc_nd_researcher LIKE "Dr Boerboom%";
UPDATE study_summaries SET qc_nd_institution = "Garvan Institute of Medical Research" WHERE qc_nd_researcher LIKE "Dr Bowtell%";
UPDATE study_summaries SET qc_nd_institution = "Child and Family Research Institute, Vancouver" WHERE qc_nd_researcher LIKE "Dr Carey%";
UPDATE study_summaries SET qc_nd_institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Carmona%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Christopoulos%";
UPDATE study_summaries SET qc_nd_institution = "Harvard Medical School - Massachusetts General Hospital" WHERE qc_nd_researcher LIKE "Dr Dae-Yeon Kim%";
UPDATE study_summaries SET qc_nd_institution = "Xceed Molecular Corporation" WHERE qc_nd_researcher LIKE "Dr Dan Wilson%";
UPDATE study_summaries SET qc_nd_institution = "Kansas City VA Medical Center" WHERE qc_nd_researcher LIKE "Dr De%";
UPDATE study_summaries SET qc_nd_institution = "Dalhousie University" WHERE qc_nd_researcher LIKE "Dr Dellaire%";
UPDATE study_summaries SET qc_nd_institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Diallo%";
UPDATE study_summaries SET qc_nd_institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Drobetsky%";
UPDATE study_summaries SET qc_nd_institution = "Alethia Biotherapeutics" WHERE qc_nd_researcher LIKE "Dr Filion%";
UPDATE study_summaries SET qc_nd_institution = "Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Foulkes%";
UPDATE study_summaries SET qc_nd_institution = "Roswell Park Cancer Institute, Buffalo" WHERE qc_nd_researcher LIKE "Dr Gelman%";
UPDATE study_summaries SET qc_nd_institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Gerardo Ferbeyre%";
UPDATE study_summaries SET qc_nd_institution = "Lady Davis Institute, Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Gotlieb%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Guy Cloutier%";
UPDATE study_summaries SET qc_nd_institution = "University of Texas MD Anderson Cancer Center" WHERE qc_nd_researcher LIKE "Dr Hannessy%";
UPDATE study_summaries SET qc_nd_institution = "Oregon Health & Science University" WHERE qc_nd_researcher LIKE "Dr Hays%";
UPDATE study_summaries SET qc_nd_institution = "University of Vermont College" WHERE qc_nd_researcher LIKE "Dr Howe%";
UPDATE study_summaries SET qc_nd_institution = "CTAG" WHERE qc_nd_researcher LIKE "Dr Huntsman%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Isabelle Royal%";
UPDATE study_summaries SET qc_nd_institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Jean-Claude%";
UPDATE study_summaries SET qc_nd_institution = "Mount Sinai School of Medecine" WHERE qc_nd_researcher LIKE "Dr John Martignetti%";
UPDATE study_summaries SET qc_nd_institution = "Mount Sinai Hospital Foundation of Toronto" WHERE qc_nd_researcher LIKE "Dr Jurisicova%";
UPDATE study_summaries SET qc_nd_institution = "Fox Chase Cancer Center" WHERE qc_nd_researcher LIKE "Dr Karakasheva%";		
UPDATE study_summaries SET qc_nd_institution = "Queen's University, Kingston" WHERE qc_nd_researcher LIKE "Dr Koti%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Lattouf%";
UPDATE study_summaries SET qc_nd_institution = "IRCM" WHERE qc_nd_researcher LIKE "Dr LÃ©cuyer%";
UPDATE study_summaries SET qc_nd_institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Lee%";
UPDATE study_summaries SET qc_nd_institution = "Institute of Cancer Research Gene Function Lab " WHERE qc_nd_researcher LIKE "Dr Lord%";
UPDATE study_summaries SET qc_nd_institution = "IRIC" WHERE qc_nd_researcher LIKE "Dr Mader%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Manuela Santos%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Masson%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Maugard%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Mes-Masson%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Michel Lebel%";
UPDATE study_summaries SET qc_nd_institution = "Duke University Medical Center " WHERE qc_nd_researcher LIKE "Dr Murphy%";
UPDATE study_summaries SET qc_nd_institution = "University of Manitoba" WHERE qc_nd_researcher LIKE "Dr Nachtigal%";
UPDATE study_summaries SET qc_nd_institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Nadeau%";			
UPDATE study_summaries SET qc_nd_institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Nepveu%";			
UPDATE study_summaries SET qc_nd_institution = "Université de Miami" WHERE qc_nd_researcher LIKE "Dr Podack%";
UPDATE study_summaries SET qc_nd_institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Ramotar%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Richard Bertrand%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Rodier%";
UPDATE study_summaries SET qc_nd_institution = "MaRS" WHERE qc_nd_researcher LIKE "Dr Rottapel%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Saad%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Schmitt%";
UPDATE study_summaries SET qc_nd_institution = "London Regional Cancer Program" WHERE qc_nd_researcher LIKE "Dr Shepherd%";
UPDATE study_summaries SET qc_nd_institution = "Department of Experimantal Pathology Mayo Clinic College of Rochester" WHERE qc_nd_researcher LIKE "Dr Shridhar%";
UPDATE study_summaries SET qc_nd_institution = "University Hospital of Würzburg" WHERE qc_nd_researcher LIKE "Dr Siegmund%";
UPDATE study_summaries SET qc_nd_institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Sirard%";
UPDATE study_summaries SET qc_nd_institution = "OvCaRe and CTAG" WHERE qc_nd_researcher LIKE "Dr Sohrab Shah%";
UPDATE study_summaries SET qc_nd_institution = "INRS" WHERE qc_nd_researcher LIKE "Dr St-Pierre%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Stagg%";
UPDATE study_summaries SET qc_nd_institution = "Imperial College London OCARC" WHERE qc_nd_researcher LIKE "Dr Stronach%";
UPDATE study_summaries SET qc_nd_institution = "CUSM" WHERE qc_nd_researcher LIKE "Dr Tonin%";
UPDATE study_summaries SET qc_nd_institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Vanderhyden%";
UPDATE study_summaries SET qc_nd_institution = "Johns Hopkins Medical Institutions, Baltimore" WHERE qc_nd_researcher LIKE "Dr Wang%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr R%jean Lapointe%";
UPDATE study_summaries SET qc_nd_institution = "CRCHUS" WHERE qc_nd_researcher LIKE "Dr Pich%";

UPDATE study_summaries_revs SET qc_nd_institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Adrian Lee%";
UPDATE study_summaries_revs SET qc_nd_institution = "Walter Reed National Military Centre Department of Research" WHERE qc_nd_researcher LIKE "Dr Anderson%";
UPDATE study_summaries_revs SET qc_nd_institution = "Université du Québec à Trois-Rivières" WHERE qc_nd_researcher LIKE "Dr Asselin%";		
UPDATE study_summaries_revs SET qc_nd_institution = "CHUQ" WHERE qc_nd_researcher LIKE "Dr Batchvarov%";
UPDATE study_summaries_revs SET qc_nd_institution = "Centre de recherche en reproduction animale - UdeM" WHERE qc_nd_researcher LIKE "Dr Boerboom%";
UPDATE study_summaries_revs SET qc_nd_institution = "Garvan Institute of Medical Research" WHERE qc_nd_researcher LIKE "Dr Bowtell%";
UPDATE study_summaries_revs SET qc_nd_institution = "Child and Family Research Institute, Vancouver" WHERE qc_nd_researcher LIKE "Dr Carey%";
UPDATE study_summaries_revs SET qc_nd_institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Carmona%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Christopoulos%";
UPDATE study_summaries_revs SET qc_nd_institution = "Harvard Medical School - Massachusetts General Hospital" WHERE qc_nd_researcher LIKE "Dr Dae-Yeon Kim%";
UPDATE study_summaries_revs SET qc_nd_institution = "Xceed Molecular Corporation" WHERE qc_nd_researcher LIKE "Dr Dan Wilson%";
UPDATE study_summaries_revs SET qc_nd_institution = "Kansas City VA Medical Center" WHERE qc_nd_researcher LIKE "Dr De%";
UPDATE study_summaries_revs SET qc_nd_institution = "Dalhousie University" WHERE qc_nd_researcher LIKE "Dr Dellaire%";
UPDATE study_summaries_revs SET qc_nd_institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Diallo%";
UPDATE study_summaries_revs SET qc_nd_institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Drobetsky%";
UPDATE study_summaries_revs SET qc_nd_institution = "Alethia Biotherapeutics" WHERE qc_nd_researcher LIKE "Dr Filion%";
UPDATE study_summaries_revs SET qc_nd_institution = "Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Foulkes%";
UPDATE study_summaries_revs SET qc_nd_institution = "Roswell Park Cancer Institute, Buffalo" WHERE qc_nd_researcher LIKE "Dr Gelman%";
UPDATE study_summaries_revs SET qc_nd_institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Gerardo Ferbeyre%";
UPDATE study_summaries_revs SET qc_nd_institution = "Lady Davis Institute, Jewish General Hospital" WHERE qc_nd_researcher LIKE "Dr Gotlieb%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Guy Cloutier%";
UPDATE study_summaries_revs SET qc_nd_institution = "University of Texas MD Anderson Cancer Center" WHERE qc_nd_researcher LIKE "Dr Hannessy%";
UPDATE study_summaries_revs SET qc_nd_institution = "Oregon Health & Science University" WHERE qc_nd_researcher LIKE "Dr Hays%";
UPDATE study_summaries_revs SET qc_nd_institution = "University of Vermont College" WHERE qc_nd_researcher LIKE "Dr Howe%";
UPDATE study_summaries_revs SET qc_nd_institution = "CTAG" WHERE qc_nd_researcher LIKE "Dr Huntsman%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Isabelle Royal%";
UPDATE study_summaries_revs SET qc_nd_institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Jean-Claude%";
UPDATE study_summaries_revs SET qc_nd_institution = "Mount Sinai School of Medecine" WHERE qc_nd_researcher LIKE "Dr John Martignetti%";
UPDATE study_summaries_revs SET qc_nd_institution = "Mount Sinai Hospital Foundation of Toronto" WHERE qc_nd_researcher LIKE "Dr Jurisicova%";
UPDATE study_summaries_revs SET qc_nd_institution = "Fox Chase Cancer Center" WHERE qc_nd_researcher LIKE "Dr Karakasheva%";		
UPDATE study_summaries_revs SET qc_nd_institution = "Queen's University, Kingston" WHERE qc_nd_researcher LIKE "Dr Koti%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Lattouf%";
UPDATE study_summaries_revs SET qc_nd_institution = "IRCM" WHERE qc_nd_researcher LIKE "Dr LÃ©cuyer%";
UPDATE study_summaries_revs SET qc_nd_institution = "University of Pittsburgh Cancer Institute" WHERE qc_nd_researcher LIKE "Dr Lee%";
UPDATE study_summaries_revs SET qc_nd_institution = "Institute of Cancer Research Gene Function Lab " WHERE qc_nd_researcher LIKE "Dr Lord%";
UPDATE study_summaries_revs SET qc_nd_institution = "IRIC" WHERE qc_nd_researcher LIKE "Dr Mader%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Manuela Santos%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Masson%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Maugard%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Mes-Masson%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUQ" WHERE qc_nd_researcher LIKE "Dr Michel Lebel%";
UPDATE study_summaries_revs SET qc_nd_institution = "Duke University Medical Center " WHERE qc_nd_researcher LIKE "Dr Murphy%";
UPDATE study_summaries_revs SET qc_nd_institution = "University of Manitoba" WHERE qc_nd_researcher LIKE "Dr Nachtigal%";
UPDATE study_summaries_revs SET qc_nd_institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Nadeau%";			
UPDATE study_summaries_revs SET qc_nd_institution = "McGill" WHERE qc_nd_researcher LIKE "Dr Nepveu%";			
UPDATE study_summaries_revs SET qc_nd_institution = "Université de Miami" WHERE qc_nd_researcher LIKE "Dr Podack%";
UPDATE study_summaries_revs SET qc_nd_institution = "Hôpital Maisonneuve-Rosemont" WHERE qc_nd_researcher LIKE "Dr Ramotar%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Richard Bertrand%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Rodier%";
UPDATE study_summaries_revs SET qc_nd_institution = "MaRS" WHERE qc_nd_researcher LIKE "Dr Rottapel%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Saad%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Schmitt%";
UPDATE study_summaries_revs SET qc_nd_institution = "London Regional Cancer Program" WHERE qc_nd_researcher LIKE "Dr Shepherd%";
UPDATE study_summaries_revs SET qc_nd_institution = "Department of Experimantal Pathology Mayo Clinic College of Rochester" WHERE qc_nd_researcher LIKE "Dr Shridhar%";
UPDATE study_summaries_revs SET qc_nd_institution = "University Hospital of Würzburg" WHERE qc_nd_researcher LIKE "Dr Siegmund%";
UPDATE study_summaries_revs SET qc_nd_institution = "UdeM" WHERE qc_nd_researcher LIKE "Dr Sirard%";
UPDATE study_summaries_revs SET qc_nd_institution = "OvCaRe and CTAG" WHERE qc_nd_researcher LIKE "Dr Sohrab Shah%";
UPDATE study_summaries_revs SET qc_nd_institution = "INRS" WHERE qc_nd_researcher LIKE "Dr St-Pierre%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr Stagg%";
UPDATE study_summaries_revs SET qc_nd_institution = "Imperial College London OCARC" WHERE qc_nd_researcher LIKE "Dr Stronach%";
UPDATE study_summaries_revs SET qc_nd_institution = "CUSM" WHERE qc_nd_researcher LIKE "Dr Tonin%";
UPDATE study_summaries_revs SET qc_nd_institution = "Ottawa Hospital Research Institute" WHERE qc_nd_researcher LIKE "Dr Vanderhyden%";
UPDATE study_summaries_revs SET qc_nd_institution = "Johns Hopkins Medical Institutions, Baltimore" WHERE qc_nd_researcher LIKE "Dr Wang%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUM" WHERE qc_nd_researcher LIKE "Dr R%jean Lapointe%";
UPDATE study_summaries_revs SET qc_nd_institution = "CRCHUS" WHERE qc_nd_researcher LIKE "Dr Pich%";

UPDATE study_summaries SET title = REPLACE(title, CONCAT(REPLACE(qc_nd_researcher, 'Dr ', ''), ' - '), '') WHERE title LIKE CONCAT(CONCAT(REPLACE(qc_nd_researcher, 'Dr ', ''), ' - '),'%');
UPDATE study_summaries SET title = REPLACE(title, 'Aléthia - ', '') WHERE title LIKE 'Aléthia - %' AND qc_nd_institution like 'Alethia Biotherapeutics';
UPDATE study_summaries SET title = REPLACE(title, 'CHUM - ', '') WHERE title LIKE 'CHUM - %' AND qc_nd_institution like 'CRCHUM';
UPDATE study_summaries SET title = REPLACE(title, 'Bachvarov - ', '') WHERE title LIKE 'Bachvarov - %' AND qc_nd_researcher like 'Dr Batchvarov';
UPDATE study_summaries SET title = REPLACE(title, 'Cloutier - ', '') WHERE title LIKE 'Cloutier - %' AND qc_nd_researcher like 'Dr%Cloutier%';
UPDATE study_summaries SET title = REPLACE(title, 'Shepherd - ', '') WHERE title LIKE 'Shepherd - %' AND qc_nd_researcher like 'Dr%Shepherd%';
UPDATE study_summaries SET title = REPLACE(title, 'Jurisica - ', '') WHERE title LIKE 'Jurisica - %' AND qc_nd_researcher like 'Dr%Jurisicova%';
UPDATE study_summaries SET title = REPLACE(title, 'Lapointe - ', '') WHERE title LIKE 'Lapointe - %' AND qc_nd_researcher like 'Dr%Lapointe%';
UPDATE study_summaries SET title = REPLACE(title, 'Lebel - ', '') WHERE title LIKE 'Lebel - %' AND qc_nd_researcher like 'Dr%Lebel%';
UPDATE study_summaries SET title = REPLACE(title, 'Royal - ', '') WHERE title LIKE 'Royal - %' AND qc_nd_researcher like 'Dr%Royal%';
UPDATE study_summaries SET title = REPLACE(title, 'Santos - ', '') WHERE title LIKE 'Santos - %' AND qc_nd_researcher like 'Dr%Santos%';
UPDATE study_summaries SET title = REPLACE(title, 'Sohrab - ', '') WHERE title LIKE 'Sohrab - %' AND qc_nd_researcher like 'Dr%Sohrab%';

UPDATE study_summaries_revs SET title = REPLACE(title, CONCAT(REPLACE(qc_nd_researcher, 'Dr ', ''), ' - '), '') WHERE title LIKE CONCAT(CONCAT(REPLACE(qc_nd_researcher, 'Dr ', ''), ' - '),'%');
UPDATE study_summaries_revs SET title = REPLACE(title, 'Aléthia - ', '') WHERE title LIKE 'Aléthia - %' AND qc_nd_institution like 'Alethia Biotherapeutics';
UPDATE study_summaries_revs SET title = REPLACE(title, 'CHUM - ', '') WHERE title LIKE 'CHUM - %' AND qc_nd_institution like 'CRCHUM';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Bachvarov - ', '') WHERE title LIKE 'Bachvarov - %' AND qc_nd_researcher like 'Dr Batchvarov';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Cloutier - ', '') WHERE title LIKE 'Cloutier - %' AND qc_nd_researcher like 'Dr%Cloutier%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Shepherd - ', '') WHERE title LIKE 'Shepherd - %' AND qc_nd_researcher like 'Dr%Shepherd%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Jurisica - ', '') WHERE title LIKE 'Jurisica - %' AND qc_nd_researcher like 'Dr%Jurisicova%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Lapointe - ', '') WHERE title LIKE 'Lapointe - %' AND qc_nd_researcher like 'Dr%Lapointe%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Lebel - ', '') WHERE title LIKE 'Lebel - %' AND qc_nd_researcher like 'Dr%Lebel%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Royal - ', '') WHERE title LIKE 'Royal - %' AND qc_nd_researcher like 'Dr%Royal%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Santos - ', '') WHERE title LIKE 'Santos - %' AND qc_nd_researcher like 'Dr%Santos%';
UPDATE study_summaries_revs SET title = REPLACE(title, 'Sohrab - ', '') WHERE title LIKE 'Sohrab - %' AND qc_nd_researcher like 'Dr%Sohrab%';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change way sardo value are managed
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `qc_nd_sardo_drop_down_lists` (
  type VARCHAR(250) DEFAULT NULL,
  value VARCHAR(1000) DEFAULT NULL,
  fr VARCHAR(1000) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

INSERT INTO qc_nd_sardo_drop_down_lists (type, value, fr)
(SELECT 
res.type, structure_permissible_values_customs.value, structure_permissible_values_customs.fr
FROM (
	SELECT REPLACE(REPLACE(source, "StructurePermissibleValuesCustom::getCustomDropdown('", ''), "')", '') AS type  from structure_value_domains WHERE source like '%SARDO :%'
) res 
INNER JOIN structure_permissible_values_custom_controls ON structure_permissible_values_custom_controls.name = res.type
INNER JOIN structure_permissible_values_customs ON structure_permissible_values_customs.control_id = structure_permissible_values_custom_controls.id);

UPDATE structure_value_domains SET source = REPLACE(source, 'StructurePermissibleValuesCustom::getCustomDropdown', 'ClinicalAnnotation.Participant::getSardoValues') WHERE source like '%SARDO :%';

CREATE TABLE `qc_nd_sardo_drop_down_list_properties` (
  type VARCHAR(250) DEFAULT NULL,
  values_max_length tinyint(3) unsigned
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
INSERT INTO qc_nd_sardo_drop_down_list_properties (select name, values_max_length from structure_permissible_values_custom_controls WHERE name like 'SARDO :%');
DELETE FROM structure_permissible_values_customs WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name like 'SARDO :%');
DELETE FROM structure_permissible_values_custom_controls WHERE name like 'SARDO :%';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Collection ATiM Patho Number + display SARDO patho number in collection view
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = 2;
SET @modified=(SELECT NOW() FROM users WHERE id = @modified_by);

ALTER TABLE collections ADD COLUMN qc_nd_pathology_nbr varchar(50) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN qc_nd_pathology_nbr varchar(50) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qc_nd_pathology_nbr', 'input',  NULL , '1', 'size=20', '', '', 'pathology nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_nd_pathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='pathology nbr' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qc_nd_pathology_nbr', 'input',  NULL , '1', 'size=20', '', '', 'pathology nbr', ''), 
('InventoryManagement', 'ViewCollection', '', 'qc_nd_pathology_nbr_from_sardo', 'input',  NULL , '1', 'size=20', '', '', '', 'sardo value');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_nd_pathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='pathology nbr' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_nd_pathology_nbr_from_sardo' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='sardo value'), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_nd_pathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='pathology nbr' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_nd_pathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='pathology nbr' AND `language_tag`=''), '0', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n 
(id,en,fr) 
VALUES 
('atim','ATiM','ATiM'),
('pathology nbr', 'Pathology #', 'Pathologie #');
UPDATE structure_fields SET  `language_tag`='atim' WHERE model='ViewCollection' AND tablename='' AND field='qc_nd_pathology_nbr' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_tag`='sardo' WHERE model='ViewCollection' AND tablename='' AND field='qc_nd_pathology_nbr_from_sardo' AND `type`='input' AND structure_value_domain  IS NULL ;

-- Move patho identifier from MiscIdentifier to Collection
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update qc_nd_pathology_nbr of tissue collections based on following rule. Patients:
--     1- With only one Patho Identifier (MiscIdentifier) 
--     2- And with only one date of tissue collection (could have many collections of tissue on the same date)
--     3- But collections with label 'Collection Created From TMA Layout' are not took into consideration

UPDATE misc_identifiers MI, misc_identifier_controls MIC, collections COL, sample_masters SM, sample_controls SC
SET COL.qc_nd_pathology_nbr = MI.identifier_value,
COL.modified_by = @modified_by,
COL.modified = @modified
WHERE MI.deleted <> 1
AND MI.misc_identifier_control_id = MIC.id AND MIC.misc_identifier_name = 'participant patho identifier'
AND COL.deleted <> 1
AND COL.acquisition_label NOT LIKE 'Collection Created From TMA Layout'
AND MI.participant_id = COL.participant_id
AND SM.deleted <> 1
AND SM.collection_id = COL.id AND SM.sample_control_id = SC.id AND SC.sample_type = 'tissue'
AND COL.participant_id IN (
	SELECT participant_id FROM (
		SELECT count(*) as nbr_of_patho_ident, participant_id
		FROM misc_identifiers 
		WHERE deleted <> 1 
		AND misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'participant patho identifier')
		GROUP BY participant_id
	) RES WHERE nbr_of_patho_ident = 1
) AND COL.participant_id IN (
	SELECT participant_id
	FROM (
		SELECT count(*) as nbr_dates_of_tissue_collection, participant_id
		FROM (
			SELECT DISTINCT COL.participant_id, DATE(collection_datetime) as collection_date
			FROM collections COL
			INNER JOIN sample_masters SM
			INNER JOIN sample_controls SC
			WHERE COL.deleted <> 1
			AND COL.acquisition_label NOT LIKE 'Collection Created From TMA Layout'
			AND SM.deleted <> 1
			AND SM.collection_id = COL.id AND SM.sample_control_id = SC.id AND SC.sample_type = 'tissue'
		) RES GROUP BY participant_id
	) RES2 WHERE nbr_dates_of_tissue_collection = 1
);

UPDATE misc_identifiers MI, misc_identifier_controls MIC, collections COL
SET MI.deleted = 1,
MI.modified_by = @modified_by,
MI.modified = @modified
WHERE MI.deleted <> 1
AND MI.misc_identifier_control_id = MIC.id AND MIC.misc_identifier_name = 'participant patho identifier'
AND COL.deleted <> 1
AND MI.participant_id = COL.participant_id
AND MI.identifier_value = COL.qc_nd_pathology_nbr
AND COL.modified_by = @modified_by
AND COL.modified = @modified;

-- Create empty collections to track unmigrated patho identifier (number has probably been created because bank is expecting to recceive paraffin blocks)

SELECT CONCAT('Identifiers : ',count(*)) AS '### WARNING ### :Patholo identifiers (misc identifiers) that could not be linked to a tissue collection. Empty collections have been created.'
FROM misc_identifiers MI, misc_identifier_controls MIC 
WHERE MI.misc_identifier_control_id = MIC.id AND MIC.misc_identifier_name = 'participant patho identifier' AND deleted <> 1
UNION ALL
SELECT CONCAT('PArticipants : ',count(*)) AS '### WARNING ### :Patholo identifiers (misc identifiers) that could not be linked to a tissue collection. Empty collections have been created.'
FROM (
	SELECT DISTINCT participant_id
	FROM misc_identifiers MI, misc_identifier_controls MIC 
	WHERE MI.misc_identifier_control_id = MIC.id AND MIC.misc_identifier_name = 'participant patho identifier' AND deleted <> 1
) RES;

INSERT INTO collections (participant_id, `acquisition_label`, `qc_nd_pathology_nbr`, `collection_property`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT participant_id, "Created by system to keep 'Patho Identifier'", identifier_value, 'participant collection', @modified, @modified, @modified_by, @modified_by
FROM misc_identifiers MI, misc_identifier_controls MIC 
WHERE MI.misc_identifier_control_id = MIC.id AND MIC.misc_identifier_name = 'participant patho identifier' AND deleted <> 1);

UPDATE misc_identifiers MI, misc_identifier_controls MIC
SET MI.deleted = 1,
MI.modified_by = @modified_by,
MI.modified = @modified
WHERE MI.deleted <> 1
AND MI.misc_identifier_control_id = MIC.id AND MIC.misc_identifier_name = 'participant patho identifier';

UPDATE misc_identifier_controls SET flag_active = 0 WHERE misc_identifier_name = 'participant patho identifier';

-- Notes creation

UPDATE collections SET collection_notes = CONCAT(collection_notes, ' ATiM patho # has been created by v2.6.8 script from Participant Patho Identifier (this identifier type deleted).') 
WHERE qc_nd_pathology_nbr IS NOT NULL AND qc_nd_pathology_nbr NOT LIKE ''
AND collection_notes IS NOT NULL;

UPDATE collections SET collection_notes = CONCAT('ATiM patho # has been created by v2.6.7 script from Participant Patho Identifier (this identifier type delete).')
WHERE qc_nd_pathology_nbr IS NOT NULL AND qc_nd_pathology_nbr NOT LIKE ''
AND collection_notes IS NULL;

-- Move tissue block patho number from AliquotDetail (ad_blocks) to Collection 
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_masters AM, ad_blocks AD
SET AM.notes = CONCAT(AM.notes, ' Block patho number = [', AD.patho_dpt_block_code, ']'),
AM.modified_by = @modified_by,
AM.modified = @modified
WHERE AM.deleted <> 1 
AND AD.aliquot_master_id = AM.id 
AND AD.patho_dpt_block_code NOT LIKE '' AND AD.patho_dpt_block_code IS NOT NULL
AND AM.notes IS NOT NULL;
UPDATE aliquot_masters AM, ad_blocks AD
SET AM.notes = CONCAT('Block patho number = [', AD.patho_dpt_block_code, ']'),
AM.modified_by = @modified_by,
AM.modified = @modified
WHERE AM.deleted <> 1 
AND AD.aliquot_master_id = AM.id 
AND AD.patho_dpt_block_code NOT LIKE '' AND AD.patho_dpt_block_code IS NOT NULL
AND AM.notes IS NULL;

-- Check

SELECT RES2.collection_id '### ERROR ### : Collections (id) with more than one patho nbr. Migration failed. To correct.', COL.acquisition_label, RES2.patho_dpt_block_code
FROM (
	SELECT RES1.collection_id, GROUP_CONCAT( RES1.patho_dpt_block_code SEPARATOR ' & ' ) patho_dpt_block_code
	FROM (
		SELECT DISTINCT COL.id AS collection_id, AD.patho_dpt_block_code
		FROM collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
		WHERE COL.deleted <> 1
		AND COL.participant_id IS NOT NULL
		AND SM.deleted <> 1 
		AND	SM.collection_id = COL.id 
		AND SM.sample_control_id = SC.id 
		AND SC.sample_type = 'tissue'
		AND AM.deleted <> 1 
		AND AM.sample_master_id = SM.id
		AND AD.aliquot_master_id = AM.id
		AND AD.patho_dpt_block_code NOT LIKE '' 
		AND AD.patho_dpt_block_code IS NOT NULL
	) RES1
	GROUP BY RES1.collection_id
) RES2, collections COL
WHERE RES2.collection_id = COL.id AND RES2.patho_dpt_block_code LIKE '%&%';

-- Add information to collection note

UPDATE (
	SELECT DISTINCT RES2.collection_id, AD.patho_dpt_block_code
	FROM (
		SELECT RES1.collection_id, count(*) as nbr_of_patho_nbr
		FROM (
			SELECT DISTINCT COL.id AS collection_id, AD.patho_dpt_block_code
			FROM collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
			WHERE COL.deleted <> 1
			AND COL.participant_id IS NOT NULL
			AND SM.deleted <> 1 
			AND SM.collection_id = COL.id 
			AND SM.sample_control_id = SC.id 
			AND SC.sample_type = 'tissue'
			AND AM.deleted <> 1 
			AND AM.sample_master_id = SM.id
			AND AD.aliquot_master_id = AM.id
			AND AD.patho_dpt_block_code NOT LIKE '' 
			AND AD.patho_dpt_block_code IS NOT NULL
		) RES1
		GROUP BY RES1.collection_id
	) RES2, collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
	WHERE RES2.nbr_of_patho_nbr = 1 
	AND RES2.collection_id = COL.id 
	AND COL.deleted <> 1
	AND COL.participant_id IS NOT NULL
	AND SM.deleted <> 1 
	AND SM.collection_id = COL.id 
	AND SM.sample_control_id = SC.id 
	AND SC.sample_type = 'tissue'
	AND AM.deleted <> 1 
	AND AM.sample_master_id = SM.id
	AND AD.aliquot_master_id = AM.id
	AND AD.patho_dpt_block_code NOT LIKE '' 
	AND AD.patho_dpt_block_code IS NOT NULL
) RES3, collections COL
SET COL.collection_notes = CONCAT(COL.collection_notes, ' ATiM patho # has been created by v2.6.8 script from Tissue Block Patho Number (field hidden in the new version) of the collection.'),
COL.modified_by = @modified_by,
COL.modified = @modified 
WHERE COL.id = RES3.collection_id
AND COL.collection_notes IS NOT NULL;

UPDATE (
	SELECT DISTINCT RES2.collection_id, AD.patho_dpt_block_code
	FROM (
		SELECT RES1.collection_id, count(*) as nbr_of_patho_nbr
		FROM (
			SELECT DISTINCT COL.id AS collection_id, AD.patho_dpt_block_code
			FROM collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
			WHERE COL.deleted <> 1
			AND COL.participant_id IS NOT NULL
			AND SM.deleted <> 1 
			AND SM.collection_id = COL.id 
			AND SM.sample_control_id = SC.id 
			AND SC.sample_type = 'tissue'
			AND AM.deleted <> 1 
			AND AM.sample_master_id = SM.id
			AND AD.aliquot_master_id = AM.id
			AND AD.patho_dpt_block_code NOT LIKE '' 
			AND AD.patho_dpt_block_code IS NOT NULL
		) RES1
		GROUP BY RES1.collection_id
	) RES2, collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
	WHERE RES2.nbr_of_patho_nbr = 1 
	AND RES2.collection_id = COL.id 
	AND COL.deleted <> 1
	AND COL.participant_id IS NOT NULL
	AND SM.deleted <> 1 
	AND SM.collection_id = COL.id 
	AND SM.sample_control_id = SC.id 
	AND SC.sample_type = 'tissue'
	AND AM.deleted <> 1 
	AND AM.sample_master_id = SM.id
	AND AD.aliquot_master_id = AM.id
	AND AD.patho_dpt_block_code NOT LIKE '' 
	AND AD.patho_dpt_block_code IS NOT NULL
) RES3, collections COL
SET COL.collection_notes = CONCAT('ATiM patho # has been created by v2.6.8 script from Tissue Block Patho Number (field hidden in the new version) of the collection.'),
COL.modified_by = @modified_by,
COL.modified = @modified 
WHERE COL.id = RES3.collection_id
AND COL.collection_notes IS NULL;

-- Update collection patho number

UPDATE (
	SELECT DISTINCT RES2.collection_id, AD.patho_dpt_block_code
	FROM (
		SELECT RES1.collection_id, count(*) as nbr_of_patho_nbr
		FROM (
			SELECT DISTINCT COL.id AS collection_id, AD.patho_dpt_block_code
			FROM collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
			WHERE COL.deleted <> 1
			AND COL.participant_id IS NOT NULL
			AND SM.deleted <> 1 
			AND SM.collection_id = COL.id 
			AND SM.sample_control_id = SC.id 
			AND SC.sample_type = 'tissue'
			AND AM.deleted <> 1 
			AND AM.sample_master_id = SM.id
			AND AD.aliquot_master_id = AM.id
			AND AD.patho_dpt_block_code NOT LIKE '' 
			AND AD.patho_dpt_block_code IS NOT NULL
		) RES1
		GROUP BY RES1.collection_id
	) RES2, collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
	WHERE RES2.nbr_of_patho_nbr = 1
	AND RES2.collection_id = COL.id 
	AND COL.deleted <> 1
	AND COL.participant_id IS NOT NULL
	AND SM.deleted <> 1 
	AND SM.collection_id = COL.id 
	AND SM.sample_control_id = SC.id 
	AND SC.sample_type = 'tissue'
	AND AM.deleted <> 1 
	AND AM.sample_master_id = SM.id
	AND AD.aliquot_master_id = AM.id
	AND AD.patho_dpt_block_code NOT LIKE '' 
	AND AD.patho_dpt_block_code IS NOT NULL
) RES3, collections COL
SET COL.qc_nd_pathology_nbr = CONCAT(COL.qc_nd_pathology_nbr, ' & ', RES3.patho_dpt_block_code),
COL.modified_by = @modified_by,
COL.modified = @modified 
WHERE COL.id = RES3.collection_id
AND COL.qc_nd_pathology_nbr IS NOT NULL 
AND COL.qc_nd_pathology_nbr NOT LIKE '' 
AND COL.qc_nd_pathology_nbr != RES3.patho_dpt_block_code;

UPDATE (
	SELECT DISTINCT RES2.collection_id, AD.patho_dpt_block_code
	FROM (
		SELECT RES1.collection_id, count(*) as nbr_of_patho_nbr
		FROM (
			SELECT DISTINCT COL.id AS collection_id, AD.patho_dpt_block_code
			FROM collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
			WHERE COL.deleted <> 1
			AND COL.participant_id IS NOT NULL
			AND SM.deleted <> 1 
			AND SM.collection_id = COL.id 
			AND SM.sample_control_id = SC.id 
			AND SC.sample_type = 'tissue'
			AND AM.deleted <> 1 
			AND AM.sample_master_id = SM.id
			AND AD.aliquot_master_id = AM.id
			AND AD.patho_dpt_block_code NOT LIKE '' 
			AND AD.patho_dpt_block_code IS NOT NULL
		) RES1
		GROUP BY RES1.collection_id
	) RES2, collections COL, sample_masters SM, sample_controls SC, aliquot_masters AM, ad_blocks AD
	WHERE RES2.nbr_of_patho_nbr = 1
	AND RES2.collection_id = COL.id 
	AND COL.deleted <> 1
	AND COL.participant_id IS NOT NULL
	AND SM.deleted <> 1 
	AND SM.collection_id = COL.id 
	AND SM.sample_control_id = SC.id 
	AND SC.sample_type = 'tissue'
	AND AM.deleted <> 1 
	AND AM.sample_master_id = SM.id
	AND AD.aliquot_master_id = AM.id
	AND AD.patho_dpt_block_code NOT LIKE '' 
	AND AD.patho_dpt_block_code IS NOT NULL
) RES3, collections COL
SET COL.qc_nd_pathology_nbr = CONCAT(COL.qc_nd_pathology_nbr, ' & ', RES3.patho_dpt_block_code),
COL.modified_by = @modified_by,
COL.modified = @modified 
WHERE COL.id = RES3.collection_id
AND (COL.qc_nd_pathology_nbr IS NULL OR COL.qc_nd_pathology_nbr LIKE '');

-- Remove ad block field patho number

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Revs table 
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO misc_identifiers_revs (id,identifier_value,misc_identifier_control_id,effective_date,effective_date_accuracy,expiry_date,expiry_date_accuracy,
notes,participant_id,tmp_deleted,flag_unique,study_summary_id,modified_by,version_created)
(SELECT id,identifier_value,misc_identifier_control_id,effective_date,effective_date_accuracy,expiry_date,expiry_date_accuracy,
notes,participant_id,tmp_deleted,flag_unique,study_summary_id,modified_by,modified FROM misc_identifiers WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO collections_revs (id,acquisition_label,bank_id,visit_label,collection_site,collection_datetime,collection_datetime_accuracy,sop_master_id,collection_property,collection_notes,
participant_id,diagnosis_master_id,consent_master_id,treatment_master_id,event_master_id,qc_nd_pathology_nbr,modified_by,version_created)
(SELECT id,acquisition_label,bank_id,visit_label,collection_site,collection_datetime,collection_datetime_accuracy,sop_master_id,collection_property,collection_notes,
participant_id,diagnosis_master_id,consent_master_id,treatment_master_id,event_master_id,qc_nd_pathology_nbr,modified_by,modified FROM collections WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,
storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,stored_by,product_code,notes,modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,
storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,stored_by,product_code,notes,modified_by, modified FROM aliquot_masters WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_blocks_revs (aliquot_master_id,block_type,sample_position_code,patho_dpt_block_code,tmp_gleason_primary_grade,tmp_gleason_secondary_grade,tmp_tissue_primary_desc,tmp_tissue_secondary_desc,
histogel_use,version_created,procure_origin_of_slice,tumor_presence)
(SELECT aliquot_master_id,block_type,sample_position_code,patho_dpt_block_code,tmp_gleason_primary_grade,tmp_gleason_secondary_grade,tmp_tissue_primary_desc,tmp_tissue_secondary_desc,
histogel_use,modified,procure_origin_of_slice,tumor_presence FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Link Collection to Surgery or Biopsy
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_use_for_ccl = 1 WHERE tx_method IN ('sardo treatment - chir','sardo treatment - biop');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr'), '1', '303', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET flag_confidential = '1' WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr';

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ViewCollection', 'TreatmentMaster'))
AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ViewCollection', 'TreatmentMaster'));

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Participants Field Cleanup (ac_nd_ to qc_nd_)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants
  CHANGE ac_nd_suspected_date_of_death qc_nd_suspected_date_of_death date DEFAULT NULL,
  CHANGE ac_nd_suspected_date_of_death_accuracy qc_nd_suspected_date_of_death_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
  CHANGE ac_nd_suspected_date_of_death qc_nd_suspected_date_of_death date DEFAULT NULL,
  CHANGE ac_nd_suspected_date_of_death_accuracy qc_nd_suspected_date_of_death_accuracy char(1) NOT NULL DEFAULT '';
UPDATE structure_fields SET field = 'qc_nd_suspected_date_of_death' WHERE field = 'ac_nd_suspected_date_of_death';
UPDATE structure_fields SET language_label = 'sardo cause of death' WHERE field = 'qc_nd_sardo_cause_of_death';
INSERT INTO i18n (id,en,fr) VALUES ('sardo cause of death', 'Cause of Death (SARDO)', 'Cause du décès (SARDO)');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Consentement : Add file name
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE consent_masters ADD COLUMN qc_nd_file_name VARCHAR(500) DEFAULT NULL;
ALTER TABLE consent_masters_revs ADD COLUMN qc_nd_file_name VARCHAR(500) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'qc_nd_file_name', 'input',  NULL , '0', 'size=50', '', '', 'file name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='file name' AND `language_tag`=''), '1', '17', 'additional information', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='18', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Use/Event : Add file name + create new type of Use/Event (Microarray, CA125, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_internal_uses ADD COLUMN qc_nd_file_name VARCHAR(500) DEFAULT NULL;
ALTER TABLE aliquot_internal_uses_revs ADD COLUMN qc_nd_file_name VARCHAR(500) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'qc_nd_file_name', 'input',  NULL , '0', 'size=50', '', '', 'file name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='qc_nd_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='file name' AND `language_tag`=''), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_index`='1', flag_search='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='qc_nd_file_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @modified_by = 2;
SET @modified=(SELECT NOW() FROM users WHERE id = @modified_by);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('CA-125', '', '', '1', @control_id, @modified, @modified, @modified_by, @modified_by), 
('ELISA', '', '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('karyotype', 'Karyotype', 'Caryotype', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sequencing', 'Sequencing', 'Sequencage', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('microarray','Microarray', 'Puce à ADN', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
INSERT INTO structure_permissible_values_customs_revs (`use_as_input`, `value`, `control_id`, `modified_by`, `id`, `version_created`)
(SELECT `use_as_input`, `value`, `control_id`, `modified_by`, `id`, `modified` FROM structure_permissible_values_customs WHERE control_id = @control_id AND modified = @modified);

UPDATE aliquot_internal_uses SET type = 'CA-125', modified = @modified, modified_by = @modified_by WHERE (use_code LIKE '%CA-125%' OR use_code LIKE '%CA125%') AND type = 'internal use' AND deleted <> 1;
UPDATE aliquot_internal_uses SET type = 'ELISA', modified = @modified, modified_by = @modified_by WHERE use_code LIKE '%elisa%' AND type = 'internal use' AND deleted <> 1;
UPDATE aliquot_internal_uses SET type = 'karyotype', modified = @modified, modified_by = @modified_by WHERE use_code LIKE '%caryotype%' AND type = 'internal use' AND deleted <> 1;
UPDATE aliquot_internal_uses SET type = 'sequencing', modified = @modified, modified_by = @modified_by WHERE use_code LIKE '%sequencage%' AND type = 'internal use' AND deleted <> 1;
UPDATE aliquot_internal_uses SET type = 'microarray', modified = @modified, modified_by = @modified_by WHERE use_code LIKE '%microarray%' AND type = 'internal use' AND deleted <> 1;

INSERT INTO aliquot_internal_uses (use_code, aliquot_master_id, type, study_summary_id, created, created_by, modified, modified_by)
(SELECT REPLACE(REPLACE(`Order`.short_title, 'Microarray [', ''), ']', ''), OrderItem.aliquot_master_id, 'microarray', default_study_summary_id, @modified, @modified_by, @modified, @modified_by
FROM orders `Order`, order_items OrderItem
WHERE `Order`.short_title  LIKE '%micr%'
AND `Order`.deleted <> 1
AND `Order`.id = OrderItem.order_id
AND OrderItem.deleted <> 1);

INSERT INTO aliquot_internal_uses_revs (id,aliquot_master_id,type,use_code,use_details,used_volume,use_datetime,use_datetime_accuracy,duration,duration_unit,used_by,study_summary_id,modified_by,version_created)
(SELECT id,aliquot_master_id,type,use_code,use_details,used_volume,use_datetime,use_datetime_accuracy,duration,duration_unit,used_by,study_summary_id,modified_by,modified FROM aliquot_internal_uses WHERE modified = @modified AND modified_by = @modified_by);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Aliquot Core : size
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE ad_tissue_cores ADD COLUMN qc_nd_size_mm FLOAT(6,1) DEFAULT NULL;
ALTER TABLE ad_tissue_cores_revs ADD COLUMN qc_nd_size_mm FLOAT(6,1) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'qc_nd_size_mm', 'float_positive',  NULL , '0', 'size=5', '', '', 'size', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_nd_size_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='size' AND `language_tag`=''), '1', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('size','Size','Taille');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study (II)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE study_summaries ADD COLUMN qc_nd_pubmed_ids TEXT DEFAULT NULL;
ALTER TABLE study_summaries_revs ADD COLUMN qc_nd_pubmed_ids TEXT DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_pubmed_ids', 'textarea',  NULL , '0', 'cols=40,rows=1', '', '', 'pubmed ids', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_pubmed_ids' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=1' AND `default`='' AND `language_help`='' AND `language_label`='pubmed ids' AND `language_tag`=''), '2', '20', 'literature', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES
('literature','Literature','Literature'),
('pubmed ids','PubMed IDs','PubMed IDs');

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') ,  `setting`='' WHERE model='StudyInvestigator' AND field='last_name';
UPDATE structure_fields SET  `language_label`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='first_name' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='name',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='last_name' AND `type`='select' AND structure_value_domain  IS NULL ;

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `tablename`='study_fundings' AND `field`='study_sponsor');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_study_fundings', "StructurePermissibleValuesCustom::getCustomDropdown('Study Fundings')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Study Fundings', 1, 50, 'study');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_study_fundings') ,  `setting`='' WHERE model='StudyFunding' AND tablename='study_fundings' AND field='study_sponsor' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_study_fundings') ,  `language_label`='name' WHERE model='StudyFunding' AND tablename='study_fundings' AND field='study_sponsor' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_study_fundings');

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `field`='last_name'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE  `tablename`='study_fundings' AND `field`='study_sponsor'), 'notEmpty', '');

SET @modified_by = 2;
SET @modified=(SELECT NOW() FROM users WHERE id = @modified_by);
INSERT INTO study_investigators (study_summary_id, last_name, created, created_by, modified, modified_by)
(SELECT id, qc_nd_researcher, @modified, @modified_by, @modified, @modified_by FROM study_summaries WHERE deleted <> 1 AND qc_nd_researcher IS NOT NULL AND qc_nd_researcher NOT LIKE '');
INSERT INTO study_investigators_revs (id, study_summary_id, last_name, version_created, modified_by)
(SELECT id, study_summary_id, last_name, @modified, @modified_by FROM study_investigators);
ALTER TABLE study_summaries DROP COLUMN qc_nd_researcher;
ALTER TABLE study_summaries_revs DROP COLUMN qc_nd_researcher;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_researcher' AND `language_label`='researcher' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_researcher' AND `language_label`='researcher' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_researcher' AND `language_label`='researcher' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers')  AND `flag_confidential`='0'), '1', '13', '', '', '1', 'Investigator', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'Generated', '', 'qc_nd_study_investigators', 'input',  NULL , '0', '', '', '', 'Investigator', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_nd_study_investigators' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Investigator' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_tag`='1', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='name', `flag_override_tag`='1', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='name' WHERE model='Generated' AND tablename='' AND field='qc_nd_study_investigators' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='Investigator', `flag_override_label`='1', `language_label`='name' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='Investigator' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_nd_study_investigators' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('selected value already exists for the study', 'Selected value already exists for the study', "La valeur sélectionnée existe déjà pour l'étude");

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_study_participants');
DELETE FROM structures WHERE alias='qc_nd_study_participants';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Work on sample type nail
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO sd_spe_nails (sample_master_id) (SELECT sample_master_id FROM qc_nd_sd_spe_nails);
INSERT INTO sd_spe_nails_revs (sample_master_id, version_id, version_created) (SELECT sample_master_id, version_id, version_created FROM qc_nd_sd_spe_nails_revs);
UPDATE sample_controls SET detail_tablename = 'sd_spe_nails' WHERE detail_tablename = 'qc_nd_sd_spe_nails';

INSERT INTO ad_envelopes (aliquot_master_id) (SELECT aliquot_master_id FROM qc_nd_ad_envelopes);
INSERT INTO ad_envelopes_revs (aliquot_master_id, version_id, version_created) (SELECT aliquot_master_id, version_id, version_created FROM qc_nd_ad_envelopes_revs);
UPDATE aliquot_controls SET detail_tablename = 'ad_envelopes' WHERE detail_tablename = 'qc_nd_ad_envelopes';

DROP TABLE qc_nd_sd_spe_nails;
DROP TABLE qc_nd_sd_spe_nails_revs;
DROP TABLE qc_nd_ad_envelopes_revs;
DROP TABLE qc_nd_ad_envelopes;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study Summary
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_value_domains (domain_name, source) VALUES ('qc_nd_study_investigators', "Study.StudySummary::getStudyComplementaryInformationFromId");
UPDATE structure_fields 
SET model='StudySummary',
tablename='study_summaries',
field='id',
language_label = 'study investigator',
`type`='select',  
`structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_study_investigators') 
WHERE model='Generated' AND tablename='' AND field='qc_nd_study_investigators';
UPDATE structure_formats SET `display_order`='9', `language_heading`='', `flag_override_label`='1', `language_label`='study investigator' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='last_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_researchers') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_study_investigators') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET category = 'progression' WHERE category = 'progression - locoregional' AND controls_type = 'sardo';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Databrowser
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- TMA slide and order
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type = 'input');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Sample and Aliquot View
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tissue Core size
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `language_label`='size (mm)' WHERE model='AliquotDetail' AND tablename='' AND field='qc_nd_size_mm' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('size (mm)', 'Size (mm)', 'Taille (mm)');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- New sample type
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- stool

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(222, 224, 225);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(78);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(67);

ALTER TABLE lab_type_laterality_match DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
INSERT INTO lab_type_laterality_match (selected_type_code, sample_type_matching) VALUES ('ST', 'stool');

UPDATE sample_controls SET detail_form_alias = CONCAT('specimens,qc_nd_spe_stools') WHERE sample_type = 'stool';
INSERT INTO structures(`alias`) VALUES ('qc_nd_spe_stools');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_spe_stools'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='type_code' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_labo_type_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='labo type code' AND `language_tag`=''), '1', '436', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_spe_stools'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='sequence_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='sequence number' AND `language_tag`=''), '1', '437', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias, ',qc_nd_ad_stools')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'stool') AND aliquot_type = 'tube';
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_stool_buffer', "StructurePermissibleValuesCustom::getCustomDropdown('Stool Buffers')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Stool Buffers', 1, 30, 'inventory');
INSERT INTO structures(`alias`) VALUES ('qc_nd_ad_stools');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'tmp_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_buffer') , '0', '', '', '', 'buffer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ad_stools'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_buffer')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='buffer' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('buffer', 'Buffer', 'Tampon');

ALTER TABLE sd_spe_stools
  ADD COLUMN qc_nd_time_to_last_stool_h int(4) DEFAULT NULL,
  ADD COLUMN qc_nd_bristol_stool_scale int(4) DEFAULT NULL;
ALTER TABLE sd_spe_stools_revs
  ADD COLUMN qc_nd_time_to_last_stool_h int(4) DEFAULT NULL,
  ADD COLUMN qc_nd_bristol_stool_scale int(4) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'SampleDetail', 'sd_spe_stools', 'qc_nd_time_to_last_stool_h', 'integer_positive',  NULL , '0', 'size=2', '', '', 'time to last stool (h)', ''), 
('ClinicalAnnotation', 'SampleDetail', 'sd_spe_stools', 'qc_nd_bristol_stool_scale', 'integer_positive',  NULL , '0', 'size=2', '', '', 'bristol stool scale', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_spe_stools'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_stools' AND `field`='qc_nd_time_to_last_stool_h' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='' AND `language_label`='time to last stool (h)' AND `language_tag`=''), '1', '441', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_spe_stools'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_stools' AND `field`='qc_nd_bristol_stool_scale' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='' AND `language_label`='bristol stool scale' AND `language_tag`=''), '1', '442', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='qc_nd_bristol_stool_scale'), 'range,0,8', 'value from 1 to 7');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('value from 1 to 7', 'Value from 1 to 7', 'Valeur de 1 à 7'),
('time to last stool (h)', 'Time to Last Stool (h)', 'Temps depuis la dernière selle (h)'),
('bristol stool scale', 'Bristol Stool Scale', 'Échelle de Bristol');

-- vaginal swab

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(223, 226);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(79);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(68);

INSERT INTO lab_type_laterality_match (selected_type_code, sample_type_matching) VALUES ('VS', 'vaginal swab');

UPDATE sample_controls SET detail_form_alias = CONCAT('specimens,qc_nd_spe_vaginal_swabs') WHERE sample_type = 'vaginal swab';
ALTER TABLE sd_spe_vaginal_swabs
  ADD COLUMN qc_nd_collection_region varchar(100) DEFAULT NULL,
  ADD COLUMN qc_nd_ph float(6,1) DEFAULT NULL;
ALTER TABLE sd_spe_vaginal_swabs_revs
  ADD COLUMN qc_nd_collection_region varchar(100) DEFAULT NULL,
  ADD COLUMN qc_nd_ph float(6,1) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('qc_nd_spe_vaginal_swabs');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_vaginal_swab_collection_site', "StructurePermissibleValuesCustom::getCustomDropdown('Vaginal Swab Collection Site')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Vaginal Swab Collection Site', 1, 100, 'inventory');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_vaginal_swabs', 'qc_nd_collection_region', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_vaginal_swab_collection_site') , '0', '', '', '', 'collection site', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_vaginal_swabs', 'qc_nd_ph', 'select',  NULL , '0', '', '', '', 'ph value', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_spe_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_vaginal_swabs' AND `field`='qc_nd_collection_region' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_vaginal_swab_collection_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection site' AND `language_tag`=''), '1', '441', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_spe_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_vaginal_swabs' AND `field`='qc_nd_ph' AND `type`='select' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ph value' AND `language_tag`=''), '1', '442', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_spe_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='type_code' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_labo_type_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='labo type code' AND `language_tag`=''), '1', '436', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_spe_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='sequence_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='sequence number' AND `language_tag`=''), '1', '437', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_fields SET `type`='float_positive', `setting`='size=3' WHERE `tablename`='sd_spe_vaginal_swabs' AND `field`='qc_nd_ph';
UPDATE structure_fields SET `language_label`='vaginal swab collection site' WHERE model='SampleDetail' AND tablename='sd_spe_vaginal_swabs' AND field='qc_nd_collection_region' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_vaginal_swab_collection_site');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('ph value', 'pH', 'pH'), ('vaginal swab collection site', 'Site', 'Site');

UPDATE aliquot_controls 
SET detail_form_alias = CONCAT(detail_form_alias, ',qc_nd_ad_vaginal_swabs')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'vaginal swab') AND aliquot_type = 'tube';
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_vaginal_swab_buffer', "StructurePermissibleValuesCustom::getCustomDropdown('Vaginal Swab Buffers')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Vaginal Swab Buffers', 1, 30, 'inventory');
INSERT INTO structures(`alias`) VALUES ('qc_nd_ad_vaginal_swabs');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'tmp_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_vaginal_swab_buffer') , '0', '', '', '', 'buffer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ad_vaginal_swabs'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_vaginal_swab_buffer')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='buffer' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Aliquot Internal Use
--
-- Note: 
--    When a block is sent to the 12th floor to create TMA blocks, use events molecular pathology platform - in/out
--    When a block is reserved for the CPCBN project it has to be flagged as  reserverd for study and ths study should be set.
--    
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = 2;
SET @modified=(SELECT NOW() FROM users WHERE id = @modified_by);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('MDT', '', '', '1', @control_id, @modified, @modified, @modified_by, @modified_by), 
('molecular pathology platform - in', 'Molecular Pathology Platform - In', 'Plateforme de pathologie moléculaire - Entrée', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('molecular pathology platform - out', 'Molecular Pathology Platform - Out', 'Plateforme de pathologie moléculaire - Sortie', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Order
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_order_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 'notEmpty', '');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- LAB
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO INTO i18n (id,en,fr) 
VALUES 
('prostate nodule review','Prostate Nodule Review', 'Révision des nodules de prostate'),
('prostate nodule review','Prostate Nodule Review', 'Révision des nodules de prostate');

-- SCC

INSERT INTO event_controls (event_group, event_type, flag_active, detail_form_alias, detail_tablename, databrowser_label, use_addgrid, use_detail_form_for_index)
VALUES
('lab','scc', 1, 'qc_nd_ed_sccs', 'qc_nd_ed_sccs', 'lab|scc', 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_sccs` (
	value float(6,2) DEFAULT NULL,
	`event_master_id` int(11) NOT NULL,
	KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_sccs_revs` (
	value float(6,2) DEFAULT NULL,
	`event_master_id` int(11) NOT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_sccs`
  ADD CONSTRAINT `qc_nd_ed_sccs_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_sccs');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'EventDetail', 'qc_nd_ed_sccs', 'value', 'float_positive',  NULL , '0', 'size=3', '', '', 'value (ug/l)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_sccs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_sccs' AND `field`='value' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='value (ug/l)' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('scc', 'SCC', 'SCC'),
('value (ug/l)', 'Value (ug/l)', 'Valeur (ug/l)');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_sccs' AND `field`='value'), 'notEmpty', '');

-- VPH

INSERT INTO event_controls (event_group, event_type, flag_active, detail_form_alias, detail_tablename, databrowser_label, use_addgrid, use_detail_form_for_index)
VALUES
('lab','vph', 1, 'qc_nd_ed_vphs', 'qc_nd_ed_vphs', 'lab|vph', 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_vphs` (
	type int(4) DEFAULT NULL,
	`event_master_id` int(11) NOT NULL,
	KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_vphs_revs` (
	type int(4) DEFAULT NULL,
	`event_master_id` int(11) NOT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_vphs`
  ADD CONSTRAINT `qc_nd_ed_vphs_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_vphs');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'EventDetail', 'qc_nd_ed_vphs', 'type', 'integer_positive',  NULL , '0', 'size=3', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_vphs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_vphs' AND `field`='type' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('vph', 'VPH', 'VPH');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_vphs' AND field = 'type'), 'notEmpty', '');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CLINIC
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ImmuneCarta 

INSERT INTO event_controls (event_group, event_type, flag_active, detail_form_alias, detail_tablename, databrowser_label, use_addgrid, use_detail_form_for_index)
VALUES
('clinical','immuncarta', 1, 'qc_nd_ed_immuncartas', 'qc_nd_ed_immuncartas', 'clinical|immuncarta', 0, 0);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_immuncartas` (
	other_cancer char(1) DEFAULT '',
	organ_transplantation_immunosuppressant char(1) DEFAULT '',
	crohns_disease char(1) DEFAULT '',
	asthma_glucocorticoids char(1) DEFAULT '',
	lupus_erythematosus char(1) DEFAULT '',
	psoriasis_orally char(1) DEFAULT '',
	rheumatoid_arthritis_orally char(1) DEFAULT '',
	multiple_sclerosis char(1) DEFAULT '',
	patient_excluded char(1) DEFAULT '',
	`event_master_id` int(11) NOT NULL,
	KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_immuncartas_revs` (
	other_cancer char(1) DEFAULT '',
	organ_transplantation_immunosuppressant char(1) DEFAULT '',
	crohns_disease char(1) DEFAULT '',
	asthma_glucocorticoids char(1) DEFAULT '',
	lupus_erythematosus char(1) DEFAULT '',
	psoriasis_orally char(1) DEFAULT '',
	rheumatoid_arthritis_orally char(1) DEFAULT '',
	multiple_sclerosis char(1) DEFAULT '',
	patient_excluded char(1) DEFAULT '',
	`event_master_id` int(11) NOT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_immuncartas`
  ADD CONSTRAINT `qc_nd_ed_immuncartas_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_immuncartas');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'other_cancer', 'yes_no',  NULL , '0', '', '', '', 'other cancer', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'organ_transplantation_immunosuppressant', 'yes_no',  NULL , '0', '', '', '', 'organ transplantation (immunosuppressant)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'crohns_disease', 'yes_no',  NULL , '0', '', '', '', 'crohn\'s disease', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'asthma_glucocorticoids', 'yes_no',  NULL , '0', '', '', '', 'asthma (glucocorticoids)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'lupus_erythematosus', 'yes_no',  NULL , '0', '', '', '', 'lupus erythematosus', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'psoriasis_orally', 'yes_no',  NULL , '0', '', '', '', 'psoriasis (orally)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'rheumatoid_arthritis_orally', 'yes_no',  NULL , '0', '', '', '', 'rheumatoid arthritis (orally)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'multiple_sclerosis', 'yes_no',  NULL , '0', '', '', '', 'multiple sclerosis', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_immuncartas', 'patient_excluded', 'yes_no',  NULL , '0', '', '', '', 'patient excluded', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='other_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other cancer' AND `language_tag`=''), '2', '10', 'treatment', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='organ_transplantation_immunosuppressant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='organ transplantation (immunosuppressant)' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='crohns_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='crohn\'s disease' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='asthma_glucocorticoids' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='asthma (glucocorticoids)' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='lupus_erythematosus' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lupus erythematosus' AND `language_tag`=''), '2', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='psoriasis_orally' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='psoriasis (orally)' AND `language_tag`=''), '2', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='rheumatoid_arthritis_orally' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='rheumatoid arthritis (orally)' AND `language_tag`=''), '2', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='multiple_sclerosis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='multiple sclerosis' AND `language_tag`=''), '2', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_immuncartas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_immuncartas' AND `field`='patient_excluded' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='patient excluded' AND `language_tag`=''), '2', '18', 'exclusion', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('other cancer', 'Other Cancer', 'Autre cancer'),
('organ transplantation (immunosuppressant)', 'Organ Transplantation (Immunosuppressant)', 'Greffe d''organe (immunosuppressif)'),
('immuncarta', 'ImmuneCarta', 'ImmuneCarta'),
('crohn''s disease', 'Crohn''s Disease', 'Maladie de Crohn'),
('asthma (glucocorticoids)', 'Asthma (Glucocorticoids)', 'Asthme (glucocorticoides)'),
('lupus erythematosus', 'Lupus Erythematosus', 'Lupus érythémateux'),
('psoriasis (orally)', 'Osoriasis (Orally)', 'Psoriasis (Oral)'),
('rheumatoid arthritis (orally)', 'Rheumatoid Arthritis (Orally)', 'Arthrite rhumatoïde (Oral)'),
('multiple sclerosis', 'Multiple Sclerosis', 'Sclérose en plaque'),
('exclusion', 'Exclusion', 'Exclusion'),
('patient excluded', 'Patient Excluded', 'Patient exclu');

-- megaprofiling

INSERT INTO event_controls (event_group, event_type, flag_active, detail_form_alias, detail_tablename, databrowser_label, use_addgrid, use_detail_form_for_index)
VALUES
('clinical','megaprofiling', 1, 'qc_nd_ed_megaprofilings', 'qc_nd_ed_megaprofilings', 'clinical|megaprofiling', 0, 0);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_megaprofilings` (
	food_habit_fruits int(4) DEFAULT NULL,
	food_habit_meat int(4) DEFAULT NULL,
	food_habit_carbohydrates int(4) DEFAULT NULL,
	food_habit_vegetables int(4) DEFAULT NULL,
	food_habit_cheese int(4) DEFAULT NULL,
	food_habit_coffee int(4) DEFAULT NULL,
	food_habit_soda int(4) DEFAULT NULL,
	food_habit_juices int(4) DEFAULT NULL,
	food_habit_milk int(4) DEFAULT NULL,
	food_habit_beer int(4) DEFAULT NULL,
	food_habit_wine int(4) DEFAULT NULL,
	antibiotics char(1) DEFAULT '',
	laxatives char(1) DEFAULT '',
	omeprazole_or_other_drugs_for_heartburn char(1) DEFAULT '',
	aspirin_or_other_pain_medications char(1) DEFAULT '',
	drug_others char(1) DEFAULT '',
	vitamins char(1) DEFAULT '',
	probiotics char(1) DEFAULT '',
	no_drug_others char(1) DEFAULT '',
	smoking_average char(1) DEFAULT '',
	sleeping_hours char(1) DEFAULT '',
	antibiotics_details text DEFAULT NULL,
	laxatives_details text DEFAULT NULL,
	omeprazole_or_other_drugs_for_heartburn_details text DEFAULT NULL,
	aspirin_or_other_pain_medications_details text DEFAULT NULL,
	drug_others_details text DEFAULT NULL,
	vitamins_details text DEFAULT NULL,
	probiotics_details text DEFAULT NULL,
	no_drug_others_details text DEFAULT NULL,
	smoking_average_details text DEFAULT NULL,
	sleeping_hours_details text DEFAULT NULL,
	food_habits varchar(250) DEFAULT NULL,
	`event_master_id` int(11) NOT NULL,
	KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_megaprofilings_revs` (
	food_habit_fruits int(4) DEFAULT NULL,
	food_habit_meat int(4) DEFAULT NULL,
	food_habit_carbohydrates int(4) DEFAULT NULL,
	food_habit_vegetables int(4) DEFAULT NULL,
	food_habit_cheese int(4) DEFAULT NULL,
	food_habit_coffee int(4) DEFAULT NULL,
	food_habit_soda int(4) DEFAULT NULL,
	food_habit_juices int(4) DEFAULT NULL,
	food_habit_milk int(4) DEFAULT NULL,
	food_habit_beer int(4) DEFAULT NULL,
	food_habit_wine int(4) DEFAULT NULL,
	antibiotics char(1) DEFAULT '',
	laxatives char(1) DEFAULT '',
	omeprazole_or_other_drugs_for_heartburn char(1) DEFAULT '',
	aspirin_or_other_pain_medications char(1) DEFAULT '',
	drug_others char(1) DEFAULT '',
	vitamins char(1) DEFAULT '',
	probiotics char(1) DEFAULT '',
	no_drug_others char(1) DEFAULT '',
	smoking_average char(1) DEFAULT '',
	sleeping_hours char(1) DEFAULT '',
	antibiotics_details text DEFAULT NULL,
	laxatives_details text DEFAULT NULL,
	omeprazole_or_other_drugs_for_heartburn_details text DEFAULT NULL,
	aspirin_or_other_pain_medications_details text DEFAULT NULL,
	drug_others_details text DEFAULT NULL,
	vitamins_details text DEFAULT NULL,
	probiotics_details text DEFAULT NULL,
	no_drug_others_details text DEFAULT NULL,
	smoking_average_details text DEFAULT NULL,
	sleeping_hours_details text DEFAULT NULL,
	food_habits varchar(250) DEFAULT NULL,
	`event_master_id` int(11) NOT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_megaprofilings`
  ADD CONSTRAINT `qc_nd_ed_megaprofilings_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_megaprofilings');
INSERT INTO structure_value_domains (domain_name) VALUES ('qc_nd_megaprofiling_food_habits');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("vegan", "vegan"),("vegetarian", "vegetarian"),("omnivore", "omnivore");
INSERT IGNORE INTO structure_value_domains_permissible_values 
(structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_megaprofiling_food_habits"), 
(SELECT id FROM structure_permissible_values WHERE value="vegan" AND language_alias="vegan"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_megaprofiling_food_habits"), 
(SELECT id FROM structure_permissible_values WHERE value="vegetarian" AND language_alias="vegetarian"), "1", "2"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_megaprofiling_food_habits"), 
(SELECT id FROM structure_permissible_values WHERE value="omnivore" AND language_alias="omnivore"), "1", "3");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habits', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits') , '0', 'size=2', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habits' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits')  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '20', 'food habits', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits') ,  `setting`='' WHERE model='EventDetail' AND tablename='qc_nd_ed_megaprofilings' AND field='food_habits' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_fruits', 'integer_positive',  NULL , '0', 'size=2', '', '', 'fruits', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_meat', 'integer_positive',  NULL , '0', 'size=2', '', '', 'meat', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_carbohydrates', 'integer_positive',  NULL , '0', 'size=2', '', '', 'carbohydrates', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_vegetables', 'integer_positive',  NULL , '0', 'size=2', '', '', 'vegetables', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_cheese', 'integer_positive',  NULL , '0', 'size=2', '', '', 'cheese', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_coffee', 'integer_positive',  NULL , '0', 'size=2', '', '', 'coffee', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_soda', 'integer_positive',  NULL , '0', 'size=2', '', '', 'soda', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_juices', 'integer_positive',  NULL , '0', 'size=2', '', '', 'juices', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_milk', 'integer_positive',  NULL , '0', 'size=2', '', '', 'milk', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_beer', 'integer_positive',  NULL , '0', 'size=2', '', '', 'beer', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'food_habit_wine', 'integer_positive',  NULL , '0', 'size=2', '', '', 'wine', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_fruits'), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_meat'), '1', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_carbohydrates'), '1', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_vegetables'), '1', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_cheese'), '1', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_coffee'), '1', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_soda'), '1', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_juices'), '1', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_milk'), '1', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_beer'), '1', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_wine'), '1', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_fruits'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_meat'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_carbohydrates'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_vegetables'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_cheese'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_coffee'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_soda'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_juices'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_milk'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_beer'), 'range,0,6', 'value from 1 to 5'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habit_wine'), 'range,0,6', 'value from 1 to 5');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'antibiotics', 'yes_no',  NULL , '0', '', '', '', 'antibiotics', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'laxatives', 'yes_no',  NULL , '0', '', '', '', 'laxatives', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'omeprazole_or_other_drugs_for_heartburn', 'yes_no',  NULL , '0', '', '', '', 'omeprazole or other drugs for heartburn', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'aspirin_or_other_pain_medications', 'yes_no',  NULL , '0', '', '', '', 'aspirin or other pain medications', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'drug_others', 'yes_no',  NULL , '0', '', '', '', 'other(s)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'vitamins', 'yes_no',  NULL , '0', '', '', '', 'vitamins', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'probiotics', 'yes_no',  NULL , '0', '', '', '', 'probiotics', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'no_drug_others', 'yes_no',  NULL , '0', '', '', '', 'other(s)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'smoking_average', 'yes_no',  NULL , '0', '', '', '', 'smoking (average/day - past 3 months)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'sleeping_hours', 'yes_no',  NULL , '0', '', '', '', 'sleeping hours (average per night)', ''),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'antibiotics_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'laxatives_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'omeprazole_or_other_drugs_for_heartburn_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'aspirin_or_other_pain_medications_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'drug_others_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'vitamins_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'probiotics_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'no_drug_others_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'smoking_average_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details'),
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_megaprofilings', 'sleeping_hours_details', 'textarea',   NULL , '0', 'cols=40,rows=1', '', '', '', 'details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='antibiotics'), '2', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='laxatives'), '2', '62', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='omeprazole_or_other_drugs_for_heartburn'), '2', '64', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='aspirin_or_other_pain_medications'), '2', '66', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='drug_others'), '2', '68', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='vitamins'), '2', '78', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='probiotics'), '2', '80', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='no_drug_others'), '2', '82', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='smoking_average'), '2', '92', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='sleeping_hours'), '2', '94', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='antibiotics_details'), '2', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='laxatives_details'), '2', '63', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='omeprazole_or_other_drugs_for_heartburn_details'), '2', '65', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='aspirin_or_other_pain_medications_details'), '2', '67', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='drug_others_details'), '2', '69', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='vitamins_details'), '2', '79', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='probiotics_details'), '2', '81', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='no_drug_others_details'), '2', '83', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='smoking_average_details'), '2', '93', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='sleeping_hours_details'), '2', '95', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits') ,  `setting`='' WHERE model='EventDetail' AND tablename='qc_nd_ed_megaprofilings' AND field='food_habits' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='food_habits' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_megaprofiling_food_habits') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='current drug use' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='antibiotics' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='over-the-counter drugs usage' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='vitamins' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='life style' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_megaprofilings' AND `field`='smoking_average' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='details', `language_tag`='' WHERE model='EventDetail' AND tablename='qc_nd_ed_megaprofilings' AND field LIKE '%_details' AND `type`='textarea';
UPDATE structure_formats SET `margin`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_megaprofilings') AND structure_field_id IN (SELECT id FROM structure_fields WHERE model='EventDetail' AND tablename='qc_nd_ed_megaprofilings' AND field LIKE '%_details' AND `type`='textarea');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('megaprofiling', 'Megaprofiling', 'Megaprofiling'),
('value from 1 to 5', 'Value from 1 to 5', 'Valeur de 1 à 5'),
('vegan', 'Vegan', 'Végétalien'),
('vegetarian', 'Vegetarian', 'Végétarien'),
('omnivore', 'Omnivore', 'Omnivore'),
('food habit', 'Food Habit', 'Habitude alimentaire'),
('food habits', 'Food Habits', 'Habitudes alimentaire'),
('habit', 'Habit', 'Habitude'),
('fruits', "Fruits", "Fruits"),
('meat', "Meat", "Viande"),
('carbohydrates', "Carbohydrates", "Glucides "),
('vegetables', "Vegetables", "Légumes "),
('cheese', "Cheese", "Fromage "),
('coffee', "Coffee", "Café"),
('soda', "Soda", "Soda"),
('juices', "Juices", "Jus"),
('milk', "Milk", "Lait"),
('beer', "Beer", "Bière "),
('wine', "Wine", "Vin"),
("current drug use", "Current drug use", "Utilisation de médicament"),
("antibiotics", "Antibiotics", "Antibiotiques"),
("laxatives", "Laxatives", "Laxatifs"),
("omeprazole or other drugs for heartburn", "Omeprazole or other drugs for heartburn", "Oméprazole ou d'autres médicaments contre les brûlures d'estomac"),
("aspirin or other pain medications", "Aspirin or other pain medications", "Aspirine ou d'autres médicaments contre la douleur"),
("over-the-counter drugs usage", "Over-the-counter drugs usage", "Médicament en vente libre"),
("vitamins", "Vitamins", "Vitamines"),
("probiotics", "Probiotics", "Probiotiques"),
("other(s)", "Other(s)", "Autre(s)"),
("life style", "Life style", "Style de vie"),
("smoking (average/day - past 3 months)", "Smoking (average/day - past 3 months)", "Fumeur (moyenne par jour - 3 derniers mois)"),
("sleeping hours (average per night)", "Sleeping hours (average per night)", "Heures de sommeil (moyenne par nuit)");

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study Consent
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_consent_study_summary_id'), 'notEmpty', '');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- É clean up
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) 
VALUES
('prostate pathology review','Prostate Pathology Review', 'Révision de la pathologie de la prostate'),
('menopause', 'Menopause', 'Ménopause'),
('family nbr linked', 'Linked to Family#-Patient#', 'Attaché au Famille#-Patient#'),
('genetic', 'Genetic', 'Génétique'),
('genetic consultation', 'Genetic Consultation', 'Consultation génétique'),
('family number', 'Family# - Patient#', 'Famille# - Patient#'),
('linked', 'Linked', ' Lié'),
('genetic test', 'Genetic Test', 'Test génétique'),
('study consent','Study Consent','Consentement d''étude');













-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- MIGRATION TODO
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT "ImportSardoDataFromXmlFile.php has been Updated" AS '### TODO ### SARDO Data Import Script'
UNION ALL
SELECT "1- Replace script on server" AS '### TODO ### SARDO Data Import Script'
UNION ALL
SELECT "2 - Check treatments (SURG/BIOP) are linked to collection " AS '### TODO ### SARDO Data Import Script'
UNION ALL
SELECT "2 - Check new PSA, CA125 and SCC are imported from SARDO or can be created manually into ATiM" AS '### TODO ### SARDO Data Import Script';


SELECT identifier_value as 'Duplicated RAMQ To fix'
FROM (
	SELECT count(*) as ct, MiId.identifier_value
	FROM misc_identifiers MiId
	INNER JOIN misc_identifier_controls MiIdCt ON MiIdCt.id = MiId.misc_identifier_control_id
	WHERE MiId.deleted <> 1
	AND MiIdCt.misc_identifier_name = 'ramq nbr'
	GROUP BY MiId.identifier_value
) res
WHERE res.ct > 1;





SELECT "Update 'Databrowser Relationship Diagram'." AS '### TODO ### Before migration';






--------------------

--------------------










mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.4_upgrade.sql
mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.5_upgrade.sql
mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.6_upgrade.sql
mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.7_upgrade.sql
mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.8_upgrade.sql
mysql -u root chumoncoaxis --default-character-set=utf8 < custom_post_268.sql
