INSERT INTO i18n (id, en, fr) VALUES
('core_installname', 'Lady Davis - Ovary', 'Lady Davis - Ovaire'),
("sample system code", "Sample system code", "Code système d'échantillon"),
("aliquot system code", "Aliquot system code", "Code système d'aliquot"),
("concentration", "Concentration", "Concentration");

UPDATE users SET flag_active=1 WHERE id=1;

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(3, "clinic surgery room", "Clinic surgery room", "Salle de chirurgie clinique"),
(3, "radiology", "Radiology", "Radiologie");


-- hide bank from collections
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- hide sop from collections
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

-- hide all references to SampleMaster SOP
UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', flag_index=0, flag_search=0, flag_detail=0 
WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE model='SampleMaster' AND field='sop_master_id');

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(1, "Marie-Claude Beauchamp", "Marie-Claude Beauchamp", "Marie-Claude Beauchamp"),
(1, "Amber Yasmeen", "Amber Yasmeen", "Amber Yasmeen"),
(1, "Eric Segal", "Eric Segal", "Eric Segal");


-- sample_code at the end of every forms
CREATE TABLE tmp
(SELECT sf1.id, MAX(sf2.display_column) AS display_column, MAX(sf2.display_order) AS display_order FROM structure_formats AS sf1 
INNER JOIN structure_formats AS sf2 ON sf1.structure_id=sf2.structure_id
WHERE sf1.structure_field_id IN (SELECT id FROM structure_fields WHERE field='sample_code')
GROUP BY sf1.structure_id);

UPDATE structure_formats AS sf1 
INNER JOIN tmp AS sf2 USING(id)
SET sf1.display_column=sf2.display_column, sf1.display_order=sf2.display_order + 1;

DROP TABLE tmp;

-- update sample code label to sample system code
UPDATE structure_fields SET language_label='sample system code' WHERE field='sample_code';

-- Supplier departments
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(4, "clinic", "Clinic", "Clinique"),
(4, "surgery room", "Surgery room", "Salle de chirurgie"),
(4, "radiology", "Radiology", "Radiologie"),
(4, "pathology", "Pathology", "Pathologie");

-- hiding lab book fields from samples/aliquots
UPDATE structure_formats
SET flag_add=0, flag_edit=0, flag_addgrid=0, flag_editgrid=0, flag_search=0, flag_index=0, flag_detail=0, flag_batchedit=0, flag_summary=0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN('lab_book_master_code', 'lab_book_master_id', 'sync_with_lab_book', 'sync_with_lab_book_now'));

-- blood types
UPDATE structure_value_domains_permissible_values AS svdpv 
LEFT JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id
SET flag_active=0 
WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='blood_type')
 AND spv.language_alias NOT IN('EDTA', 'heparin');

-- tissues source custom
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc ldov tissues sources', 1, 20);

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(6, "ovary", "Ovary", "Ovaire"),
(6, "peritoneum", "Peritoneum", "Péritoine"),
(6, "fallopian tube", "Fallopian tube", "Trompes de Fallope"),
(6, "vagina", "Vagina", "Vagin"),
(6, "uterus", "Uterus", "Utérus"),
(6, "omentum", "Omentum", "Omentum"),
(6, "cervix", "Cervix", "Col de l'utérus"),
(6, "lymph node", "Lymph node", "Ganglion lymphatique"),
(6, "endometrium", "Endometrium", "Endometrium");

UPDATE structure_value_domains 
SET source="StructurePermissibleValuesCustom::getCustomDropdown('qc ldov tissues sources')"
WHERE domain_name='tissue_source_list';

-- tissue type
ALTER TABLE sd_spe_tissues
 ADD COLUMN qc_ldov_tissue_type VARCHAR(20) NOT NULL DEFAULT '';
ALTER TABLE sd_spe_tissues_revs
 ADD COLUMN qc_ldov_tissue_type VARCHAR(20) NOT NULL DEFAULT '';
 
INSERT INTO structure_value_domains (domain_name, source) VALUES
('qc_ldov_tissue_type', "StructurePermissibleValuesCustom::getCustomDropdown('qc ldov tissues types')");

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc ldov tissues types', 1, 20);

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(7, 'tumor', 'Tumor', 'Tumeur'),
(7, 'benin', 'Benin', 'Bénin'),
(7, 'normal', 'Normal', 'Normal'),
(7, 'other', 'Other', 'Autre'); 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'qc_ldov_tissue_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_tissue_type') , '0', '', '', '', 'tissue type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_ldov_tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue type' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

-- tissue biopsy
ALTER TABLE sd_spe_tissues
 ADD COLUMN qc_ldov_biopsy CHAR(1) NOT NULL DEFAULT 'u';
ALTER TABLE sd_spe_tissues_revs
 ADD COLUMN qc_ldov_biopsy CHAR(1) NOT NULL DEFAULT 'u';
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_ldov_yes_no_unknown', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("y", "yes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_yes_no_unknown"),  (SELECT id FROM structure_permissible_values WHERE value="y" AND language_alias="yes"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("n", "no");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_yes_no_unknown"),  (SELECT id FROM structure_permissible_values WHERE value="n" AND language_alias="no"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("u", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_yes_no_unknown"),  (SELECT id FROM structure_permissible_values WHERE value="u" AND language_alias="unknown"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'qc_ldov_biopsy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') , '0', '', 'n', '', 'biopsy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_ldov_biopsy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='biopsy' AND `language_tag`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_ldov_biopsy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')), 'notEmpty', 'value is required');

