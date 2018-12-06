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

-- --------------------------------------------------------------------------------
-- 2018-11-26
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

UPDATE `versions` SET branch_build_number = '7525' WHERE version_number = '2.7.1';




Tous les blocs chum de Coeur, n'ont pas été créer dans axe Onco avec un flagg donnée à COEUR. Todo pour CPCBN & QBCF aussi.
Vérifier que les patients CHUM coeur sont tous dans ATiM.




