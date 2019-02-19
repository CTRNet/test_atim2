-- --------------------------------------------------------------------------------
-- Hide all fields displaying protocol data into Inventory Management module.
-- --------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE menus SET flag_active=false WHERE id IN('collection_template');

UPDATE `versions` SET branch_build_number = '7378' WHERE version_number = '2.7.1';
UPDATE `versions` SET branch_build_number = '7398' WHERE version_number = '2.7.1';

-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- 2019-02-08 : New fields
-- ---------------------------------------------------------------------------------------------------------------------------------------------

-- Study Sumamry

ALTER TABLE study_summaries 
  ADD COLUMN qc_tf_pubmed_ids TEXT DEFAULT NULL,
  ADD COLUMN qc_tf_study_full_title varchar(500) DEFAULT NULL,
  ADD COLUMN qc_tf_contact_email varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_ethical_approved char(1) DEFAULT '',
  ADD COLUMN qc_tf_ethical_number varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_ethical_details varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_return_of_data_to_coeur char(1) DEFAULT '';
 ALTER TABLE study_summaries_revs
  ADD COLUMN qc_tf_pubmed_ids TEXT DEFAULT NULL,
  ADD COLUMN qc_tf_study_full_title varchar(500) DEFAULT NULL,
  ADD COLUMN qc_tf_contact_email varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_ethical_approved char(1) DEFAULT '',
  ADD COLUMN qc_tf_ethical_number varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_ethical_details varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_return_of_data_to_coeur char(1) DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_tf_pubmed_ids', 'textarea',  NULL , '0', 'cols=40,rows=2', '', '', 'pubmed ids', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_study_full_title', 'input',  NULL , '0', 'size=60', '', '', 'study_title', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_contact_email', 'input',  NULL , '0', '', '', '', 'mail', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_ethical_approved', 'yes_no',  NULL , '0', '', '', '', 'qc tf ethical approved', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_ethical_number', 'input',  NULL , '0', 'size=10', '', '', 'qc tf ethical number', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_ethical_details', 'input',  NULL , '0', 'size=50', '', '', 'qc tf ethical details', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_return_of_data_to_coeur', 'yes_no',  NULL , '0', '', '', '', 'qc tf return of data to coeur', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_pubmed_ids' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=2' AND `default`='' AND `language_help`='' AND `language_label`='pubmed ids' AND `language_tag`=''), '2', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_study_full_title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=60' AND `default`='' AND `language_help`='' AND `language_label`='study_title' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_contact_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mail' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_ethical_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc tf ethical approved' AND `language_tag`=''), '2', '13', 'ethic', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_ethical_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='qc tf ethical number' AND `language_tag`=''), '2', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_ethical_details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='qc tf ethical details' AND `language_tag`=''), '2', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_return_of_data_to_coeur' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc tf return of data to coeur' AND `language_tag`=''), '2', '20', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='abstract' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='101' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='100', `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='abstract' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='102', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_return_of_data_to_coeur' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='101' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_pubmed_ids' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORe INTO i18n (id,en,fr)
VALUES
("ethic", "Ethic", ""),
("qc tf ethical approved", "Approved", ""),
("qc tf ethical number", "Number", ""),
("qc tf ethical details", "Details", ""),
("pubmed ids", "PubMed Ids", ""),
("qc tf return of data to coeur", "Return of Data to Coeur", "");

ALTER TABLE study_summaries MODIFY qc_tf_coeur_principal_investigator varchar(500) DEFAULT NULL;
ALTER TABLE study_summaries_revs MODIFY qc_tf_coeur_principal_investigator varchar(500) DEFAULT NULL;

UPDATE `versions` SET branch_build_number = '7569' WHERE version_number = '2.7.1';

-- --------------------------------------------------------------------------------
-- 2018-02-11
-- --------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("Jason","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Liliane","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Monique","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Christine","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Liliane et Isabelle","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Isabelle","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Cecile","","",'1', @control_id, NOW(), NOW(), 1, 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("reception (from bank)","Reception (from bank)","Réception (de la banque)",'1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Remove diagnosis_master_id FROM collections
UPDATE collections SET diagnosis_master_id = null;	-- Don,t eraase value in res to keep info
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =9) OR (id1 = 9 AND id2 =2);

UPDATE collections SET collection_property = 'participant collection' WHERE collection_property IS NULL OR collection_property = '';
UPDATE collections_revs SET collection_property = 'participant collection' WHERE collection_property IS NULL OR collection_property = '';

-- block

ALTER TABLE ad_blocks 
  ADD COLUMN qc_tf_cellularity int(4) DEFAULT NULL,
  ADD COLUMN qc_tf_quantity_available varchar(50) DEFAULT NULL;
ALTER TABLE ad_blocks_revs 
  ADD COLUMN qc_tf_cellularity int(4) DEFAULT NULL,
  ADD COLUMN qc_tf_quantity_available varchar(50) DEFAULT NULL;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Block Quantity Available', 1, 50, 'inventory');
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 50, values_used_as_input_counter = 1, values_counter = 1 WHERE name = 'Block Quantity Available';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('qc_tf_quantity_available', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Block Quantity Available\')');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qc_tf_cellularity', 'integer_positive',  NULL , '0', 'size=4', '', '', 'cellularity', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qc_tf_quantity_available', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_quantity_available') , '0', '', '', '', 'quantity available', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qc_tf_cellularity' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='cellularity' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qc_tf_quantity_available' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_quantity_available')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='quantity available' AND `language_tag`=''), '1', '75', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Block Quantity Available');
SET @user_id = 2;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Block Quantity Available');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("none","","",'1', @control_id, NOW(), NOW(), 1, 1),
("no tumor","","",'1', @control_id, NOW(), NOW(), 1, 1),
("Good","","",'1', @control_id, NOW(), NOW(), 1, 1),
("2 punchs","","",'1', @control_id, NOW(), NOW(), 1, 1),
('limited (2-3 punchs)', "","",'1', @control_id, NOW(), NOW(), 1, 1),
("not enough","","",'1', @control_id, NOW(), NOW(), 1, 1),
("ok 8 et +","","",'1', @control_id, NOW(), NOW(), 1, 1),
("limited","","",'1', @control_id, NOW(), NOW(), 1, 1),
("0 core","","",'1', @control_id, NOW(), NOW(), 1, 1),
("2 cores","","",'1', @control_id, NOW(), NOW(), 1, 1),
("borderline","","",'1', @control_id, NOW(), NOW(), 1, 1),
("borderline mucineux","","",'1', @control_id, NOW(), NOW(), 1, 1),
("not enough tumor","","",'1', @control_id, NOW(), NOW(), 1, 1),
('clear cell',"","",'1', @control_id, NOW(), NOW(), 1, 1),
('small-enough for DNA extraction not for TMA',"","",'1', @control_id, NOW(), NOW(), 1, 1),
('low',"","",'1', @control_id, NOW(), NOW(), 1, 1),
('limited (2-3 punchs left)',"","",'1', @control_id, NOW(), NOW(), 1, 1),
('4 cores sur un bloc',"","",'1', @control_id, NOW(), NOW(), 1, 1),
("limited (2-3 cores)","","",'1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO i18n (id,en,fr)
VALUES
('cellularity', 'Cellularity', ''),
('quantity available', 'Quantity Available', '');

-- ...

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("returned (to bank)","Returned (to bank)","Retour (à la banque)",'1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("dr rahimi","Dr Rahimi","",'1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("kim","Kim","",'1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- H&E and slide

UPDATE aliquot_controls SET flag_active=true WHERE id IN('9');
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('9');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='marker / coloration / etc' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('marker / coloration / etc', 'Marker/Coloration/Etc', '');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("slide revision","slide revision","",'1', @control_id, NOW(), NOW(), 1, 1);

--

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("wrong block (1st migration)", "wrong block (1st coeur migration)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="wrong block (1st migration)" AND language_alias="wrong block (1st coeur migration)"), "1", "1");
INSERT INTO i18n (id,en,fr)
VALUES
("wrong block (1st coeur migration)", "Wrong block (created by 1st coeur data migration batch)", "");

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("sent back", "sent back");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="sent back" AND language_alias="sent back"), "1", "1");
INSERT INTO i18n (id,en,fr)
VALUES
("sent back", "Sent back", "");

SET @created_by = (SELECT id FROM users WHERE username = 'system');
SET @created = (SELECT NOW() FROM users WHERE username = 'system');
UPDATE aliquot_masters, ad_blocks
SET in_stock_detail = 'sent back',
modified = @created,
modified_by = @created_by
WHERE aliquot_control_id = 8
AND deleted <> 1
AND in_stock = 'no'
AND notes LIKE '%sent back%'
AND id = aliquot_master_id;
INSERT INTO aliquot_masters_revs
(id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id,
storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id,
storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, modified_by, modified
FROM aliquot_masters WHERE modified = @created AND modified_by = @created_by);
INSERT INTO ad_blocks_revs (aliquot_master_id, block_type, patho_dpt_block_code, qc_tf_cellularity, qc_tf_quantity_available, version_created)
(SELECT aliquot_master_id, block_type, patho_dpt_block_code, qc_tf_cellularity, qc_tf_quantity_available, modified
FROM aliquot_masters, ad_blocks
WHERE id = aliquot_master_id AND modified = @created AND modified_by = @created_by);

UPDATE `versions` SET branch_build_number = '7570' WHERE version_number = '2.7.1';

UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,class=file' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,class=file' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Aliquot In Stock Details', 1, 30, 'inventory');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot In Stock Details');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("empty", "Empty", "Vide", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("reserved for order", "Reserved For Order", "Réservé pour une commande", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("lost", "Lost", "Perdu", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("used", "Used", "Utilisé", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("on loan", "On Loan", "Prêté", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other", "Other", "Autre", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("shipped", "Shipped", "Envoyé", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("contaminated", "Contaminated", "Contaminé", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("reserved for study", "Reserved For Study/Project", "Réservé pour une Étude/Projet", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("qc_tf_coeur_awaiting_reception", "Awaiting reception", "En attente de réception", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("shipped &amp; returned", "Shipped &amp; Returned", "Enovyé &amp; Retourné", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("wrong block (1st migration)", "Wrong block (created by 1st coeur data migration batch)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("sent back", "Sent back", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 13, values_counter = 13 WHERE name = 'Aliquot In Stock Details';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot In Stock Details\')' WHERE domain_name = 'aliquot_in_stock_detail';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_in_stock_detail');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

UPDATE `versions` SET branch_build_number = '7571' WHERE version_number = '2.7.1';

-- --------------------------------------------------------------------------------
-- 2018-02-13
-- --------------------------------------------------------------------------------

-- TMA Block

UPDATE aliquot_controls SET flag_active=true WHERE id IN('32');
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('33');

-- Tissue Core Revision

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='pathologist/reviewer' WHERE model='SpecimenReviewMaster' AND tablename='specimen_review_masters' AND field='pathologist' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO aliquot_review_controls (review_type,flag_active,detail_form_alias,detail_tablename,aliquot_type_restriction,databrowser_label)
VALUES
('tissue core review', 1, 'qc_tf_ar_tissue_cores', 'qc_tf_ar_tissue_cores', 'core,slide,block', 'tissue core review');
INSERT INTO specimen_review_controls (sample_control_id, aliquot_review_control_id, review_type, flag_active, detail_form_alias, detail_tablename, databrowser_label)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM aliquot_review_controls WHERE review_type = 'tissue core review'),
'core review', 1, '', 'qc_tf_spr_tissue_cores', 'tissue|core review');

DROP TABLE IF EXISTS `qc_tf_spr_tissue_cores`;
CREATE TABLE `qc_tf_spr_tissue_cores` (
  `specimen_review_master_id` int(11) NOT NULL,
  KEY `FK_qc_tf_spr_tissue_cores_specimen_review_masters` (`specimen_review_master_id`),
  CONSTRAINT `FK_qc_tf_spr_tissue_cores_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `qc_tf_spr_tissue_cores_revs`;
