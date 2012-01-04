REPLACE i18n (id,en,fr) VALUES ('core_installname','LD - Lymphoma','LD - Lymphome');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lymphoma','Lymphoma','Lymphome');

-- ----------------------------------------------------------------------------------------
-- INVENTORY
-- ----------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'acquisition_label');

UPDATE banks SET name = 'Lymphoma', description = '' WHERE id = 1;
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty', '', 'value is required');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(152, 164, 181, 182, 180, 183, 184, 167, 170, 171, 169, 172, 187, 186, 185);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 23, 136, 25, 24, 4, 118, 6, 142, 143, 141, 144, 7, 130, 101, 140);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11, 33);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(44, 45);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12, 34);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_tissue_source_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''tissue source'')');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="custom_tissue_source_list")
WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('tissue source', '1', '40');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('spleen', 'Spleen', 'Rate', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue source')),
('extra nodal', 'Extra Nodal', 'Extra-Ganglionnaire', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue source')),
('lymph node', 'Lymph Node', 'Ganglion Lymphatique', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue source'));

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'is_problematic');

ALTER TABLE `sd_spe_tissues`
  ADD COLUMN `ld_lymph_tumor_percentage` decimal(5,2) DEFAULT NULL AFTER tissue_weight_unit;
ALTER TABLE `sd_spe_tissues_revs`
  ADD COLUMN `ld_lymph_tumor_percentage` decimal(5,2) DEFAULT NULL AFTER tissue_weight_unit; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'ld_lymph_tumor_percentage', 'float',  NULL , '0', 'size=5', '', '', 'ld lym tumor percentage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ld_lymph_tumor_percentage' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ld lym tumor percentage' AND `language_tag`=''), '1', '450', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('ld lym tumor percentage','Tumor %','% Tumeur');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("snap frozen","snap frozen");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="block_type"),  
(SELECT id FROM structure_permissible_values WHERE value="snap frozen" AND language_alias="snap frozen"), "1", "1");
INSERT INTO i18n (id,en,fr) VALUES ('snap frozen','Snap Frozen','''snap frozen''');

UPDATE aliquot_controls SET flag_active=false WHERE id IN(34, 35);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(35);
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(176, 177, 175, 178); 
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(36);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(43);

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field` IN ('pathology_reception_datetime'));

ALTER TABLE sample_masters
  ADD COLUMN ld_lymph_specimen_number INT(7) NOT NULL AFTER sample_code;
ALTER TABLE sample_masters_revs
  ADD COLUMN ld_lymph_specimen_number INT(7) NOT NULL AFTER sample_code;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleMaster', 'sample_masters', 'ld_lymph_specimen_number', 'integer',  NULL , '0', 'size=6', '', '', 'specimen number', '');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='ld_lymph_specimen_number'), 'notEmpty', '', 'value is required');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('specimen number', 'Specimen #', 'Spécimen #'), 
('specimen number should be unique', 'Specimen number should be unique!', 'Le numéro du spécimen doit être unique!');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='320' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewSample', '', 'ld_lymph_specimen_number', 'input',  NULL , '0', 'size=6', '', '', 'specimen number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='ld_lymph_specimen_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '4', '', '0', '', '0', '', '0', '', '1', 'input', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category,
samp.ld_lymph_specimen_number

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;
INSERT INTO i18n (id,en,fr) VALUES ('the specimen number should be unique','The specimen number should be unique!','Le numéro de specimen doit être unique!');

UPDATE structure_fields SET language_label = 'aliquot barcode' WHERE field = 'barcode' AND model IN ('AliquotMaster', 'ViewAliquot');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('aliquot barcode', 'Label', 'Étiquette');
REPLACE INTO i18n (id,en,fr) VALUES ('aliquot barcode', 'Label', 'Étiquette');
REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('the aliquot with barcode [%s] has reached a volume bellow 0', '', 'The aliquot with label [%s] has reached a volume below 0.', 'L''aliquot avec l''étiquette [%s] a atteint un volume inférieur à 0.'),
('the barcode [%s] has already been recorded', '', 'The label [%s] has already been recorded!', 'L''étiquette [%s] a déjà été enregistré!'),
('you can not record barcode [%s] twice', '', 'You can not record label [%s] twice!', 'Vous ne pouvez enregistrer l''étiquette [%s] deux fois!');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'aliquot_label');

ALTER TABLE sample_masters
  MODIFY ld_lymph_specimen_number VARCHAR(5) NOT NULL;
ALTER TABLE sample_masters_revs
  MODIFY ld_lymph_specimen_number VARCHAR(5) NOT NULL;
UPDATE structure_fields SET type = 'input' WHERE field  = 'ld_lymph_specimen_number';
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='ld_lymph_specimen_number'), 'custom,/^[0-9]{5}$/', '', 'specimen_number_format_error');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('specimen_number_format_error', 
'Specimen number should be an integer value of 5 digits, the 2 first one being the year of the collection!', 
'Le numéro du spécimen doit être entier de 5 chiffres dont les 2 premiers definissent l''année de la collection!');

UPDATE specimen_review_controls SET flag_active = 0;
UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/inventorymanagement/specimen_reviews/%';

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------
-- SOP
-- ----------------------------------------------------------------------------------------

DELETE FROM sop_controls WHERE id != 2;
INSERT INTO `sop_controls` (`id`, `sop_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `flag_active`) 
VALUES
(null, 'LD', 'Lymphoma', 'sopd_inventory_alls', 'sopmasters,sopd_inventory_all', '', '', 1);

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='sop_master_id');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id' AND model like '%aliquot%');

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id' AND model like '%collection%');

-- ----------------------------------------------------------------------------------------
-- CLINICAL ANNOTATION
-- ----------------------------------------------------------------------------------------

-- PROFILE --------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id from structure_fields WHERE field IN ('middle_name','marital_status','language_preferred','race','title','cod_confirmation_source','secondary_cod_icd10_code'));

ALTER TABLE participants
  ADD `ld_lymph_last_fu_date` date DEFAULT NULL AFTER race,
  ADD `ld_lymph_last_fu_date_accuracy` char(1) NOT NULL DEFAULT '' AFTER ld_lymph_last_fu_date,
  ADD `ld_lymph_cause_of_death` text AFTER date_of_death;
ALTER TABLE participants_revs
  ADD `ld_lymph_last_fu_date` date DEFAULT NULL AFTER race,
  ADD `ld_lymph_last_fu_date_accuracy` char(1) NOT NULL DEFAULT '' AFTER ld_lymph_last_fu_date,
  ADD `ld_lymph_cause_of_death` text AFTER date_of_death;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ld_lymph_last_fu_date', 'date',  NULL , '0', '', '', '', 'last fu datetime', ''), 
('Clinicalannotation', 'Participant', 'participants', 'ld_lymph_cause_of_death', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'cause of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ld_lymph_last_fu_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ld_lymph_cause_of_death' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='cause of death' AND `language_tag`=''), '3', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0');
UPDATE structure_formats SET display_order = 3 WHERE structure_id = (SELECT id FROM structures WHERE alias='participants') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'date_of_death');
UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'cod_icd10_code' AND model = 'Participant');
INSERT INTO i18n (id,en) VALUES ('last fu datetime', 'Date of last Follow-Up');

UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- MISC IDENTIF. --------------------------------------------------------------------------

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`) 
VALUES (NULL, 'hospital number', '1', '0', NULL, NULL, '1', '1'),(NULL, 'RAMQ', '1', '0', NULL, NULL, '1', '1');

INSERT INTO i18n (id,en,fr)
VALUES 
('the submitted bank number already exists','The submitted Bank Number already exists!','Le numéro de banque existe déjà!'),
('hospital number','U-Number','U-Numéro'),
('RAMQ','RAMQ','RAMQ');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- CONSENT MASTER -------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph. consent', 1, 'consent_masters', 'cd_nationals', 0, 'ld lymph. consent');
INSERT INTO i18n (id,en,fr)
VALUES ('ld lymph. consent','LD-Lymph Consent','LD-Lymph Consentement');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- DIAGNOSIS ------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('dx_date', 'Date', 'Date');

UPDATE diagnosis_controls SET flag_active = 0;
UPDATE diagnosis_controls SET flag_active = 1 WHERE controls_type = 'primary diagnosis unknown';

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id = (SELECT id from structures WHERE alias = 'view_diagnosis') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('topography','icd10_code'));

-- Lymphoma

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'lymphoma', 1, 'diagnosismasters,dx_primary,ld_lymph_dx_lymphomas', 'ld_lymph_dx_lymphomas', 0, 'primary|lymphoma', 0),
(null, 'secondary', 'lymphoma', 1, 'diagnosismasters,dx_secondary,ld_lymph_dx_lymphomas', 'ld_lymph_dx_lymphomas', 0, 'primary|secondary', 0);

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id IN (SELECT id from structures WHERE alias IN ('dx_primary', 'dx_secondary'));

DROP TABLE IF EXISTS `ld_lymph_dx_lymphomas`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_lymphomas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL,
  
  `primary_hematologist` varchar(50) DEFAULT '',
    
  `baseline_history_desc` text,
  `baseline_b_symptoms` char(1) DEFAULT '',
  `baseline_b_desc` text,  
  `baseline_ecog` int(3) DEFAULT NULL,
  
  `nhl_stage_nbr` varchar(6) DEFAULT '',  
  `nhl_stage_alpha` varchar(6) DEFAULT '',  
  `cll_rai_stage` varchar(20) DEFAULT '',  
  
  `prognosis_ipi` decimal(7,2) DEFAULT NULL,  
  `prognosis_flipi` decimal(7,2) DEFAULT NULL,  
  `prognosis_hd` decimal(7,2) DEFAULT NULL,  
  `prognosis_mipi` decimal(7,2) DEFAULT NULL, 
  
  `pulmonary_comorbidity` char(1) DEFAULT '',
  `cardiac_comorbidity` char(1) DEFAULT '',
  `renal_comorbidity` char(1) DEFAULT '',
  `hepatic_comorbidity` char(1) DEFAULT '',
  `cns_comorbidity` char(1) DEFAULT '',
  `other_comorbidity` char(1) DEFAULT '',
  `comorbidities_precision` text,  
  
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;  

ALTER TABLE `ld_lymph_dx_lymphomas`
  ADD CONSTRAINT `FK_ld_lymph_dx_lymphomas_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_dx_lymphomas_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_lymphomas_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  
  `primary_hematologist` varchar(50) DEFAULT '',
  
  `baseline_history_desc` text,
  `baseline_b_symptoms` char(1) DEFAULT '',
  `baseline_b_desc` text,  
  `baseline_ecog` int(3) DEFAULT NULL,
  
  `nhl_stage_nbr` varchar(6) DEFAULT '',  
  `nhl_stage_alpha` varchar(6) DEFAULT '',  
  `cll_rai_stage` varchar(20) DEFAULT '',  
  
  `prognosis_ipi` decimal(7,2) DEFAULT NULL,  
  `prognosis_flipi` decimal(7,2) DEFAULT NULL,  
  `prognosis_hd` decimal(7,2) DEFAULT NULL,  
  `prognosis_mipi` decimal(7,2) DEFAULT NULL, 
  
  `pulmonary_comorbidity` char(1) DEFAULT '',
  `cardiac_comorbidity` char(1) DEFAULT '',
  `renal_comorbidity` char(1) DEFAULT '',
  `hepatic_comorbidity` char(1) DEFAULT '',
  `cns_comorbidity` char(1) DEFAULT '',
  `other_comorbidity` char(1) DEFAULT '',
  `comorbidities_precision` text,  
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_lymphomas');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_0_to_4', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("0","0"),("1","1"),("2","2"),("3","3"),("4","4");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_0_to_4"),  
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_nhl_stage_nbr', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("I","I"),("II","II"),("III","III"),("IV","IV");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="I" AND language_alias="I"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="II" AND language_alias="II"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="III" AND language_alias="III"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_nbr"),  
(SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV"), "4", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_nhl_stage_alpha', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("A","A"),("B","B"),("E","E");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_alpha"),  
(SELECT id FROM structure_permissible_values WHERE value="A" AND language_alias="A"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_alpha"),  
(SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="B"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_nhl_stage_alpha"),  
(SELECT id FROM structure_permissible_values WHERE value="E" AND language_alias="E"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'primary_hematologist', 'input', NULL , '0', 'size=15', '', '', 'primary hematologist', ''), 

('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_history_desc', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'baseline history desc', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_b_symptoms', 'yes_no',  NULL , '0', '', '', '', 'baseline b symptoms', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_b_desc', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'baseline b desc', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_ecog', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_0_to_4') , '0', '', '', '', 'baseline ecog', ''), 

('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'nhl_stage_nbr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_nbr') , '0', '', '', '', 'nhl stage', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'nhl_stage_alpha', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_alpha') , '0', '', '', '', '', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'cll_rai_stage', 'input',  NULL , '0', 'size=5', '', '', 'cll rai stage', ''),

('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'prognosis_mipi', 'float',  NULL , '0', 'size=5', '', '', 'prognosis mipi', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'prognosis_hd', 'float',  NULL , '0', 'size=5', '', '', 'prognosis hd', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'prognosis_flipi', 'float',  NULL , '0', 'size=5', '', '', 'prognosis flipi', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'prognosis_ipi', 'float',  NULL , '0', 'size=5', '', '', 'prognosis ipi', ''),

('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'pulmonary_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'pulmonary comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'cardiac_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'cardiac comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'renal_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'renal comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'hepatic_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'hepatic comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'cns_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'cns comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'other_comorbidity', 'yes_no',  NULL , '0', '', '', '', 'other comorbidity', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'comorbidities_precision', 'input',  NULL , '0', 'size=10', '', '', 'comorbidities precision', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='primary_hematologist' AND `flag_confidential`='0' AND `default`='' AND `language_help`='' AND `language_label`='primary hematologist' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 

((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_history_desc' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='baseline history desc' AND `language_tag`=''), '1', '30', 'baseline', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_b_symptoms' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline b symptoms' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_b_desc'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_ecog' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_0_to_4')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline ecog' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),

((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='nhl_stage_nbr' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_nbr')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nhl stage' AND `language_tag`=''), '2', '70', 'staging', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='nhl_stage_alpha' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_nhl_stage_alpha')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='cll_rai_stage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cll rai stage' AND `language_tag`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='prognosis_mipi' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis mipi' AND `language_tag`=''), '2', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='prognosis_hd' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis hd' AND `language_tag`=''), '2', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='prognosis_flipi' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis flipi' AND `language_tag`=''), '2', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='prognosis_ipi' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='prognosis ipi' AND `language_tag`=''), '2', '80', 'prognosis', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
  
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='pulmonary_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pulmonary comorbidity' AND `language_tag`=''), '1', '40', 'comorbidities', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='cardiac_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cardiac comorbidity' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='renal_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='renal comorbidity' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='hepatic_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hepatic comorbidity' AND `language_tag`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='cns_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cns comorbidity' AND `language_tag`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='other_comorbidity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other comorbidity' AND `language_tag`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='comorbidities_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='comorbidities precision' AND `language_tag`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'); 

UPDATE structure_fields SET  `setting`='size=30' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_lymphomas' AND field='primary_hematologist' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET display_column = 2, display_order = concat('1',display_order) WHERE structure_id = (SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field` LIKE '%comorbidi%');
UPDATE structure_fields SET  `setting`='size=30' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_lymphomas' AND field='comorbidities_precision' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO i18n (id,en) VALUES 
('primary hematologist' , 'Primary Hematologist'),

('baseline' , 'Baseline'),
('baseline history desc' , 'History'),
('baseline b symptoms' , 'B Symptoms'),
('baseline b desc' , 'B Symptoms Description'),
('baseline ecog' , 'ECOG'),

('nhl stage' , 'NHL'),
('I' , 'I'),
('II' , 'II'),
('III' , 'III'),
('IV' , 'IV'),
('A' , 'A'),
('B' , 'B'),
('E' , 'E'),
('cll rai stage' , 'CLL RAI'),

('prognosis' , 'Prognosis'),
('prognosis flipi' , 'FLIPI'),
('prognosis hd' , 'HD'),
('prognosis ipi' , 'IPI'),
('prognosis mipi' , 'MIPI'),

('comorbidities' , 'Comorbidities'),
('pulmonary comorbidity' , 'Pulmonary'),
('cardiac comorbidity' , 'Cardiac'),
('renal comorbidity' , 'Renal'),
('cns comorbidity' , 'Central Nervous System'),
('hepatic comorbidity' , 'Hepatic'),
('other comorbidity' , 'Other'),
('comorbidities precision' , 'Precision');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_b_desc' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field` LIKE '%comorbid%');

ALTER TABLE `ld_lymph_dx_lymphomas` 
  ADD `lymphoma_type` varchar(250) NOT NULL DEFAULT '' AFTER diagnosis_master_id;
ALTER TABLE `ld_lymph_dx_lymphomas_revs` 
  ADD `lymphoma_type` varchar(250) NOT NULL DEFAULT '' AFTER diagnosis_master_id;
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_lymphoma_type_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''lymphoma types'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('lymphoma types', '1', '250');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'lymphoma_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_lymphoma_type_list') , '0', '', '', '', 'lymphoma type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='lymphoma_type'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'); 
INSERT IGNORE INTO i18n (id,en) VALUES ('lymphoma type','Type');

-- Lymphoma progression

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'progression', 'ld lymph progression', 1, 'diagnosismasters,ld_lymph_dx_progression', 'dxd_progressions', 1, 'progression', 0);

ALTER TABLE dxd_progressions
  ADD `ld_lymph_trt_at_progression` text AFTER diagnosis_master_id;
ALTER TABLE dxd_progressions_revs
  ADD `ld_lymph_trt_at_progression` text AFTER diagnosis_master_id; 

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_progression');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'dxd_progressions', 'ld_lymph_trt_at_progression', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'trt at progression', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progression'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_progressions' AND `field`='ld_lymph_trt_at_progression' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='trt at progression' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('ld lymph progression','Lymphoma Progression'),
('trt at progression','Treatment at Progression'),
('site', 'Site');

