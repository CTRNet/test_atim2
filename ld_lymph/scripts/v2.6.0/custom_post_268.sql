
-- ---------------------------------------------------------------------------------------------------------
-- Participants
-- ----------------------------------------------------------------------------------------------------------

-- Misc identifiers

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'study consent', 1, 'consent_masters_study', 'cd_nationals', 0, 'study consent');
INSERT INTO i18n (id,en,fr) VALUES ('study consent', 'Sudy Consent', 'Consentement d''étude');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_consent_study_summary_id'), 'notEmpty', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='consent_status'), 'notEmpty', '');

-- Message

UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

-- ---------------------------------------------------------------------------------------------------------
-- Inventory
-- ----------------------------------------------------------------------------------------------------------

-- Inventory Configuration

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(211);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(221, 238, 212);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(53);

-- Migrate pbmc to buffy coat

REPLACE INTO i18n (id,en,fr)
VALUES
('pbmc', 'PBMC', 'PBMC');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(234, 245, 235, 246, 236);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(71);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(75);
INSERT INTO sd_der_buffy_coats (sample_master_id) (SELECT sample_master_id FROM sd_der_pbmcs);
DELETE FROM sd_der_pbmcs;
INSERT INTO sd_der_buffy_coats_revs (sample_master_id, version_created) (SELECT sample_master_id, version_created FROM sd_der_pbmcs_revs);
DELETE FROM sd_der_pbmcs_revs;
UPDATE sample_masters 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
UPDATE sample_masters_revs 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
UPDATE aliquot_masters 
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE aliquot_masters_revs
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE sample_masters SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'pbmc';
UPDATE sample_masters_revs SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'pbmc';
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(4);

-- Aliquot

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot In Stock Details\')" WHERE domain_name = 'aliquot_in_stock_detail';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Aliquot In Stock Details', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot In Stock Details');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT val.value,en,fr, '1', @control_id
FROM structure_value_domains dom 
INNER JOIN structure_value_domains_permissible_values lk ON lk.structure_value_domain_id = dom.id AND lk.flag_active = 1
INNER JOIN structure_permissible_values val ON val.id = structure_permissible_value_id
LEFT JOIN i18n ON i18n.id =val.value
WHERE dom.domain_name = 'aliquot_in_stock_detail');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES ('destroyed/not consented', 'Destroyed - Not consented', '', '1', @control_id);
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_in_stock_detail'); 

-- ---------------------------------------------------------------------------------------------------------
-- Tools & co
-- ----------------------------------------------------------------------------------------------------------

-- Studies

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE study_summaries 
  ADD COLUMN ld_lymph_institution VARCHAR(50) DEFAULT NULL,
  ADD COLUMN ld_lymph_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN ld_lymph_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN ld_lymph_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN ld_lymph_mta_data_sharing_approved_file_name varchar(500) DEFAULT null,
  ADD COLUMN ld_lymph_pubmed_ids TEXT DEFAULT NULL;
ALTER TABLE study_summaries_revs 
  ADD COLUMN ld_lymph_institution VARCHAR(50) DEFAULT NULL,
  ADD COLUMN ld_lymph_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN ld_lymph_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN ld_lymph_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN ld_lymph_mta_data_sharing_approved_file_name varchar(500) DEFAULT null,
  ADD COLUMN ld_lymph_pubmed_ids TEXT DEFAULT NULL;  
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('ld_lymph_institutions', "StructurePermissibleValuesCustom::getCustomDropdown('Institutions')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Institutions', 1, 50, 'study / project');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'ld_lymph_ethical_approved', 'yes_no',  NULL , '0', '', '', '', 'ethic', ''), 
('Study', 'StudySummary', 'study_summaries', 'ld_lymph_ethical_approval_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'), 
('Study', 'StudySummary', 'study_summaries', 'ld_lymph_mta_data_sharing_approved', 'yes_no',  NULL , '0', '', '', '', 'mta data sharing', ''), 
('Study', 'StudySummary', 'study_summaries', 'ld_lymph_mta_data_sharing_approved_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'),
('Study', 'StudySummary', 'study_summaries', 'ld_lymph_institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_institutions') , '0', '', '', '', 'laboratory / institution', ''),
('Study', 'StudySummary', 'study_summaries', 'ld_lymph_pubmed_ids', 'textarea',  NULL , '0', 'cols=40,rows=1', '', '', 'pubmed ids', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='ld_lymph_ethical_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethic' AND `language_tag`=''), '2', '1', 'approval', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='ld_lymph_ethical_approval_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='ld_lymph_mta_data_sharing_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta data sharing' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='ld_lymph_mta_data_sharing_approved_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='ld_lymph_institution'), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='ld_lymph_pubmed_ids' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=1' AND `default`='' AND `language_help`='' AND `language_label`='pubmed ids' AND `language_tag`=''), '2', '20', 'literature', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='30', `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
VALUES
('laboratory / institution', 'Laboratory/Institution','Laboratoire/Institution'),
('approval', 'Approval', 'Approbation'),
('ethic', 'Ethic', 'éthique'),
('file name', 'File Name', 'Nom du fichier'),
('mta data sharing', 'MTA Data Sharing', 'Partage de matériels et de données'),
('literature','Literature','Literature'),
('pubmed ids','PubMed IDs','PubMed IDs');