CREATE TABLE `qc_tf_spr_tissue_cores_revs` (
  `specimen_review_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `qc_tf_ar_tissue_cores`;
CREATE TABLE `qc_tf_ar_tissue_cores` (
  `aliquot_review_master_id` int(11) NOT NULL,
  `site_revision` varchar(100) NOT NULL,
  KEY `FK_qc_tf_ar_tissue_cores_aliquot_review_masters` (`aliquot_review_master_id`),
  CONSTRAINT `FK_qc_tf_ar_tissue_cores_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `qc_tf_ar_tissue_cores_revs`;
CREATE TABLE `qc_tf_ar_tissue_cores_revs` (
  `aliquot_review_master_id` int(11) NOT NULL,
  `site_revision` varchar(100) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('qc_tf_ar_tissue_cores');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'qc_tf_ar_tissue_cores', 'site_revision', 'input',  NULL , '0', 'size=30', '', '', 'site revision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ar_tissue_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_tf_ar_tissue_cores' AND `field`='site_revision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='site revision' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_tf_ar_tissue_cores' AND `field`='site_revision' ), 'notBlank', '', '');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('site revision', 'Site Revision', ''),
('pathologist/reviewer', 'Pathologist/Reviewer', ''),
('core review', 'Core Review', '');

UPDATE `versions` SET branch_build_number = '7574' WHERE version_number = '2.7.1';