UPDATE structure_formats SET display_column =2, display_order = 102 
WHERE structure_id = (SELECT id FROM structures WHERE alias='ld_lymph_dx_progression')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_progressions' AND `field`='ld_lymph_trt_at_progression');

ALTER TABLE dxd_progressions
  ADD `ld_lymph_progression_site` varchar(100) DEFAULT '' AFTER ld_lymph_trt_at_progression,
  ADD `ld_lymph_progression_site_desc` text AFTER ld_lymph_progression_site;
ALTER TABLE dxd_progressions_revs
  ADD `ld_lymph_progression_site` varchar(100) DEFAULT '' AFTER ld_lymph_trt_at_progression,
  ADD `ld_lymph_progression_site_desc` text AFTER ld_lymph_progression_site;
 
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_lymphoma_progression_sites', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''lymphoma progression sites'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('lymphoma progression sites', '1', '100');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'dxd_progressions', 'ld_lymph_progression_site', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'custom_lymphoma_progression_sites') , '0', '', '', '', 'site', ''),
('Clinicalannotation', 'DiagnosisDetail', 'dxd_progressions', 'ld_lymph_progression_site_desc', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'site precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progression'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_progressions' AND `field`='ld_lymph_progression_site'), '2', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progression'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_progressions' AND `field`='ld_lymph_progression_site_desc'), '2', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES ('site precision', 'Site Precision');

-- CNS Relapse

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'progression', 'cns relapse', 1, 'diagnosismasters', 'dxd_progressions', 1, 'cns relapse', 0);

INSERT IGNORE INTO i18n (id,en) VALUES ('cns relapse','CNS Relapse');

-- Histo Transformation

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'progression', 'histological transformation', 1, 'diagnosismasters,ld_lymph_dx_histological_transformation', 'ld_lymph_dxd_histo_transformations', 1, 'progression|histological transformation', 0);

DROP TABLE IF EXISTS `ld_lymph_dxd_histo_transformations`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dxd_histo_transformations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL,
  
  `type_of_transformation` varchar(20) DEFAULT '',
  `hyper_ca2plus` char(1) DEFAULT '',
  `hyper_ca2plus_value` decimal(7,2) DEFAULT NULL,  
  `unusual_site` char(1) DEFAULT '',
  `unusual_site_value` varchar(20) DEFAULT '',
  `ldh_increased_more_than_2xlimit` char(1) DEFAULT '',
  `ldh_value` decimal(7,2) DEFAULT NULL,  
  `discordant_nodal_growth` char(1) DEFAULT '',  
  `new_b_symptoms` text,
  `path_date` date DEFAULT NULL,
   
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_dxd_histo_transformations`
  ADD CONSTRAINT `FK_ld_lymph_dxd_histo_transformations_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_dxd_histo_transformations_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dxd_histo_transformations_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  
  `type_of_transformation` varchar(20) DEFAULT '',
  `hyper_ca2plus` char(1) DEFAULT '',
  `hyper_ca2plus_value` decimal(7,2) DEFAULT NULL,  
  `unusual_site` char(1) DEFAULT '',
  `unusual_site_value` varchar(20) DEFAULT '',
  `ldh_increased_more_than_2xlimit` char(1) DEFAULT '',
  `ldh_value` decimal(7,2) DEFAULT NULL,  
  `discordant_nodal_growth` char(1) DEFAULT '',  
  `new_b_symptoms` text,  
  `path_date` date DEFAULT NULL,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_histological_transformation');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_dx_histo_transf_definition_source', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("clinical","clinical"),("patho","patho");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_definition_source"),  
(SELECT id FROM structure_permissible_values WHERE value="clinical" AND language_alias="clinical"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_definition_source"),  
(SELECT id FROM structure_permissible_values WHERE value="patho" AND language_alias="patho"), "2", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_dx_histo_transf_unusual_site', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("liver","liver"),("bone","bone"),("ms","unusual site ms"),("cns","unusual site cns");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="liver" AND language_alias="liver"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="bone" AND language_alias="bone"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="ms" AND language_alias="unusual site ms"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="cns" AND language_alias="unusual site cns"), "5", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'type_of_transformation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_definition_source') , '0', '', '', '', 'type of transformation', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'hyper_ca2plus', 'yes_no',  NULL , '0', '', '', '', 'hyper ca2plus', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'hyper_ca2plus_value', 'float',  NULL , '0', '', '', '', 'hyper ca2plus value', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'unusual_site', 'yes_no',  NULL , '0', '', '', '', 'unusual site', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'unusual_site_value', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_unusual_site') , '0', '', '', '', 'unusual site value', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'ldh_increased_more_than_2xlimit', 'yes_no',  NULL , '0', '', '', '', 'ldh increased more than 2xlimit', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'ldh_value', 'float',  NULL , '0', '', '', '', 'ldh value', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'discordant_nodal_growth', 'yes_no',  NULL , '0', '', '', '', 'discordant nodal growth', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'new_b_symptoms', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'new b symptoms', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'path_date', 'date',  NULL , '0', '', '', '', 'path date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='type_of_transformation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_definition_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of transformation' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='hyper_ca2plus' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hyper ca2plus' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='hyper_ca2plus_value' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hyper ca2plus value' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='unusual_site' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unusual site' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='unusual_site_value' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_unusual_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unusual site value' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='ldh_increased_more_than_2xlimit' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ldh increased more than 2xlimit' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='ldh_value' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ldh value' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='discordant_nodal_growth' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='discordant nodal growth' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='new_b_symptoms'), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='path_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path date' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) 
VALUES
('discordant nodal growth', 'Discordant Nodal Growth'),
('group', 'Group'),
('hyper ca2plus', 'Hyper Ca<sup>2+</sup>'),
('hyper ca2plus value', 'Ca<sup>2+</sup> Value'),
('ld lymph. cns relapse', 'LD Lymph. CNS Relapse'),
('ld lymph. histological transformation', 'LD Lymph. Histological Transformation'),
('ldh increased more than 2xlimit', 'Increased LDH > 2 x Limit'),
('ldh value', 'LDH Value'),
('new b symptoms', 'New B Symptoms'),
('path date', 'Path Date'),
('patho', 'Patho'),
('type of transformation', 'Transformation Defined'),
('unusual site', 'Unusual Site'),
('unusual site cns', 'CNS'),
('unusual site ms', 'MS'),
('unusual site value', 'Site Value'),
('histological transformation','Histological Transformation'),
('values','Values');

UPDATE structure_fields SET  `language_label`='',  `language_tag`='hyper ca2plus value' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dxd_histo_transformations' AND field='hyper_ca2plus_value' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_unusual_site') ,  `language_label`='',  `language_tag`='unusual site value' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dxd_histo_transformations' AND field='unusual_site_value' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_unusual_site');
UPDATE structure_formats SET `language_heading`='values' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='hyper_ca2plus' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='',  `language_tag`='ldh value' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dxd_histo_transformations' AND field='ldh_value' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='new_b_symptoms' );

ALTER TABLE ld_lymph_dxd_histo_transformations
  ADD path_nbr varchar(100) DEFAULT '' AFTER new_b_symptoms;
ALTER TABLE ld_lymph_dxd_histo_transformations_revs
  ADD path_nbr varchar(100) DEFAULT '' AFTER new_b_symptoms;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dxd_histo_transformations', 'path_nbr', 'input',  NULL , '0', 'size=20', '', '', 'path nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='path_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='path nbr' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='path_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) VALUES ('path nbr','Path #');

-- EVENT ----------------------------------------------------------------------------------

UPDATE menus
SET flag_active = '0'
WHERE use_link LIKE '%event_masters%' AND language_title NOT IN ('lab', 'clinical', 'annotation', 'clin_study');

-- labs

