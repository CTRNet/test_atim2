SET @id = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = @id OR id2 = @id;

UPDATE structure_fields SET language_label = 'consent form identification' WHERE field = 'procure_form_identification' AND model = 'ConsentMaster';
UPDATE structure_fields SET language_label = 'event form identification' WHERE field = 'procure_form_identification' AND model = 'EventMaster';
UPDATE structure_fields SET language_label = 'treatment form identification' WHERE field = 'procure_form_identification' AND model = 'TreatmentMaster';
REPLACE INTO i18n (id,en,fr) 
VALUES 
('aliquot procure identification','Identification (alq.)','Identification (alq.)'),
('participant identifier','Identification (part.)','Identification (part.)'),
('tissue identification','Identification (tiss.)','Identification (tiss.)');
INSERT INTO i18n (id,en,fr) 
VALUES 
('consent form identification','Identification (cst.)','Identification (cst.)'),
('event form identification','Identification (ann.)','Identification (ann.)'),
('treatment form identification','Identification (trt.)','Identification (trt.)');

UPDATE storage_controls SET display_x_size = '10' WHERE storage_type = 'box100';

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) 
VALUES
(null, 'rack4', 'column', 'integer', 4, NULL, NULL, NULL, 4, 0, 0, 0, 0, 0, 0, 1, 'storage_w_spaces', 'std_racks', 'rack4', 0),
(null, 'box16', 'position', 'integer', 16, NULL, NULL, NULL, 1, 16, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box16', 1);
INSERT INTO i18n (id,en,fr) VALUES ('rack4','Rack 4','Râtelier 4'), ('box16','Box 16','Boîte 16');

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'boxPAR', 'position', 'integer', 8, NULL, NULL, NULL, 4, 2, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'boxPAR', 1),
(null, 'drawer2', 'row', 'integer', 2, NULL, NULL, NULL, 2, 1, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'drawer2', 0);
INSERT INTO i18n (id,en,fr) VALUES ('drawer2','Drawer 2','Tiroir 2'), ('boxPAR','Box PAR','Boîte PAR');

UPDATE structure_fields SET  `setting`='size=20,class=range file' WHERE model='Participant' AND tablename='participants' AND field='participant_identifier' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structures(`alias`) VALUES ('procure_miscidentifiers_for_participant_summary');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', '0', 'misc_identifiers', 'hospital_number', 'input',  NULL , '0', 'size=30', '', '', 'hospital number', ''), 
('ClinicalAnnotation', '0', 'misc_identifiers', 'RAMQ', 'input',  NULL , '0', 'size=30', '', '', 'RAMQ', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE alias='procure_miscidentifiers_for_participant_summary'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='misc_identifiers' AND `field`='hospital_number'),
'0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_miscidentifiers_for_participant_summary'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='misc_identifiers' AND `field`='RAMQ'), 
'0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_miscidentifiers_for_participant_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='misc_identifiers' AND `field`='hospital_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_miscidentifiers_for_participant_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='misc_identifiers' AND `field`='RAMQ' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `flag_confidential`='1' WHERE model='0' AND tablename='misc_identifiers' AND field='hospital_number' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `flag_confidential`='1' WHERE model='0' AND tablename='misc_identifiers' AND field='RAMQ' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('delete collection link','Delete Collection Link','Supprimer Lien à la Collection');

TRUNCATE template_nodes;
INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`) VALUES
(1, NULL, 1, 5, 4, 1),
(4, NULL, 2, 5, 2, 1),
(5, 4, 2, 1, 3, 3),
(6, 4, 2, 5, 10, 1),
(7, 6, 2, 1, 17, 5),
(8, NULL, 2, 5, 2, 1),
(9, 8, 2, 1, 3, 1),
(10, NULL, 2, 5, 2, 1),
(11, 10, 2, 1, 3, 3),
(14, NULL, 3, 5, 3, 1),
(15, 14, 3, 1, 9, 8),
(17, 10, 2, 5, 9, 1),
(18, 17, 2, 1, 16, 5),
(19, 10, 2, 5, 8, 1),
(20, 19, 2, 1, 37, 3),
(21, 1, 1, 1, 4, 1),
(22, 1, 1, 5, 15, 1),
(23, 22, 1, 1, 14, 2),
(24, 10, 2, 1, 11, 1);

SET @coll_id = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 =  @coll_id AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ConsentMaster','DiagnosisMaster','TreatmentMaster','EventMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 =  @coll_id AND id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ConsentMaster','DiagnosisMaster','TreatmentMaster','EventMaster'));

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(24, 17, 8);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(29);

ALTER TABLE storage_masters 
  MODIFY `short_label` varchar(30) DEFAULT NULL,
  MODIFY `selection_label` varchar(120) DEFAULT '';
ALTER TABLE storage_masters_revs
  MODIFY `short_label` varchar(30) DEFAULT NULL,
  MODIFY `selection_label` varchar(120) DEFAULT '';
  
UPDATE storage_controls SET horizontal_increment = '0' WHERE storage_type = 'boxPAR';

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="1" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paraffin" AND language_alias="paraffin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="1" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="frozen" AND language_alias="frozen");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="OCT" AND spv.language_alias="oct solution";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="ISO" AND spv.language_alias="ISO";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="ISO+OCT" AND spv.language_alias="ISO+OCT";
DELETE FROM structure_permissible_values WHERE value="OCT" AND language_alias="oct solution";
DELETE FROM structure_permissible_values WHERE value="ISO" AND language_alias="ISO";
DELETE FROM structure_permissible_values WHERE value="ISO+OCT" AND language_alias="ISO+OCT";

ALTER TABLE ad_blocks ADD COLUMN procure_freezing_type VARCHAR(50) DEFAULT NULL AFTER block_type;
ALTER TABLE ad_blocks_revs ADD COLUMN procure_freezing_type VARCHAR(50) DEFAULT NULL AFTER block_type;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_freezing_type", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES ("ISO","ISO"),("ISO+OCT","ISO+OCT");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_freezing_type"), (SELECT id FROM structure_permissible_values WHERE value="ISO" AND language_alias="ISO"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_freezing_type"), (SELECT id FROM structure_permissible_values WHERE value="ISO+OCT" AND language_alias="ISO+OCT"), "4", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'procure_freezing_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_freezing_type') , '0', '', '', '', 'freezing type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_freezing_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_freezing_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='freezing type' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO i18n (id,en,fr) VALUES ('only frozen blocks can be associated to a freezing type','Only frozen blocks can be associated to a freezing type','Seuls les bloques congelés peuvent être associés à une méthode de congélation');

UPDATE structure_fields SET  `language_label`='' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='tumour_location_right_anterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='anterior' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='tumour_location_left_anterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='tumour_location_right_posterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='posterior' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='tumour_location_left_posterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='51', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_right_anterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='50', `language_heading`='2) tumour location' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_left_anterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='53' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_right_posterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='52' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_left_posterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='extra_prostatic_extension_right_anterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='anterior' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='extra_prostatic_extension_left_anterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='extra_prostatic_extension_right_posterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='posterior' WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='extra_prostatic_extension_left_posterior' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='103', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_right_anterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='102', `language_heading`='7) location of extra-prostatic extension' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_left_anterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='105' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_right_posterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='104' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_left_posterior' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


