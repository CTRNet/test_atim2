
UPDATE misc_identifier_controls SET autoincrement_name = '', misc_identifier_format = '' WHERE id IN (1,2);

ALTER TABLE collections 
  ADD COLUMN `chus_collection_date` date DEFAULT NULL,
  ADD COLUMN `chus_collection_date_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE collections_revs 
  ADD COLUMN `chus_collection_date` date DEFAULT NULL,
  ADD COLUMN `chus_collection_date_accuracy` char(1) NOT NULL DEFAULT '';  

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'chus_collection_date', 'date',  NULL , '0', '', '', '', 'collection datetime', '');
SET @new_structure_field_id =(SELECT id FROM structure_fields WHERE field = 'chus_collection_date' AND model = 'Collection');
SET @collection_datetime_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'collection_datetime' AND model = 'Collection');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @new_structure_field_id, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @collection_datetime_structure_field_id);
UPDATE structure_formats SET flag_add=0, flag_add_readonly=0, flag_edit=0, flag_edit_readonly=0, flag_search=0, flag_search_readonly=0, flag_addgrid=0, flag_addgrid_readonly=0, flag_editgrid=0, flag_editgrid_readonly=0, flag_batchedit=0, flag_batchedit_readonly=0, flag_index=0, flag_detail=0, flag_summary=0 WHERE structure_field_id = @collection_datetime_structure_field_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'chus_collection_date', 'date',  NULL , '0', '', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='chus_collection_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', 'view_collections', 'chus_collection_date', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') , '0', '', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='chus_collection_date' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_adv_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='collection_datetime' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') AND `flag_confidential`='0');

ALTER TABLE specimen_details 
  ADD COLUMN `chus_collection_datetime` datetime DEFAULT NULL,
  ADD COLUMN `chus_collection_datetime_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE specimen_details_revs 
  ADD COLUMN `chus_collection_datetime` datetime DEFAULT NULL,
  ADD COLUMN `chus_collection_datetime_accuracy` char(1) NOT NULL DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'chus_collection_datetime', 'datetime',  NULL , '0', '', '', '', 'specimen collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='chus_collection_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen collection datetime' AND `language_tag`=''), '1', '299', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='399' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('specimen collection datetime','Specimen Collection Date','Date de collection du spécimen'),
('at least one specimen will have a collection date different than the date set to the collection', 'At least one specimen will have a collection date different than the date set to the collection','Au moins un spécimen aura une date différente de la date assignée à la collection');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs%';

UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');