UPDATE event_controls SET flag_active = 0;
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'lab', 'labs', 1, 'ld_lymph_ed_labs', 'ld_lymph_ed_labs', 0, 'lab|ld lymph.|labs');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,

  `hb_g_per_l` decimal(7,2) DEFAULT null,  
  `ptl_10x9_per_l` decimal(7,2) DEFAULT null,  
  `wbcs_10x9_per_l` decimal(7,2) DEFAULT null,  
  `lymph_10x9_per_l` decimal(7,2) DEFAULT null,  
  `ca2plus` decimal(7,2) DEFAULT null,  
  `albumin_g_per_l` decimal(7,2) DEFAULT null,  
  `beta_2_m` decimal(7,2) DEFAULT null,   
  `ldh` decimal(7,2) DEFAULT null,   
  `ldh_upper_normal` decimal(7,2) DEFAULT null,  
   
  `spep` varchar(20) DEFAULT '',
  `hiv` varchar(20) DEFAULT '',
  `hbs_ag` varchar(20) DEFAULT '',
  `hb_core_ab` varchar(20) DEFAULT '',
  `hcv_ab` varchar(20) DEFAULT '',
  
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_ed_labs`
  ADD CONSTRAINT `FK_ld_lymph_ed_labs_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_labs_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `hb_g_per_l` decimal(7,2) DEFAULT null,  
  `ptl_10x9_per_l` decimal(7,2) DEFAULT null,  
  `wbcs_10x9_per_l` decimal(7,2) DEFAULT null,  
  `lymph_10x9_per_l` decimal(7,2) DEFAULT null,  
  `ca2plus` decimal(7,2) DEFAULT null,  
  `albumin_g_per_l` decimal(7,2) DEFAULT null,  
  `beta_2_m` decimal(7,2) DEFAULT null,   
  `ldh` decimal(7,2) DEFAULT null,   
  `ldh_upper_normal` decimal(7,2) DEFAULT null,  
   
  `spep` varchar(20) DEFAULT '',
  `hiv` varchar(20) DEFAULT '',
  `hbs_ag` varchar(20) DEFAULT '',
  `hb_core_ab` varchar(20) DEFAULT '',
  `hcv_ab` varchar(20) DEFAULT '',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_labs');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_labs_test_values', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("negative","negative"),("positive","positive"),("not performed","not performed");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="not performed" AND language_alias="not performed"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'hb_g_per_l', 'float',  NULL , '0', 'size=5', '', '', 'hb g per l', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'ptl_10x9_per_l', 'float',  NULL , '0', 'size=5', '', '', 'ptl 10x9 per l', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'wbcs_10x9_per_l', 'float',  NULL , '0', 'size=5', '', '', 'wbcs 10x9 per l', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'lymph_10x9_per_l', 'float',  NULL , '0', 'size=5', '', '', 'lymph 10x9 per l', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'ca2plus', 'float',  NULL , '0', 'size=5', '', '', 'ca2plus', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'albumin_g_per_l', 'float',  NULL , '0', 'size=5', '', '', 'albumin g per l', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'beta_2_m', 'float',  NULL , '0', 'size=5', '', '', 'beta 2 m', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'ldh', 'float',  NULL , '0', 'size=5', '', '', 'ldh', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'ldh_upper_normal', 'float',  NULL , '0', 'size=5', '', '', 'ldh upper normal', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'spep', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'spep', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'hiv', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'hiv', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'hbs_ag', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'hbs ag', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'hb_core_ab', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'hb core ab', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_labs', 'hcv_ab', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'hcv ab', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='hb_g_per_l' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='hb g per l' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='ptl_10x9_per_l' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ptl 10x9 per l' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='wbcs_10x9_per_l' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='wbcs 10x9 per l' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='lymph_10x9_per_l' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='lymph 10x9 per l' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='ca2plus' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ca2plus' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='albumin_g_per_l' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='albumin g per l' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='beta_2_m' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='beta 2 m' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='ldh' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ldh' AND `language_tag`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='ldh_upper_normal' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ldh upper normal' AND `language_tag`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='spep' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='spep' AND `language_tag`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='hiv' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hiv' AND `language_tag`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='hbs_ag' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hbs ag' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='hb_core_ab' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hb core ab' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `field`='hcv_ab' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hcv ab' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('albumin g per l','Albumin (g/l)'),
('beta 2 m','&#946;2M'),
('ca2plus','Ca<sup>2+</sup>'),
('hb core ab','HB core Ab'),
('hb g per l','Hb (g/l)'),
('hbs ag','HBs Ag'),
('hcv ab','HCV Ab'),
('hiv','HIV'),
('labs','Labs'),
('ldh','LDH'),
('ldh upper normal','LDH upper normal'),
('lymph 10x9 per l','Lymph (x10&#8313;/L)'),
('ptl 10x9 per l','Ptl (x10&#8313;/L)'),
('spep','SPEP'),
('wbcs 10x9 per l','WBCs (x10&#8313;/L)');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("hidden","hidden");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="hidden" AND language_alias="hidden"), "4", "1");

INSERT IGNORE INTO i18n (id,en) VALUES 
('hidden','Hidden');

UPDATE structure_formats 
SET `display_column`='3' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_labs') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_labs' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values'));