-- --------------------------------------------------------------------------------
-- 2018-02-13
-- --------------------------------------------------------------------------------

ALTER TABLE storage_masters MODIFY `short_label` varchar(20) DEFAULT NULL;
ALTER TABLE storage_masters_revs MODIFY `short_label` varchar(20) DEFAULT NULL;

ALTER TABLE storage_masters MODIFY `selection_label` varchar(250) DEFAULT '';
ALTER TABLE storage_masters_revs MODIFY `selection_label` varchar(250) DEFAULT '';

-- --------------------------------------------------------------------------------
-- 2018-02-13
-- --------------------------------------------------------------------------------

ALTER TABLE tma_slides
   ADD COLUMN qc_tf_qc_tf_parrafin_protection char(1) NOT NULL DEFAULT '',
   ADD COLUMN qc_tf_quality_assessment varchar(20) DEFAULT NULL,
   ADD COLUMN qc_tf_sectionning_date date DEFAULT NULL,
   ADD COLUMN qc_tf_sectionning_date_accuracy char(1) NOT NULL DEFAULT '',
   ADD COLUMN qc_tf_sectionning_done_by varchar(50) DEFAULT NULL;  
ALTER TABLE tma_slides_revs
   ADD COLUMN qc_tf_qc_tf_parrafin_protection char(1) NOT NULL DEFAULT '',
   ADD COLUMN qc_tf_quality_assessment varchar(20) DEFAULT NULL,
   ADD COLUMN qc_tf_sectionning_date date DEFAULT NULL,
   ADD COLUMN qc_tf_sectionning_date_accuracy char(1) NOT NULL DEFAULT '',
   ADD COLUMN qc_tf_sectionning_done_by varchar(50) DEFAULT NULL;  
   
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TMA Slides Quality Assessments', 1, 20, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA Slides Quality Assessments');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("2", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("?", "", "", "99", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls SET values_max_length = 20, values_used_as_input_counter = 4, values_counter = 4 WHERE name = 'TMA Slides Quality Assessments';
INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('qc_tf_tma_slide_quality_assessments', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TMA Slides Quality Assessments\')');
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_qc_tf_parrafin_protection', 'yes_no',  NULL , '0', '', '', '', 'parrafin protection', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_quality_assessment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_quality_assessments') , '0', '', '', '', 'quality assessment', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_sectionning_date', 'date',  NULL , '0', '', '', '', 'qc tf sectionning date', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_sectionning_done_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'qc tf sectionning done by', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_qc_tf_parrafin_protection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='parrafin protection' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_quality_assessment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_quality_assessments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='quality assessment' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_sectionning_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc tf sectionning date' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_sectionning_done_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc tf sectionning done by' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='markers' WHERE model='TmaSlide' AND tablename='tma_slides' AND field='immunochemistry' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_sop_list') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('parrafin protection', 'Parrafin Protection', ''),
('quality assessment', 'Quality Assessment', ''),
('qc tf sectionning date', 'Sectionning Date', ''),
('qc tf sectionning done by', 'Sectionning Done By', ''),
('markers', 'Markers', '');
  
ALTER TABLE tma_slides ADD COLUMN qc_tf_notes varchar(250) DEFAULT NULL;
ALTER TABLE tma_slides_revs ADD COLUMN qc_tf_notes varchar(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_notes', 'input',  NULL , '0', '', 'other', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='other' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

UPDATE `versions` SET branch_build_number = '7576' WHERE version_number = '2.7.1';