-- orders

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='short_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='aliquot barcode' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- drop down list

UPDATE `structure_permissible_values_custom_controls` 
SET flag_active = 0
WHERE name LIKE 'Xenograft%';

-- Databrowser

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') OR id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock')
OR  id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');

UPDATE datamart_reports SET flag_active = 0 
WHERE name IN ('report_3_name', 'report_4_name', 'report_5_name');

UPDATE datamart_structure_functions 
SET flag_active = 0
WHERE datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('FamilyHistory', 'SpecimenReviewMaster', 'ReproductiveHistory', 'AliquotReviewMaster', 'TmaSlide', 'TmaSlideUse', 'TmaBlock'));

-- Storage

UPDATE storage_controls set display_x_size = 0, display_y_size = 0 
WHERE coord_x_type IS NOT NULL AND coord_x_type != 'list'
AND coord_y_type IS NOT NULL
AND (display_x_size != '0' OR display_y_size != '0'); 

-- ---------------------------------------------------------------------------------------------------------
-- Data clean up
-- ----------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_internal_uses 
  ADD COLUMN tmp_bool tinyint(1) DEFAULT '0',
  ADD COLUMN tmp_order_number varchar(255),
  ADD COLUMN tmp_shipped_date date default NULL,
  ADD COLUMN tmp_shipped_date_accuracy char(1) DEFAULT '',
  ADD COLUMN tmp_order_used_by varchar(100)default NULL;

UPDATE aliquot_internal_uses ALiquotInternalUse, aliquot_masters AliquotMaster
SET tmp_bool = '1',
tmp_order_number = TRIM(CONCAT(TRIM(ALiquotInternalUse.use_code), ' ', TRIM(REPLACE(REPLACE(REPLACE(ALiquotInternalUse.use_details, CHAR(13), ' '), CHAR(10), ' '), 'Pr ', 'Pr. ')))),
tmp_shipped_date = ALiquotInternalUse.use_datetime,
tmp_shipped_date_accuracy = REPLACE(REPLACE(ALiquotInternalUse.use_datetime_accuracy, 'd', 'c'), 'h', 'c'),
tmp_order_used_by = ALiquotInternalUse.used_by
WHERE AliquotMaster.id = ALiquotInternalUse.aliquot_master_id
AND AliquotMaster.deleted <> 1 AND ALiquotInternalUse.deleted <> 1
AND AliquotMaster.in_stock = 'no' AND AliquotMaster.in_stock_detail = 'shipped'
AND (ALiquotInternalUse.used_volume IS NULL OR AliquotMaster.initial_volume IS NULL OR (ALiquotInternalUse.used_volume = AliquotMaster.initial_volume))
AND ALiquotInternalUse.use_code NOT IN('Vit D', 'FL on W&W', 'Internal use');

SET @created_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @created = (SELECT NOW() FROM users WHERE username = 'NicoEn');

ALTER TABLE orders 
  ADD COLUMN tmp_shipped_date date default NULL,
  ADD COLUMN tmp_shipped_date_accuracy char(1) DEFAULT '',
  ADD COLUMN tmp_order_used_by varchar(100)default NULL;

INSERT INTO orders (`order_number`, `comments`, `modified`, `created`, `created_by`, `modified_by`, tmp_shipped_date, tmp_shipped_date_accuracy, tmp_order_used_by)
(SELECT DISTINCT tmp_order_number, 'Created by migration script (2.6.8).', @created, @created, @created_by, @created_by, tmp_shipped_date, tmp_shipped_date_accuracy, tmp_order_used_by
FROM aliquot_internal_uses WHERE tmp_bool = '1');
UPDATE orders SET processing_status = 'completed', date_order_completed = tmp_shipped_date, date_order_completed_accuracy = tmp_shipped_date_accuracy
WHERE created = @created;
INSERT INTO orders_revs (`order_number`, date_order_completed, date_order_completed_accuracy, `comments`, processing_status,  `modified_by`, `id`, `version_created`) 
(SELECT `order_number`, date_order_completed, date_order_completed_accuracy, `comments`, processing_status,  `modified_by`, `id`, `created` FROM orders WHERE created = @created AND created_by = @created_by);