-- P/E and imaging

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'p/e and imaging', 1, 'ld_lymph_ed_imagings', 'ld_lymph_ed_imagings', 0, 'clinical|ld lymph.|p/e and imaging');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_imagings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  
  `nodules_nbr` int(4) DEFAULT null,  
  `largest_tumor_diam_cm` decimal(7,2) DEFAULT null,  
  `nbr_of_extranodal_sites` int(4) DEFAULT null,  
  `extranodal_sites_list` text,    
  `imaging_type` varchar(10) DEFAULT null,   
  `imaging_type_other` varchar(50) DEFAULT null,   
  `initial_pet_suv_max` int(4) DEFAULT null,    
  
  `pe_imag_lymph_node_waldeyers_ring` char(1) DEFAULT '',  
  
  `pe_imag_lymph_node_pre_auricular_left` char(1) DEFAULT '', 
  `pe_imag_lymph_node_pre_auricular_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_upper_cervical_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_upper_cervical_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_median_lower_cervical_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_median_lower_cervical_right` char(1) DEFAULT '',   
  `pe_imag_lymph_node_posterior_cervical_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_posterior_cervical_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_supraclavicular_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_supraclavicular_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_infraclavicular_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_infraclavicular_right` char(1) DEFAULT '',  
  
  `pe_imag_lymph_node_paratracheal_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_paratracheal_right` char(1) DEFAULT '',  
  `pe_imag_lymph_node_mediastinal` char(1) DEFAULT '',    
  `pe_imag_lymph_node_hilar_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_hilar_right` char(1) DEFAULT '',  
  `pe_imag_lymph_node_retrocrural` char(1) DEFAULT '',  
    
  `pe_imag_lymph_node_axillary_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_axillary_right` char(1) DEFAULT '',  
      
  `pe_imag_lymph_node_spleen` char(1) DEFAULT '',      

  `pe_imag_lymph_node_ceuac` char(1) DEFAULT '',   
  `pe_imag_lymph_node_splenic_hepatic_hilar` char(1) DEFAULT '',    
  `pe_imag_lymph_node_portal` char(1) DEFAULT '',  
  `pe_imag_lymph_node_mesenteric` char(1) DEFAULT '', 
           
  `pe_imag_lymph_node_para_aortic_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_para_aortic_right` char(1) DEFAULT '', 
  `pe_imag_lymph_node_common_illiac_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_common_illiac_right` char(1) DEFAULT '',        
  `pe_imag_lymph_node_external_illiac_left` char(1) DEFAULT '',      
  `pe_imag_lymph_node_external_illiac_right` char(1) DEFAULT '',  
  
  `pe_imag_lymph_node_inguinal_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_inguinal_right` char(1) DEFAULT '',
  `pe_imag_lymph_node_femoral_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_femoral_right` char(1) DEFAULT '',
   
  `pe_imag_lymph_node_epitrochlear` char(1) DEFAULT '',    
  `pe_imag_lymph_node_popliteral` char(1) DEFAULT '',    

  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_ed_imagings`
  ADD CONSTRAINT `FK_ld_lymph_ed_imagings_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_imagings_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `nodules_nbr` int(4) DEFAULT null,  
  `largest_tumor_diam_cm` decimal(7,2) DEFAULT null,  
  `nbr_of_extranodal_sites` int(4) DEFAULT null,  
  `extranodal_sites_list` text,    
  `imaging_type` varchar(10) DEFAULT null,   
  `imaging_type_other` varchar(50) DEFAULT null, 
  `initial_pet_suv_max` int(4) DEFAULT null,    
  
  `pe_imag_lymph_node_waldeyers_ring` char(1) DEFAULT '',  
  
  `pe_imag_lymph_node_pre_auricular_left` char(1) DEFAULT '', 
  `pe_imag_lymph_node_pre_auricular_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_upper_cervical_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_upper_cervical_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_median_lower_cervical_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_median_lower_cervical_right` char(1) DEFAULT '',   
  `pe_imag_lymph_node_posterior_cervical_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_posterior_cervical_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_supraclavicular_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_supraclavicular_right` char(1) DEFAULT '',    
  `pe_imag_lymph_node_infraclavicular_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_infraclavicular_right` char(1) DEFAULT '',  
  
  `pe_imag_lymph_node_paratracheal_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_paratracheal_right` char(1) DEFAULT '',  
  `pe_imag_lymph_node_mediastinal` char(1) DEFAULT '',    
  `pe_imag_lymph_node_hilar_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_hilar_right` char(1) DEFAULT '',  
  `pe_imag_lymph_node_retrocrural` char(1) DEFAULT '',  
    
  `pe_imag_lymph_node_axillary_left` char(1) DEFAULT '',   
  `pe_imag_lymph_node_axillary_right` char(1) DEFAULT '',  
      
  `pe_imag_lymph_node_spleen` char(1) DEFAULT '',      

  `pe_imag_lymph_node_ceuac` char(1) DEFAULT '',   
  `pe_imag_lymph_node_splenic_hepatic_hilar` char(1) DEFAULT '',    
  `pe_imag_lymph_node_portal` char(1) DEFAULT '',  
  `pe_imag_lymph_node_mesenteric` char(1) DEFAULT '', 
           
  `pe_imag_lymph_node_para_aortic_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_para_aortic_right` char(1) DEFAULT '', 
  `pe_imag_lymph_node_common_illiac_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_common_illiac_right` char(1) DEFAULT '',        
  `pe_imag_lymph_node_external_illiac_left` char(1) DEFAULT '',      
  `pe_imag_lymph_node_external_illiac_right` char(1) DEFAULT '',  
  
  `pe_imag_lymph_node_inguinal_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_inguinal_right` char(1) DEFAULT '',
  `pe_imag_lymph_node_femoral_left` char(1) DEFAULT '',        
  `pe_imag_lymph_node_femoral_right` char(1) DEFAULT '',
   
  `pe_imag_lymph_node_epitrochlear` char(1) DEFAULT '',    
  `pe_imag_lymph_node_popliteral` char(1) DEFAULT '',  
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_imagings');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_imaging_type', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("CT","CT"),("PET","PET"),("US","US"),("CXR","CXR"),("other","other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="CT" AND language_alias="CT"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="PET" AND language_alias="PET"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="US" AND language_alias="US"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="CXR" AND language_alias="CXR"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_imaging_type"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "5", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'nodules_nbr', 'integer',  NULL , '0', 'size=3', '', '', 'nbr of nodules', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'largest_tumor_diam_cm', 'float',  NULL , '0', 'size=3', '', '', 'largest tumor diam cm', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'extranodal_sites_list', 'textarea',  NULL , '0', 'rows=2,cols=30', '', '', 'extranodal sites list', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'imaging_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_imaging_type') , '0', '', '', '', 'imaging type', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'imaging_type_other', 'input',  NULL , '0', 'size=10', '', '', 'imaging type other', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'initial_pet_suv_max', 'float',  NULL , '0', 'size=3', '', '', 'initial pet suv max', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='nodules_nbr' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='nbr of nodules' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='largest_tumor_diam_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='largest tumor diam cm' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='extranodal_sites_list' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='extranodal sites list' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_imaging_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='imaging type' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='imaging type other' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='initial_pet_suv_max' ), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_waldeyers_ring', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node waldeyers ring', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_pre_auricular_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node pre auricular', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_pre_auricular_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_upper_cervical_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node upper cervical', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_upper_cervical_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_median_lower_cervical_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node median lower cervical', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_median_lower_cervical_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_posterior_cervical_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node posterior cervical', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_posterior_cervical_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_supraclavicular_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node supraclavicular', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_supraclavicular_right', 'yes_no',  NULL , '0', '', '', '', ' ', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_infraclavicular_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node infraclavicular', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_infraclavicular_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_paratracheal_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node paratracheal', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_paratracheal_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_mediastinal', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node mediastinal', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_hilar_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node hilar', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_hilar_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_retrocrural', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node retrocrural', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_axillary_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node axillary', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_axillary_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_spleen', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node spleen', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_ceuac', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node ceuac', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_splenic_hepatic_hilar', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node splenic hepatic hilar', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_portal', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node portal', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_mesenteric', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node mesenteric', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_para_aortic_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node para aortic', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_para_aortic_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_common_illiac_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node common illiac', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_common_illiac_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_external_illiac_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node external illiac', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_external_illiac_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_inguinal_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node inguinal', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_inguinal_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_femoral_left', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node femoral', 'left'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_femoral_right', 'yes_no',  NULL , '0', '', '', '', '', 'right'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_epitrochlear', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node epitrochlear', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_popliteral', 'yes_no',  NULL , '0', '', '', '', 'pe imag lymph node popliteral', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_waldeyers_ring'), '2', '50', 'waldeyers ring', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_pre_auricular_left'), '2', '51', 'cervical', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_pre_auricular_right'), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_upper_cervical_left'), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_upper_cervical_right'), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_median_lower_cervical_left'), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_median_lower_cervical_right'), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_posterior_cervical_left'), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_posterior_cervical_right'), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_supraclavicular_left'), '2', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_supraclavicular_right'), '2', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_infraclavicular_left'), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_infraclavicular_right'), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_paratracheal_left'), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_paratracheal_right'), '2', '64', 'mediastinal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_mediastinal'), '2', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_hilar_left'), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_hilar_right'), '2', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_retrocrural'), '2', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_axillary_left'), '2', '69', 'axillary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_axillary_right'), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_spleen'), '2', '71', 'spleen', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_ceuac'), '2', '72', 'mesenteric', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_splenic_hepatic_hilar'), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_portal'), '2', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_mesenteric'), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_para_aortic_left'), '2', '76', 'para aortic', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_para_aortic_right'), '2', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_common_illiac_left'), '2', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_common_illiac_right'), '2', '79', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_external_illiac_left'), '2', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_external_illiac_right'), '2', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_inguinal_left'), '2', '82', 'inguinal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_inguinal_right'), '2', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_femoral_left'), '2', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_femoral_right'), '2', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_epitrochlear'), '2', '86', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_popliteral'), '2', '87', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('CT' ,'CT'),
('CXR' ,'CXR'),
('extranodal sites list' ,'Extranodal Sites List'),
('imaging type' ,'Imaging Type'),
('imaging type other' ,'Other precision'),
('initial pet suv max' ,'Initial PET SUV: max'),
('largest tumor diam cm' ,'Largest Tumor diameter (cm)'),
('ld lymph.' ,'LD Lymph.'),
('lymph node axillary left' ,'Axillary - Left'),
('lymph node axillary right' ,'Axillary - Right'),
('lymph node cervical left' ,'Cervical - Left'),
('lymph node cervical right' ,'Cervical - Right'),
('lymph node inguinal left' ,'Inguinal - Left'),
('lymph node inguinal right' ,'Inguinal - Right'),
('lymph node mediastinal' ,'Mediastinal'),
('lymph node mesenteric' ,'Mesenteric'),
('lymph node other' ,'Other'),
('lymph node para aortic left' ,'Para Aortic - Left'),
('lymph node para aortic right' ,'Para Aortic - Right'),
('lymph node spleen' ,'Spleen'),
('lymph node waldeyers ring' ,'Waldeyer''s Ring'),
('lymph node score','Lymph Node Score'),
('nbr of nodules' ,'Nbr of Nodules'),
('p/e and imaging' ,'P/E and Imaging'),
('PET' ,'PET'),
('progression' ,'Progression'),
('US' ,'US');

UPDATE structure_formats 
SET `display_column`='3' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') 
AND `display_column`='2';

UPDATE structure_formats 
SET `display_column`='2' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') 
AND `display_column`='1' 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings');

UPDATE structure_fields SET  `setting`='size=20',  `language_label`='',  `language_tag`='imaging type other' WHERE model='EventDetail' AND tablename='ld_lymph_ed_imagings' AND field='imaging_type_other' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'nbr_of_extranodal_sites', 'integer',  NULL , '0', 'size=3', '', '', 'nbr of extranodal sites', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='nbr_of_extranodal_sites' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='nbr of extranodal sites' AND `language_tag`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES ('nbr of extranodal sites','Number of Extranodal Sites');

UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='nbr_of_extranodal_sites');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='extranodal_sites_list');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_imaging_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1' WHERE  structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND `display_column`='2' ;

ALTER TABLE `ld_lymph_ed_imagings`
  ADD scan_nbr varchar(100) DEFAULT '' AFTER event_master_id;
ALTER TABLE `ld_lymph_ed_imagings_revs`
  ADD scan_nbr varchar(100) DEFAULT '' AFTER event_master_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'scan_nbr', 'input',  NULL , '0', 'size=20', '', '', 'scan nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='scan_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='scan nbr' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'); 

INSERT INTO i18n (id,en) VALUES ('scan nbr', 'Scan #');

-- biopsy

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'biopsy', 1, 'ld_lymph_ed_biopsies,ld_lymph_ed_patho_summary', 'ld_lymph_ed_biopsies', 0, 'clinical|ld lymph.|biopsy');

INSERT IGNORE INTO i18n (id,en) VALUES ('biopsy' , 'Biopsy');

