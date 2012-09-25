
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
('participant identifier','Collection#','Collection#');
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
