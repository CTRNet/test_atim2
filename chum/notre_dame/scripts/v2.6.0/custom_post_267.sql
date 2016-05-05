-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Aliquots / Samples Controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(193, 200, 203, 194);
DELETE FROM realiquoting_controls WHERE id IN(41);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(44);

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Consent
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

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0'), '1', '1', '', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_study_summary_id';
DELETE FROM  structures WHERE alias='qc_nd_cd_study';

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='study_summary_id'), 'notEmpty', '');

UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Annotation > Study > Study to MiscIdentifier
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

INSERT INTO misc_identifier_controls (misc_identifier_name, flag_active, flag_link_to_study) VALUES ('study number', 1, 1);
SET @misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'study number');
UPDATE misc_identifier_controls SET flag_unique = 0, flag_confidential = 0 WHERE id = @misc_identifier_control_id;
INSERT INTO i18n (id,en,fr) VALUES ('study number', 'Study #', 'Étude #');

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

-- APS project

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

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Annotation > Lifestyle
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

select id 'ERR#43434343: Lifestyle data exists' from event_masters WHERE event_control_id = (SELECT id FROM event_controls WHERE event_type = 'questionnaire' AND flag_active = 1);
UPDATE event_controls SET flag_active = 0 WHERE event_type = 'study';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lifestyle%';
UPDATE event_controls SET flag_Active = 0 WHERE event_type = 'questionnaire' AND flag_active = 1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Message creation in batch
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Order
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

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_institutions_and_laboratories', "StructurePermissibleValuesCustom::getCustomDropdown('Institutions & Laboratories')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Institutions & Laboratories', 1, 50, 'order');
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

SELECT CONCAT(short_title, ' (order_id = ',orders.id, ')') AS 'TODO: order with study issue to remove order line study', orders.short_title, orders.default_study_summary_id, order_lines.study_summary_id
FROM orders INNER JOIN order_lines ON orders.id = order_lines.order_id
WHERE orders.deleted <> 1 AND order_lines.deleted <> 1
AND (order_lines.study_summary_id IS NOT NULL AND orders.default_study_summary_id != order_lines.study_summary_id)
OR (order_lines.study_summary_id IS NOT NULL AND orders.default_study_summary_id IS NULL);

-- TODO Validate with manon if the order line study should be hidden

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study
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

ALTER TABLE study_summaries ADD COLUMN qc_nd_institution VARCHAR(50) DEFAULT NULL;
ALTER TABLE study_summaries_revs ADD COLUMN qc_nd_institution VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_institutions_and_laboratories') , '0', '', '', '', 'laboratory / institution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_institutions_and_laboratories')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laboratory / institution' AND `language_tag`=''), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

ALTER TABLE study_summaries 
  ADD COLUMN qc_nd_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN qc_nd_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_ethical_approval_file_name varchar(500) DEFAULT null;
ALTER TABLE study_summaries_revs 
  ADD COLUMN qc_nd_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN qc_nd_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN qc_nd_ethical_approval_file_name varchar(500) DEFAULT null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_ethical_approved', 'yes_no',  NULL , '0', '', '', '', 'ethic', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_ethical_approval_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_mta_data_sharing_approved', 'yes_no',  NULL , '0', '', '', '', 'mta data sharing', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_ethical_approval_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_ethical_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethic' AND `language_tag`=''), '2', '1', 'approval', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_ethical_approval_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_mta_data_sharing_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta data sharing' AND `language_tag`=''), '2', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_ethical_approval_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
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
			AND SM.collection_id = COL.id AND SM.sample_control_id = SC.id AND sc.sample_type = 'tissue'
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

UPDATE collections SET collection_notes = CONCAT(collection_notes, ' ATiM patho # [', qc_nd_pathology_nbr,'] has been created by v2.6.7 script from Participant Patho Identifier (identifier type deleted).') 
WHERE qc_nd_pathology_nbr IS NOT NULL AND qc_nd_pathology_nbr NOT LIKE ''
AND collection_notes IS NOT NULL;

UPDATE collections SET collection_notes = CONCAT('ATiM patho # [', qc_nd_pathology_nbr,'] has been created by v2.6.7 script from Participant Patho Identifier (identifier type delete).')
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
SET COL.collection_notes = CONCAT(COL.collection_notes, ' ATiM patho # [', RES3.patho_dpt_block_code,'] has been created by v2.6.7 script from Tissue Block Patho Number (field hidden) of the collection.'),
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
SET COL.collection_notes = CONCAT('ATiM patho # [', RES3.patho_dpt_block_code,'] has been created by v2.6.7 script from Tissue Block Patho Number (field hidden) of the collection.'),
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
('karyotype', '', '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sequencing', '', '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('microarray','', '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
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























-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


 
C:\_NicolasLuc\Server\www\chum_onco_axis\scripts\v2.6.0>mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.6_upgrade.sql

### MESSAGE ###
Added option to link a TMA slide to a study. (See structures 'tma_slides').


Lister les champs attachés a chacque custom list
SELECT 
REPLACE(svd.source, 'StructurePermissibleValuesCustom::getCustomDropdown(', '') AS custom_list,
str.alias AS structure_alias,
sfi.plugin AS plugin,
sfi.model AS model,
sfi.tablename AS tablename,
sfi.field AS field,
sfi.structure_value_domain AS structure_value_domain,
svd.domain_name AS structure_value_domain_name,
IF((sfo.flag_override_label = '1'),sfo.language_label,sfi.language_label) AS language_label,
IF((sfo.flag_override_tag = '1'),sfo.language_tag,sfi.language_tag) AS language_tag
FROM structure_formats sfo 
INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
INNER JOIN structures str ON str.id = sfo.structure_id
INNER JOIN structure_value_domains svd ON svd.id = sfi.structure_value_domain
WHERE (sfo.flag_add =1 OR sfo.flag_addgrid =1 OR sfo.flag_index =1 OR sfo.flag_detail)
AND svd.source LIKE 'StructurePermissibleValuesCustom::getCustomDropdown(%)'
AND svd.domain_name IN ('qc_nd_researchers', 'qc_nd_institutions_and_laboratories')
ORDER BY svd.source;