DROP TABLE IF EXISTS `ld_lymph_ed_biopsies`;
DROP TABLE IF EXISTS `ld_lymph_ed_biopsies_revs`;

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_biopsies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,

  `site` varchar(50) DEFAULT '',
  `surgery_nbr` varchar(50) DEFAULT '',
  `ref_center` varchar(50) DEFAULT '',
  `biopsy_reviewer` varchar(50) DEFAULT '',
  `hitological_dx` text,
  `who_class` varchar(50) DEFAULT '',
  `other_investigations` text, 
  
  `immuno_mum1` varchar(50) DEFAULT '',	
  `immuno_date` date DEFAULT null,
  `immuno_cd10` varchar(50) DEFAULT '',	
  `immuno_bcl2_pr` varchar(50) DEFAULT '',	
  `immuno_bcl6_pr` varchar(50) DEFAULT '',	
  `immuno_pheno_b_t` varchar(20) DEFAULT '',
  `immuno_ki67_percent` decimal(5,2) DEFAULT null,
  `immuno_cd68` varchar(50) DEFAULT '',	
  `immuno_notes` text,	
  
  `cytomet_flow_number` varchar(250) DEFAULT '',
  `cytomet_date` date DEFAULT null,
  `cytomet_center` varchar(250) DEFAULT '',
  `cytomet_cd20` varchar(50) DEFAULT '',		
  `cytomet_cd19` varchar(50) DEFAULT '',	
  `cytomet_cd10` varchar(50) DEFAULT '',	
  `cytomet_cd5` varchar(50) DEFAULT '',	
  `cytomet_cd23` varchar(50) DEFAULT '',	
  `cytomet_cd2` varchar(50) DEFAULT '',	
  `cytomet_cd3` varchar(50) DEFAULT '',	
  `cytomet_cd4` varchar(50) DEFAULT '',	
  `cytomet_cd8` varchar(50) DEFAULT '',	
  `cytomet_lambda` varchar(50) DEFAULT '',	
  `cytomet_kappa` varchar(50) DEFAULT '',	
  `cytomet_other_title` varchar(100) DEFAULT '',		
  `cytomet_other_value` varchar(50) DEFAULT '',	  
  
  `molecular_date` date DEFAULT null,
  `molecular_center` varchar(250) DEFAULT '',
  `molecular_mdl_number` decimal(7,5) DEFAULT NULL,	
  `molecular_mb_number` decimal(7,5) DEFAULT NULL,	
  `molecular_molecular_dx` text,	  
   
  `cytogen_case_number` varchar(250) DEFAULT '',	
  `cytogen_cyto_number` varchar(250) DEFAULT '',
  `cytogen_date`date DEFAULT null,
  `cytogen_technique` varchar(100) DEFAULT '',	
  `cytogen_technique_precision` varchar(250) DEFAULT '',
  `cytogen_bcl2_tr` varchar(50) DEFAULT '',		
  `cytogen_bcl6_tr` varchar(50) DEFAULT '',	
  `cytogen_myc_tr` varchar(50) DEFAULT '',	
  `cytogen_cyclin_d1_tr` varchar(50) DEFAULT '',	
  `cytogen_karyotype` varchar(250) DEFAULT '',		  
  
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;  

ALTER TABLE `ld_lymph_ed_biopsies`
  ADD CONSTRAINT `FK_ld_lymph_ed_biopsies_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_biopsies_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `site` varchar(50) DEFAULT '',
  `surgery_nbr` varchar(50) DEFAULT '',
  `ref_center` varchar(50) DEFAULT '',
  `biopsy_reviewer` varchar(50) DEFAULT '',
  `hitological_dx` text,
  `who_class` varchar(50) DEFAULT '',
  `other_investigations` text, 
  
  `immuno_mum1` varchar(50) DEFAULT '',	
  `immuno_date` date DEFAULT null,
  `immuno_cd10` varchar(50) DEFAULT '',	
  `immuno_bcl2_pr` varchar(50) DEFAULT '',	
  `immuno_bcl6_pr` varchar(50) DEFAULT '',	
  `immuno_pheno_b_t` varchar(20) DEFAULT '',
  `immuno_ki67_percent` decimal(5,2) DEFAULT null,
  `immuno_cd68` varchar(50) DEFAULT '',	
  `immuno_notes` text,	
  
  `cytomet_flow_number` varchar(250) DEFAULT '',
  `cytomet_date` date DEFAULT null,
  `cytomet_center` varchar(250) DEFAULT '',
  `cytomet_cd20` varchar(50) DEFAULT '',		
  `cytomet_cd19` varchar(50) DEFAULT '',	
  `cytomet_cd10` varchar(50) DEFAULT '',	
  `cytomet_cd5` varchar(50) DEFAULT '',	
  `cytomet_cd23` varchar(50) DEFAULT '',	
  `cytomet_cd2` varchar(50) DEFAULT '',	
  `cytomet_cd3` varchar(50) DEFAULT '',	
  `cytomet_cd4` varchar(50) DEFAULT '',	
  `cytomet_cd8` varchar(50) DEFAULT '',	
  `cytomet_lambda` varchar(50) DEFAULT '',	
  `cytomet_kappa` varchar(50) DEFAULT '',	
  `cytomet_other_title` varchar(100) DEFAULT '',		
  `cytomet_other_value` varchar(50) DEFAULT '',	  
  
  `molecular_date` date DEFAULT null,
  `molecular_center` varchar(250) DEFAULT '',
  `molecular_mdl_number` decimal(7,5) DEFAULT NULL,	
  `molecular_mb_number` decimal(7,5) DEFAULT NULL,	
  `molecular_molecular_dx` text,	  
   
  `cytogen_case_number` varchar(250) DEFAULT '',	
  `cytogen_cyto_number` varchar(250) DEFAULT '',
  `cytogen_date`date DEFAULT null,
  `cytogen_technique` varchar(100) DEFAULT '',	
  `cytogen_technique_precision` varchar(250) DEFAULT '',
  `cytogen_bcl2_tr` varchar(50) DEFAULT '',		
  `cytogen_bcl6_tr` varchar(50) DEFAULT '',	
  `cytogen_myc_tr` varchar(50) DEFAULT '',	
  `cytogen_cyclin_d1_tr` varchar(50) DEFAULT '',	
  `cytogen_karyotype` varchar(250) DEFAULT '',	
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_biopsies');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'site', 'input', NULL, '0', 'size=20', '', '', 'site', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'surgery_nbr', 'input', NULL, '0', 'size=20', '', '', 'surgery nbr', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'ref_center', 'input', NULL, '0', 'size=20', '', '', 'ref center', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'biopsy_reviewer', 'input', NULL, '0', 'size=20', '', '', 'biopsy reviewer', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'hitological_dx', 'textarea', NULL, '0', 'rows=3,cols=20', '', '', 'hitological dx', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'who_class',  'autocomplete', NULL, '0', 'size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho', '', '', 'who class', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'other_investigations', 'textarea', NULL, '0', 'rows=3,cols=20', '', '', 'other investigations', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', 'biopsy', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='site'), 
'1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='surgery_nbr'), 
'1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='ref_center'), 
'1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='biopsy_reviewer'), 
'1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='hitological_dx'), 
'1', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='who_class'), 
'1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='other_investigations'), 
'1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('surgery nbr' , 'Surg#'),
('ref center' , 'Ref Center'),
('biopsy reviewer' , 'Path reviewed by MD'),
('other investigations' , 'Other Investigations');

ALTER TABLE `ld_lymph_ed_biopsies`
  ADD path_nbr varchar(100) DEFAULT '' AFTER surgery_nbr;
ALTER TABLE `ld_lymph_ed_biopsies_revs`
  ADD path_nbr varchar(100) DEFAULT '' AFTER surgery_nbr;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'path_nbr', 'input',  NULL , '0', 'size=20', '', '', 'path nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='path_nbr'), '1', '52', 'pathology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'); 

UPDATE structure_formats SET `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='path_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='surgery_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='49' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

--

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_patho_summary');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_pheno_b_vs_t', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("B","pheno_b"),("T","pheno_t");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pheno_b_vs_t"),  
(SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="pheno_b"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pheno_b_vs_t"),  
(SELECT id FROM structure_permissible_values WHERE value="T" AND language_alias="pheno_t"), "2", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_cytogenetic_technique', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("FISH","FISH");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_cytogenetic_technique"),  
(SELECT id FROM structure_permissible_values WHERE value="FISH" AND language_alias="FISH"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_cytogenetic_technique"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

INSERT IGNORE INTO i18n (id,en) VALUES 
("pheno_b","B"), 
("pheno_t","T");

--

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_mum1', 'input', NULL, '0', 'size=20', '', '', 'immuno mum1', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_date', 'date', NULL, '0', '', '', '', 'date', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_cd10', 'float', NULL, '0', 'size=3', '', '', 'immuno cd10', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_bcl2_pr', 'float', NULL, '0', 'size=3', '', '', 'immuno bcl2 pr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_bcl6_pr', 'float', NULL, '0', 'size=3', '', '', 'immuno bcl6 pr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_pheno_b_t', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_pheno_b_vs_t') , '0', '', '', '', 'immuno pheno b t', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_ki67_percent', 'float', NULL, '0', 'size=3', '', '', 'immuno ki67 percent', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_cd68', 'float', NULL, '0', 'size=3', '', '', 'immuno cd68', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'immuno_notes', 'textarea', NULL, '0', 'rows=3,cols=30', '', '', 'immuno notes', ''); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_mum1'), 
'2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_date'), 
'2', '100', 'immunohistochemistry', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_cd10'), 
'2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_bcl2_pr'), 
'2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_bcl6_pr'), 
'2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_pheno_b_t'), 
'2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_ki67_percent'), 
'2', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_cd68'), 
'2', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='immuno_notes'), 
'2', '108', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('immuno mum1','NUM1'),
('immuno cd10','CD10'),
('immuno bcl2 pr','BCL2 PR'),
('immuno bcl6 pr','BCL6 PR'),
('immuno pheno b t','Pheno (B vs T)'),
('immuno ki67 percent','KI67 (%)'),
('immuno cd68','CD68'),
('immuno notes','Notes');