-- tissue size, weight, patho
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- serums hemolosis signs
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', '', 'hemolysis_signs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') , '0', '', 'u', '', 'hemolysis signs', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='hemolysis_signs' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_serums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='hemolysis_signs' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT `id` FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='hemolysis_signs' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')), 'notEmpty', 'value is required');

-- barcode at the end of the form + readonly
CREATE TABLE tmp
(SELECT sf1.id, MAX(sf2.display_column) AS display_column, MAX(sf2.display_order) AS display_order FROM structure_formats AS sf1 
INNER JOIN structure_formats AS sf2 ON sf1.structure_id=sf2.structure_id
WHERE sf1.structure_field_id IN (SELECT id FROM structure_fields WHERE field='barcode' AND model IN('AliquotMaster', 'AliquotMasterChildren', 'ViewAliquot'))
GROUP BY sf1.structure_id);

UPDATE structure_formats AS sf1 
INNER JOIN tmp AS sf2 USING(id)
SET sf1.display_column=sf2.display_column, sf1.display_order=sf2.display_order + 1, sf1.flag_add=0, sf1.flag_edit_readonly='1', sf1.flag_addgrid=0, sf1.flag_editgrid_readonly='1', sf1.flag_batchedit_readonly='1';

DROP TABLE tmp;

-- rename barcode to aliquot system code
UPDATE structure_fields
SET language_label='aliquot system code'
WHERE field='barcode' AND model IN('AliquotMaster', 'AliquotMasterChildren', 'ViewAliquot');

-- blood cell tube cloth
ALTER TABLE ad_tubes
 ADD COLUMN qc_ldov_cloth CHAR(1) DEFAULT 'u';
ALTER TABLE ad_tubes_revs
 ADD COLUMN qc_ldov_cloth CHAR(1) DEFAULT 'u';

INSERT INTO structures(`alias`) VALUES ('qc_ldov_cloth');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_ldov_cloth', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') , '0', '', 'u', '', 'cloth', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_cloth'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_ldov_cloth' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='u' AND `language_help`='' AND `language_label`='cloth' AND `language_tag`=''), '1', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO aliquot_controls (aliquot_type, aliquot_type_precision, form_alias, detail_tablename, volume_unit, comment, display_order, databrowser_label) VALUES
('tube', 'cells', 'aliquot_masters,ad_der_cell_tubes_incl_ml_vol,qc_ldov_cloth', 'ad_tubes', 'ml', 'Derivative tube requiring volume in ml specific for cells', 0, 'tube');

UPDATE sample_to_aliquot_controls SET aliquot_control_id=16 WHERE sample_control_id=7;

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_ldov_cloth' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='u' AND `language_help`='' AND `language_label`='cloth' AND `language_tag`=''), 'notEmpty', 'value is required');

-- protein tube concentration 
INSERT INTO structures(`alias`) VALUES ('qc_ldov_protein_tube');
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, type, flag_override_setting, setting, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_summary, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail) 
(SELECT (SELECT id FROM structures WHERE alias='qc_ldov_protein_tube'), structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, type, flag_override_setting, setting, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_summary, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'concentration', 'float_positive',  NULL , '0', '', '', '', 'concentration', ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'concentration_unit', 'input',  NULL , '0', '', 'ul', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_protein_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='concentration' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_ldov_protein_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_unit' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='ul' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '1');
UPDATE structure_formats SET `display_order`='77' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_ldov_protein_tube') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO aliquot_controls (aliquot_type, aliquot_type_precision, form_alias, detail_tablename, volume_unit, comment, display_order, databrowser_label) VALUES
('tube', 'derivative tube (ml)', 'aliquot_masters,qc_ldov_protein_tube', 'ad_tubes', 'ml', 'Derivative tube requiring volume in ml + concentration in ul', 0, 'tube');

UPDATE sample_to_aliquot_controls SET aliquot_control_id=17 WHERE sample_control_id=119;

-- tissue concentration
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotMaster', 'ad_tubes', 'concentration', 'float_positive',  NULL , '0', '', '', '', 'concentration', ''), 
('Inventorymanagement', 'AliquotMaster', 'ad_tubes', 'concentration_unit', 'input',  NULL , '0', '', 'ul', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='ad_tubes' AND `field`='concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='concentration' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='ad_tubes' AND `field`='concentration_unit' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='ul' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1');
UPDATE structure_formats SET `display_order`='73' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- protein extraction method
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc ldov protein extraction method', 1, 20);

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(8, "homogenization", "Homogenization", "Homogénéisation"),
(8, "lysis buffer", "Lysis buffer", "Tampon de lyse");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('qc_ldov_protein_extraction_method', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('qc ldov protein extraction method')");

ALTER TABLE sd_der_proteins
 ADD COLUMN qc_ldov_extraction_method VARCHAR(20) NOT NULL DEFAULT '';
ALTER TABLE sd_der_proteins_revs
 ADD COLUMN qc_ldov_extraction_method VARCHAR(20) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('qc_ldov_protein_extraction_method');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_der_proteins', 'qc_ldov_extraction_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_protein_extraction_method') , '0', '', '', '', 'extraction method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_protein_extraction_method'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_proteins' AND `field`='qc_ldov_extraction_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_protein_extraction_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='extraction method' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');
UPDATE sample_controls SET form_alias=CONCAT(form_alias, ',qc_ldov_protein_extraction_method') WHERE id=119;