INSERT INTO order_items (`date_added`, `added_by`, `date_added_accuracy`, `aliquot_master_id`, `status`, `order_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT AliquotUse.tmp_shipped_date, AliquotUse.tmp_order_used_by, AliquotUse.tmp_shipped_date_accuracy, aliquot_master_id, 'shipped', Orders.id, @created, @created, @created_by, @created_by
FROM orders Orders, aliquot_internal_uses AliquotUse
WHERE Orders.order_number = AliquotUse.tmp_order_number 
AND ((Orders.tmp_shipped_date = AliquotUse.tmp_shipped_date AND Orders.tmp_shipped_date_accuracy = AliquotUse.tmp_shipped_date_accuracy) OR (Orders.tmp_shipped_date IS NULL AND AliquotUse.tmp_shipped_date IS NULL)) 
AND Orders.tmp_order_used_by = AliquotUse.tmp_order_used_by
AND tmp_bool = '1');
INSERT INTO order_items_revs (`date_added`, `added_by`, `date_added_accuracy`, `aliquot_master_id`, `status`, `order_id`, `modified_by`, `id`, `version_created`)
(SELECT `date_added`, `added_by`, `date_added_accuracy`, `aliquot_master_id`, `status`, `order_id`, `modified_by`, `id`, `created` FROM order_items WHERE created = @created AND created_by = @created_by);

INSERT INTO shipments (`shipment_code`, `datetime_shipped`, `shipped_by`, `order_id`, `datetime_shipped_accuracy`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT CONCAT('Ship#',id), tmp_shipped_date, tmp_order_used_by, id, REPLACE(tmp_shipped_date_accuracy, 'c', 'h'), @created, @created, @created_by, @created_by 
FROM orders WHERE created = @created AND created_by = @created_by);
INSERT INTO shipments_revs (`shipment_code`, `datetime_shipped`, `shipped_by`, `order_id`, `datetime_shipped_accuracy`, `modified_by`, `id`, `version_created`)
(SELECT `shipment_code`, `datetime_shipped`, `shipped_by`, `order_id`, `datetime_shipped_accuracy`, `modified_by`, `id`, `created` FROM shipments WHERE created = @created AND created_by = @created_by);

UPDATE order_items, orders, shipments 
SET shipment_id = shipments.id
WHERE orders.id = order_items.order_id AND orders.id = shipments.order_id
AND orders.created = @created AND orders.created_by = @created_by;
UPDATE order_items, order_items_revs 
SET order_items_revs.shipment_id = order_items.shipment_id
WHERE order_items.id = order_items_revs.id
AND order_items.created = @created AND order_items.created_by = @created_by;

-- current_volume and revs table will be poulated by newVersionSetup() function
UPDATE aliquot_masters AliquotMaster, aliquot_internal_uses AliquotInternalUse
SET AliquotMaster.initial_volume = AliquotInternalUse.used_volume,
AliquotMaster.modified = @created,
AliquotMaster.modified_by = @created_by
WHERE AliquotMaster.id = AliquotInternalUse.aliquot_master_id
AND AliquotInternalUse.tmp_bool = '1'
AND ALiquotInternalUse.used_volume IS NOT NULL AND AliquotMaster.initial_volume IS NULL;

UPDATE aliquot_internal_uses 
SET deleted = 1,
modified = @created,
modified_by = @created_by
WHERE tmp_bool = '1';

INSERT INTO aliquot_internal_uses_revs (id, aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration, duration_unit,
used_by, study_summary_id, modified_by, version_created)
(SELECT id, aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration, duration_unit,
used_by, study_summary_id, modified_by, modified FROM aliquot_internal_uses WHERE tmp_bool = '1');

ALTER TABLE aliquot_internal_uses 
  DROP COLUMN tmp_bool,
  DROP COLUMN tmp_order_number,
  DROP COLUMN tmp_shipped_date,
  DROP COLUMN tmp_shipped_date_accuracy,
  DROP COLUMN tmp_order_used_by;

ALTER TABLE orders 
  DROP COLUMN tmp_shipped_date,
  DROP COLUMN tmp_shipped_date_accuracy,
  DROP COLUMN tmp_order_used_by;

-- ----------------------------------------------------------------------------------------------------------
-- Versions
-- ----------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6603' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;





mysql -u root ldlymph --default-character-set=utf8 < C:\_NicolasLuc\Server\www\atim_jgh_lymph_20161127.sql
mysql -u root ldlymph --default-character-set=utf8 < atim_v2.6.3_upgrade.sql
mysql -u root ldlymph --default-character-set=utf8 < atim_v2.6.4_upgrade.sql > 4.txt
mysql -u root ldlymph --default-character-set=utf8 < atim_v2.6.5_upgrade.sql > 5.txt
mysql -u root ldlymph --default-character-set=utf8 < atim_v2.6.6_upgrade.sql > 6.txt
mysql -u root ldlymph --default-character-set=utf8 < atim_v2.6.7_upgrade.sql > 7.txt
mysql -u root ldlymph --default-character-set=utf8 < atim_v2.6.8_upgrade.sql > 8.txt
mysql -u root ldlymph --default-character-set=utf8 < custom_post_268.sql