--

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_flow_number', 'input', NULL, '0', 'size=20', '', '', 'cytomet flow number', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_date', 'date', NULL, '0', '', '', '', 'date', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_center', 'input', NULL, '0', 'size=20', '', '', 'cytomet center', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd20', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd20', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd19', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd19', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd10', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd10', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd5', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd5', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd23', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd23', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd2', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd2', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd3', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd3', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd4', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd4', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_cd8', 'float', NULL, '0', 'size=3', '', '', 'cytomet cd8', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_lambda', 'float', NULL, '0', 'size=3', '', '', 'cytomet lambda', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_kappa', 'float', NULL, '0', 'size=3', '', '', 'cytomet kappa', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_other_title', 'input', NULL, '0', 'size=20', '', '', 'other', ''),  
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytomet_other_value', 'input', NULL, '0', 'size=20', '', '', '', ':');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_flow_number'), 
'2', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_date'), 
'2', '200', 'flow cytometry lab', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_center'), 
'2', '202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd20'), 
'2', '203', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd19'), 
'2', '204', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd10'), 
'2', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd5'), 
'2', '206', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd23'), 
'2', '207', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd2'), 
'2', '208', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd3'), 
'2', '209', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd4'), 
'2', '210', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_cd8'), 
'2', '211', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_lambda'), 
'2', '212', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_kappa'), 
'2', '213', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_other_title'), 
'2', '214', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytomet_other_value'), 
'2', '215', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('cytomet cd20', 'CD20'),
('cytomet cd5', 'CD5'),
('cytomet cd23', 'CD23'),
('cytomet cd2', 'CD2'),
('cytomet cd3', 'CD3'),
('cytomet cd4', 'CD4'),
('cytomet cd8', 'CD8'),
('cytomet lambda', '&#955;'),
('cytomet kappa', '&#954;'),
('cytomet cd10', 'CD10'),
('cytomet cd19', 'CD19'),
('cytomet flow number', 'Flow#'),
('cytomet center', 'Center');

-- 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'molecular_date', 'date', NULL, '0', '', '', '', 'date', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'molecular_center', 'input', NULL, '0', 'size=20', '', '', 'molecular center', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'molecular_mdl_number', 'float', NULL, '0', 'size=3', '', '', 'molecular mdl number', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'molecular_mb_number', 'float', NULL, '0', 'size=3', '', '', 'molecular mb number', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'molecular_molecular_dx', 'textarea', NULL, '0', 'rows=3,cols=30', '', '', 'molecular dx', ''); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='molecular_date'), 
'3', '300', 'molecular lab', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='molecular_center'), 
'3', '301', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='molecular_mdl_number'), 
'3', '302', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='molecular_mb_number'), 
'3', '303', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='molecular_molecular_dx'), 
'3', '304', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('molecular center','Center'),
('molecular mdl number', 'MDL-number'),
('molecular mb number', 'MB-number'),
('molecular dx', 'Molecular Dx');

--

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_case_number', 'input', NULL, '0', 'size=20', '', '', 'cytogen case number', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_cyto_number', 'input', NULL, '0', 'size=20', '', '', 'cytogen cyto number', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_date', 'date', NULL, '0', '', '', '', 'date', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_technique', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_cytogenetic_technique'), '0', '', '', '', 'cytogen technique', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_technique_precision', 'input', NULL, '0', 'size=20', '', '', '', 'other precision'), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_bcl2_tr', 'float', NULL, '0', 'size=3', '', '', 'cytogen bcl2 tr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_bcl6_tr', 'float', NULL, '0', 'size=3', '', '', 'cytogen bcl6 tr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_myc_tr', 'float', NULL, '0', 'size=3', '', '', 'cytogen myc tr', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_cyclin_d1_tr', 'float', NULL, '0', 'size=3', '', '', 'cytogen cyclin d1 tr', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_patho_summary', 'cytogen_karyotype', 'input', NULL, '0', 'size=20', '', '', 'cytogen karyotype', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_case_number'), 
'3', '401', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_cyto_number'), 
'3', '402', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_date'), 
'3', '400', 'cytogenetics lab', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_technique'), 
'3', '403', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_technique_precision'), 
'3', '404', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_bcl2_tr'), 
'3', '405', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_bcl6_tr'), 
'3', '406', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_myc_tr'), 
'3', '407', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_cyclin_d1_tr'), 
'3', '408', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_patho_summary'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_patho_summary' AND `field`='cytogen_karyotype'), 
'3', '409', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('cytogen bcl2 tr','BCL2 Tr'),
('cytogen bcl6 tr','BCL6 Tr'),
('cytogen case number','Case Number'),
('cytogen cyto number','Cyto#'),
('cytogen myc tr','MYC tr'),
('cytogen technique','Technique'),
('other precision','Precision'),
('cytogen cyclin d1 tr','Cyclin D1 Tr'),
('cytogen karyotype','Karyotype');

UPDATE structure_fields SET tablename = 'ld_lymph_ed_biopsies' WHERE tablename = 'ld_lymph_ed_patho_summary';

INSERT IGNORE INTO i18n (id,en) VALUES
('hitological dx','Hitological Diagnosis'),
('who class','WHO Class'),
('flow cytometry lab','Flow Cytometry Lab'),
('molecular lab','Molecular Lab'),
('cytogenetics lab','Cytogenetics Lab');

INSERT INTO structure_value_domains(`domain_name`) VALUES ('pos_neg_equivocal');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("positive", "positive"),("negative","negative"),("equivocal","equivocal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="pos_neg_equivocal"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="pos_neg_equivocal"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="pos_neg_equivocal"),  
(SELECT id FROM structure_permissible_values WHERE value="equivocal" AND language_alias="equivocal"), "3", "1");

UPDATE structure_fields 
SET type = 'select', setting = '', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="pos_neg_equivocal")
WHERE tablename = 'ld_lymph_ed_biopsies'
AND field IN (
'immuno_cd10',
'immuno_bcl2_pr',
'immuno_bcl6_pr',
'immuno_cd68',	
'immuno_mum1',
'cytomet_cd20',	
'cytomet_cd19',
'cytomet_cd10',
'cytomet_cd5',
'cytomet_cd23',
'cytomet_cd2',
'cytomet_cd3',
'cytomet_cd4',
'cytomet_cd8',
'cytomet_lambda',
'cytomet_kappa',	
'cytomet_other_value',  

'cytogen_bcl2_tr',	
'cytogen_bcl6_tr',
'cytogen_myc_tr',
'cytogen_cyclin_d1_tr');

INSERT IGNORE INTO i18n (id,en) VALUES ('equivocal','Equivocal');

-- bone marrow

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'bone marrow', 1, 'ld_lymph_ed_bone_marrows', 'ld_lymph_ed_bone_marrows', 0, 'clinical|ld lymph.|bone marrow');

INSERT IGNORE INTO i18n (id,en) VALUES ('bone marrow' , 'Bone Marrow');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_bone_marrows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  
  `path_nbr` varchar(100) DEFAULT '',
  `result` varchar(50) DEFAULT '',
  `hitological_dx` text,	
   
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;  

ALTER TABLE `ld_lymph_ed_bone_marrows`
  ADD CONSTRAINT `FK_ld_lymph_ed_bone_marrows_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_bone_marrows_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
 
  `path_nbr` varchar(100) DEFAULT '',
  `result` varchar(50) DEFAULT '',
  `hitological_dx` text,	
    
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_bone_marrows');

INSERT INTO structure_value_domains(`domain_name`) VALUES ('ld_lymph_pos_neg');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pos_neg"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pos_neg"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_bone_marrows', 'path_nbr', 'input', NULL, '0', 'size=20', '', '', 'path nbr', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_bone_marrows', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name = 'ld_lymph_pos_neg'), '0', '', '', '', 'result', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_bone_marrows', 'hitological_dx', 'textarea', NULL, '0', 'rows=3,cols=40', '', '', 'hitological dx', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_bone_marrows' AND `field`='path_nbr'), 
'1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_bone_marrows' AND `field`='result'), 
'1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_bone_marrows' AND `field`='hitological_dx'), 
'1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE event_controls SET event_type = 'bone marrow biopsy' WHERE event_type = 'bone marrow';
INSERT IGNORE INTO i18n (id,en) VALUES ('bone marrow biopsy' , 'Bone Marrow Biopsy');

UPDATE structure_formats SET display_column = 2
WHERE structure_id = (SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_bone_marrows' AND `field`='hitological_dx');
UPDATE structure_formats SET display_column = 2
WHERE structure_id = (SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `field`='event_summary');

-- reasearch study

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'study', 'reasearch study', 1, 'ld_lymph_ed_reasearch_studies', 'ld_lymph_ed_reasearch_studies', 0, 'study|ld lymph.|reasearch study');

INSERT IGNORE INTO i18n (id,en) VALUES ('reasearch study' , 'Reasearch Study'),('consent date', 'Consent Date');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_reasearch_studies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  
  `name` varchar(100) DEFAULT '',
  `consent_date` date DEFAULT null,
   
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;  

ALTER TABLE `ld_lymph_ed_reasearch_studies`
  ADD CONSTRAINT `FK_ld_lymph_ed_reasearch_studies_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_reasearch_studies_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
 
  `name` varchar(100) DEFAULT '',
  `consent_date` date DEFAULT null,
    
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_reasearch_studies');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_reasearch_studies', 'name', 'input', NULL, '0', 'size=20', '', '', 'name', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_reasearch_studies', 'consent_date', 'date', NULL, '0', '', '', '', 'consent date', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_reasearch_studies' AND `field`='name'), 
'1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_reasearch_studies' AND `field`='consent_date'), 
'1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET display_column = 2
WHERE structure_id = (SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `field`='event_summary');

