-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Disable xenograft and cord blood
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(193, 200, 203, 194);

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Warning message when delete drugs
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr) VALUES ('study/project is assigned to a participant', 
'Your data cannot be deleted! This study/project is linked to a participant.',
"Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un patient.");

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Add study in aliquot view
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Add identifiers field to add participant form
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'ovcare_personal_health_number_identifier_value', 'input',  NULL , '1', '', '', '', 'personal health number', ''), 
('', '0', '', 'ovcare_bcca_number_identifier_value', 'input',  NULL , '1', '', '', '', 'bcca number', ''), 
('', '0', '', 'ovcare_medical_record_number_identifier_value', 'input',  NULL , '1', '', '', '', 'medical record number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_personal_health_number_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='personal health number' AND `language_tag`=''), '3', '30', 'misc identifiers', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_bcca_number_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcca number' AND `language_tag`=''), '3', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_medical_record_number_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medical record number' AND `language_tag`=''), '3', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Clean up reception by = 'margaret luk'
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE specimen_details SET reception_by = 'Margaret Luk' WHERE reception_by = 'margaret luk';
UPDATE specimen_details_revs SET reception_by = 'Margaret Luk' WHERE reception_by = 'margaret luk';

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Collection Template
-- ---------------------------------------------------------------------------------------------------------------------------------------

-- Blood creation

INSERT INTO structures(`alias`) VALUES ('ovcare_blood_template_init_structure');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'ovcare_collected_tube_nbr_blood_edta', 'integer_positive',  NULL , '0', 'size=5', '', '', 'collected tubes nbr', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_blood_edta', 'float_positive',  NULL , '0', 'size=5', '', '', 'collected volume', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_unit_blood_edta', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') , '0', '', '', '', '', ''), 

('InventoryManagement', '0', '', 'ovcare_collected_tube_nbr_blood_serum', 'integer_positive',  NULL , '0', 'size=5', '', '', 'collected tubes nbr', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_blood_serum', 'float_positive',  NULL , '0', 'size=5', '', '', 'collected volume', ''), 
('InventoryManagement', '0', '', 'ovcare_collected_volume_unit_blood_serum', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') , '0', '', '', '', '', ''), 

('InventoryManagement', '0', '', 'ovcare_ischemia_time_mn_plasma_serum', 'integer_positive',  NULL , '0', 'size=5', '', '', 'ischemia time mn (plasma serum)', ''), 
('InventoryManagement', '0', '', 'ovcare_ischemia_time_mn_buffy_coat', 'integer_positive',  NULL , '0', 'size=5', '', '', 'ischemia time mn (buffy coat)', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supplier dept' AND `language_tag`=''), '1', '1', 'blood', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_reception_datetime_defintion' AND `language_label`='reception date' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='time_at_room_temp_mn_help' AND `language_label`='time at room temp (mn)' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_tube_nbr_blood_edta' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected tubes nbr' AND `language_tag`=''), '1', '10', 'edta', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_blood_edta' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_unit_blood_edta' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_tube_nbr_blood_serum' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected tubes nbr' AND `language_tag`=''), '1', '20', 'serum', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_blood_serum' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_collected_volume_unit_blood_serum' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`=''), '1', '50', 'derivatives', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_ischemia_time_mn_plasma_serum' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ischemia time mn (plasma serum)' AND `language_tag`=''), '1', '51', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_ischemia_time_mn_buffy_coat' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ischemia time mn (buffy coat)' AND `language_tag`=''), '1', '51', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET flag_addgrid = '0' WHERE structure_id = (SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure');

REPLACE INTO i18n (id, en)
VALUES 
('edta', 'EDTA');
INSERT INTO i18n (id, en)
VALUES 
('ischemia time mn (plasma serum)', 'Ischemia Time mn (Plasma & Serum)'),
('ischemia time mn (buffy coat)', 'Ischemia Time mn (Buffy Coat)');

-- Tissue creation

INSERT INTO structures(`alias`) VALUES ('ovcare_tissue_template_init_structure');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '1', '200', 'specimen data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_reception_datetime_defintion' AND `language_label`='reception date' AND `language_tag`=''), '1', '300', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_tissue_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='block type' AND `language_tag`=''), '1', '700', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Collection Template
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6xxx' WHERE version_number = '2.6.4';