-- EVENT ALL & MASTER

UPDATE structure_formats SET `flag_override_label` = 1, `language_label` = 'notes'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `field`='event_summary');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- TREATMENT ------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='tx_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='date' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- chemotherapy - frail (palliative) - radiotherapy

UPDATE tx_controls SET flag_active = '0';
INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'radiotherapy', 'ld lymph.', 1, 'ld_lymph_txd_treatments', 'ld_lymph_txd_treatments', NULL, NULL, 0, NULL, NULL, 'ld lymph.|radiotherapy'),
(null, 'chemotherapy', 'ld lymph.', 1, 'ld_lymph_txd_treatments', 'ld_lymph_txd_treatments,ld_lymph_txd_chemos', NULL, NULL, 0, NULL, NULL, 'ld lymph.|chemotherapy'),
(null, 'frail (palliative)', 'ld lymph.', 1, 'ld_lymph_txd_treatments', 'ld_lymph_txd_treatments,ld_lymph_txd_chemos', NULL, NULL, 0, NULL, NULL, 'ld lymph.|frail (palliative)');

DROP TABLE IF EXISTS `ld_lymph_txd_treatments`;
CREATE TABLE IF NOT EXISTS `ld_lymph_txd_treatments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,

  `chemo_regimen` text,
  `dose_modified` char(1) DEFAULT '',
  `dose_modified_precision` text,

  `response` varchar(100) DEFAULT '',
  `response_based_on` varchar(50) DEFAULT '',
  `response_based_on_other` varchar(50) DEFAULT '',
  `mid_cycle_pet_ct_date` date DEFAULT null,
  `mid_cycle_pet_ct_date_accuracy` char(1) NOT NULL DEFAULT '',
  `suv_mid` decimal(7,2) DEFAULT null,
  `final_pet_ct_date` date DEFAULT null,
  `final_pet_ct_date_accuracy` char(1) NOT NULL DEFAULT '',
  `suv_final` decimal(7,2) DEFAULT null,

  `tx_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_txd_treatments`
  ADD CONSTRAINT `FK_ld_lymph_txd_treatments_tx_masters` FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_txd_treatments_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_txd_treatments_revs` (
  `id` int(11) NOT NULL,

  `chemo_regimen` text,
  `dose_modified` char(1) DEFAULT '',
  `dose_modified_precision` text,

  `response` varchar(100) DEFAULT '',
  `response_based_on` varchar(50) DEFAULT '',
  `response_based_on_other` varchar(50) DEFAULT '',
  `mid_cycle_pet_ct_date` date DEFAULT null,
  `mid_cycle_pet_ct_date_accuracy` char(1) NOT NULL DEFAULT '',
  `suv_mid` decimal(7,2) DEFAULT null,
  `final_pet_ct_date` date DEFAULT null,
  `final_pet_ct_date_accuracy` char(1) NOT NULL DEFAULT '',
  `suv_final` decimal(7,2) DEFAULT null,

  `tx_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_trt_responses', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) 
VALUES ("CR","CR trt responses"),("PR","PR trt responses"),("SD","SD trt responses"),("PD","PD trt responses");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="CR" AND language_alias="CR trt responses"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="PR" AND language_alias="PR trt responses"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="SD" AND language_alias="SD trt responses"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="PD" AND language_alias="PD trt responses"), "4", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_trt_response_based_on', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("CT","based on CT"),("PET","based on PET"),("PE","based on PE"),("other","other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="CT" AND language_alias="based on CT"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="PET" AND language_alias="based on PET"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="PE" AND language_alias="based on PE"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'chemo_regimen', 'textarea', NULL , '0', 'rows=3,cols=30', '', '', 'chemo regimen', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'dose_modified', 'yes_no',  NULL , '0', '', '', '', 'dose modified', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'dose_modified_precision', 'textarea', NULL , '0', 'rows=3,cols=30', '', '', 'dose modified precision', ''), 

('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_responses') , '0', '', '', '', 'response', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'response_based_on', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_response_based_on') , '0', '', '', '', 'based on', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'response_based_on_other', 'input',  NULL , '0', 'size=30', '', '', '', 'based on other'), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'mid_cycle_pet_ct_date', 'date',  NULL , '0', '', '', '', 'mid cycle pet ct date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'suv_mid', 'float',  NULL , '0', '', '', '', '', 'suv mid'), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'final_pet_ct_date', 'date',  NULL , '0', '', '', '', 'final pet ct date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_treatments', 'suv_final', 'float',  NULL , '0', '', '', '', '', 'suv final');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_txd_treatments');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='tx_controls' AND `field`='tx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_method' AND `language_label`='' AND `language_tag`=''), '1', '1', 'clin_treatment', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='start date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),

((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_responses')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '3', '30', 'response', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='response_based_on' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_response_based_on')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='based on' AND `language_tag`=''), '3', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='response_based_on_other' AND `type`='input' AND `structure_value_domain`  IS NULL ), '3', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='mid_cycle_pet_ct_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mid cycle pet ct date' AND `language_tag`=''), '3', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='suv_mid' AND `type`='float' ), '3', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='final_pet_ct_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='final pet ct date' AND `language_tag`=''), '3', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='suv_final' AND `type`='float'), '3', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_txd_chemos');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='chemo_regimen'), '2', '21', 'chemotherapy data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='dose_modified' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose modified' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='dose_modified_precision'), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('based on' ,'Based On'),
('based on CT' ,'CT'),
('based on other' ,'Other Description'),
('based on PE' ,'PE'),
('based on PET' ,'PET'),
('chemo' ,'Chemo'),
('chemo regimen' ,'Chemo Regimen'),
('CR trt responses' ,'CR'),
('dose modified' ,'Dose Modified'),
('dose modified precision' ,'Modification Precision'),
('final pet ct date' ,'Final PET/CT'),
('frail palliative' ,'Frail (palliative)'),
('mid cycle pet ct date' ,'Mid cycle PET/CT'),
('observation' ,'Observation'),
('PD trt responses' ,'PD'),
('PR trt responses' ,'PR'),
('primary treatment' ,'Primary Treatment'),
('primary treatment type' ,'Type'),
('SD trt responses' ,'SD'),
('suv final' ,'SUVfinal'),
('suv mid' ,'SUVmid'),
('frail (palliative)','Frail (palliative)'),
('chemotherapy data','Chemo Data'),
('radiotherapy','Radiotherapy');

UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- observation
  
INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'observation', 'ld lymph.', 1, 'ld_lymph_txd_observations', 'ld_lymph_txd_observations', NULL, NULL, 0, NULL, NULL, 'ld lymph.|observation');
  
DROP TABLE IF EXISTS `ld_lymph_txd_observations`;
CREATE TABLE IF NOT EXISTS `ld_lymph_txd_observations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,

  `tx_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_txd_observations`
  ADD CONSTRAINT `FK_ld_lymph_txd_observations_tx_masters` FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_txd_observations_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_txd_observations_revs` (
  `id` int(11) NOT NULL,

  `tx_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_txd_observations');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_observations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='tx_controls' AND `field`='tx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_method' AND `language_label`='' AND `language_tag`=''), '1', '1', 'clin_treatment', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_observations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='start date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_observations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='date' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_observations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
  
-- stem cell transplant

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'stem cell transplant', 'ld lymph.', 1, 'ld_lymph_txd_stem_cell_transplants', 'ld_lymph_txd_stem_cell_transplants', NULL, NULL, 0, NULL, NULL, 'ld lymph.|stem cell transplant');

DROP TABLE IF EXISTS `ld_lymph_txd_stem_cell_transplants`;
CREATE TABLE IF NOT EXISTS `ld_lymph_txd_stem_cell_transplants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,

  `tx_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_txd_stem_cell_transplants`
  ADD CONSTRAINT `FK_ld_lymph_txd_stem_cell_transplants_tx_masters` FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_txd_stem_cell_transplants_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_txd_stem_cell_transplants_revs` (
  `id` int(11) NOT NULL,

  `tx_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_txd_stem_cell_transplants');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_stem_cell_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='tx_controls' AND `field`='tx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_method' AND `language_label`='' AND `language_tag`=''), '1', '1', 'clin_treatment', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_stem_cell_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='start date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_stem_cell_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO i18n (id,en) VALUES ('stem cell transplant', 'Stem Cell Transplant');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='date' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_stem_cell_transplants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

