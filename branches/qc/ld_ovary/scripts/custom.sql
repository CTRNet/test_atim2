INSERT INTO i18n (id, en, fr) VALUES
('core_installname', 'Lady Davis - Ovary', 'Lady Davis - Ovaire'),
("sample system code", "Sample System Code", "Code système d'échantillon"),
("aliquot system code", "Aliquot system code", "Code système d'aliquot"),
("concentration", "Concentration", "Concentration");

UPDATE users SET flag_active=1 WHERE id=1;

DELETE FROM structure_permissible_values_customs WHERE control_id = 3;
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(3, "surgery room", "Surgery Room", "Salle de chirurgie"),
(3, "clinic", "Clinic", "Clinique"),
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
 ADD COLUMN qc_ldov_biopsy CHAR(1) NOT NULL DEFAULT 'n';
ALTER TABLE sd_spe_tissues_revs
 ADD COLUMN qc_ldov_biopsy CHAR(1) NOT NULL DEFAULT 'n';
 
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
('Inventorymanagement', 'SampleDetail', '', 'hemolysis_signs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') , '0', '', 'n', '', 'hemolysis signs', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='hemolysis_signs' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_serums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='hemolysis_signs' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT `id` FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='hemolysis_signs' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')), 'notEmpty', 'value is required');

-- blood cell tube clot
ALTER TABLE ad_tubes
 ADD COLUMN qc_ldov_clot CHAR(1) DEFAULT 'n';
ALTER TABLE ad_tubes_revs
 ADD COLUMN qc_ldov_clot CHAR(1) DEFAULT 'n';

INSERT INTO structures(`alias`) VALUES ('qc_ldov_clot');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_ldov_clot', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown') , '0', '', 'n', '', 'clot', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_clot'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_ldov_clot' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='clot' AND `language_tag`=''), '1', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO aliquot_controls (aliquot_type, aliquot_type_precision, form_alias, detail_tablename, volume_unit, comment, display_order, databrowser_label) VALUES
('tube', 'blood cell', 'aliquot_masters,ad_der_cell_tubes_incl_ml_vol,qc_ldov_clot', 'ad_tubes', 'ml', 'Blood cells tube', 0, 'tube');

UPDATE sample_to_aliquot_controls SET aliquot_control_id=16 WHERE sample_control_id=7;

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_ldov_clot' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='clot' AND `language_tag`=''), 'notEmpty', 'value is required');

-- protein tube add concentration + volume
UPDATE sample_to_aliquot_controls SET aliquot_control_id=(select id from aliquot_controls WHERE form_alias like '%ad_der_tubes_incl_ul_vol_and_conc%') WHERE sample_control_id=119;

-- tissue concentration
INSERT INTO aliquot_controls (aliquot_type, aliquot_type_precision, form_alias, detail_tablename, volume_unit, comment, display_order, databrowser_label) VALUES
('tube', 'tissue tube', 'aliquot_masters,qc_ldov_tissue_tube', 'ad_tubes', '', 'Tissue tube', 0, 'tube');
SET @last_id = LAST_INSERT_ID();
UPDATE sample_to_aliquot_controls SET aliquot_control_id=@last_id WHERE sample_control_id=(SELECT id FROM sample_controls WHERE sample_type LIKE 'tissue')
AND aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE aliquot_type LIKE 'tube');

INSERT INTO structures(`alias`) VALUES ('qc_ldov_tissue_tube');
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, type, flag_override_setting, setting, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_summary, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail) 
(SELECT (SELECT id FROM structures WHERE alias='qc_ldov_tissue_tube'), structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, type, flag_override_setting, setting, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_summary, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_tissue_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='concentration'), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_ldov_tissue_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_unit' ), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

-- tissue storage method
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('qc_ldov_tissue_storage_method', '', '', NULL);
SET @id = LAST_INSERT_ID();
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("snap frozen", "snap frozen");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES(@id,  (SELECT id FROM structure_permissible_values WHERE value="snap frozen" AND language_alias="snap frozen"), "2", "1");

ALTER TABLE aliquot_masters
 ADD COLUMN qc_ldov_storage_method VARCHAR(30) NOT NULL DEFAULT '' AFTER storage_coord_y;
ALTER TABLE aliquot_masters_revs
 ADD COLUMN qc_ldov_storage_method VARCHAR(30) NOT NULL DEFAULT '' AFTER storage_coord_y;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'qc_ldov_storage_method', 'select', @id , '0', '', '', '', 'storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_tissue_tube'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='qc_ldov_storage_method'), '1', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0');

Insert Into i18n (id,en,fr) VALUES ('storage method','Storage Method','Méthode d''entreposage'),('snap frozen','Snap Frozen','Congélation rapide');

-- protein extraction method
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc ldov protein extraction method', 1, 20);

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(8, "homogenization", "Homogenization", "Homogénéisation"),
(8, "lysis buffer", "Lysis buffer", "Tampon de lyse");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('qc_ldov_protein_extraction_method', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('qc ldov protein extraction method')");

ALTER TABLE sd_der_proteins
 ADD COLUMN qc_ldov_extraction_method VARCHAR(30) NOT NULL DEFAULT '';
ALTER TABLE sd_der_proteins_revs
 ADD COLUMN qc_ldov_extraction_method VARCHAR(30) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('qc_ldov_protein_extraction_method');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_der_proteins', 'qc_ldov_extraction_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_protein_extraction_method') , '0', '', '', '', 'extraction method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_ldov_protein_extraction_method'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_proteins' AND `field`='qc_ldov_extraction_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_protein_extraction_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='extraction method' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');
UPDATE sample_controls SET form_alias=CONCAT(form_alias, ',qc_ldov_protein_extraction_method') WHERE id=119;

--

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '1', sfo.flag_edit_readonly = '1',
sfo.flag_search = '1', sfo.flag_search_readonly = '0',
sfo.flag_index = '1', sfo.flag_detail = '1',
language_heading = 'system data',
sfo.display_column = '3', sfo.display_order = '98'
WHERE sfi.field IN ('participant_identifier') 
AND str.alias IN ('participants')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('system data', 'System Data', 'Données système');

REPLACE INTO i18n (id, en, fr) VALUES
('participant identifier','Participant System Code','Code système participant'); 

UPDATE structure_formats SET `language_heading`='clin_demographics' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='first_name' );

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='first_name' ), 'notEmpty', '', 'value is required'),
(null, (SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='last_name' ), 'notEmpty', '', 'value is required');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='middle_name' AND type='input' AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model='MiscIdentifier' AND tablename='misc_identifiers' 
AND field IN ('notes','effective_date','identifier_abrv','expiry_date'));

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' , `flag_search`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants')
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='title' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='person title'));

UPDATE `banks` SET `name` = 'LD-Ovary' WHERE `banks`.`id` = 1;

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id' ), 'notEmpty', '', 'value is required'),
(null, (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='bank_id' ), 'notEmpty', '', 'value is required');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_summary`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='bank_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='banks'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', flag_index=0, flag_search=0, flag_detail=0 
WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE field='sop_master_id');

UPDATE structure_formats SET `language_heading`='system data' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field='sample_code');

DELETE FROM structure_value_domains_permissible_values WHERE flag_active = 0;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("gel", "gel");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"),  (SELECT id FROM structure_permissible_values WHERE value="gel" AND language_alias="gel"), "2", "1");

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('gel', 'Gel', 'Gel');

UPDATE structure_value_domains SET source = NULL WHERE domain_name = 'qc_ldov_tissue_type';
DELETE FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'qc ldov tissues types');
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'qc ldov tissues types';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("normal", "normal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_tissue_type"),  
(SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("benin", "benin");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_tissue_type"),  
(SELECT id FROM structure_permissible_values WHERE value="benin" AND language_alias="benin"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("tumoral", "tumoral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_tissue_type"),  
(SELECT id FROM structure_permissible_values WHERE value="tumoral" AND language_alias="tumoral"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_ldov_tissue_type"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('benin', 'Benin', 'Bénin'),
('tumoral', 'Tumoral', 'Tumoral'),
('tissue type','Type','Type'),
('biopsy','Biopsy','Biopsie'),
('ca125','CA125','CA125');

UPDATE structure_formats SET `display_order`='40' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='qc_ldov_biopsy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_ldov_yes_no_unknown'));

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name like 'laboratory sites'), 'laboratory', 'Lab', 'Lab'); 

ALTER TABLE sd_der_cell_cultures
 ADD COLUMN qc_ca_125 DECIMAL(8,3) NULL AFTER `cell_passage_number`;
ALTER TABLE sd_der_cell_cultures_revs
 ADD COLUMN qc_ca_125 DECIMAL(8,3) NULL AFTER `cell_passage_number`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'qc_ca_125', 'ca125', '', 'float', 'size=5', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='qc_ca_125' AND `language_label`='ca125' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_cell_cultures') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));

UPDATE parent_to_derivative_sample_controls SET flag_active=0 WHERE id IN(25, 4, 143, 101, 102, 140);
UPDATE parent_to_derivative_sample_controls SET flag_active=0 WHERE id IN(23, 136);

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`,`derivative_sample_control_id`,`flag_active`)
VALUES 
((SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 1),
((SELECT id FROM sample_controls WHERE sample_type = 'ascite cell'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 1),
((SELECT id FROM sample_controls WHERE sample_type = 'peritoneal wash cell'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 1),
((SELECT id FROM sample_controls WHERE sample_type = 'cystic fluid cell'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 1),
((SELECT id FROM sample_controls WHERE sample_type = 'blood cell'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 1);

UPDATE parent_to_derivative_sample_controls SET flag_active = 1
WHERE parent_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell culture')
AND derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(130);

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('extraction method','Extraction Method','Méthode d''extraction');

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/material/%' OR use_link LIKE '/sop/%' ;
UPDATE menus SET flag_active = '0'
WHERE `use_link` LIKE '/study/%' AND `use_link` NOT LIKE '/study/study_summaries%';

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/labbook/%' OR use_link LIKE '/protocol/%' OR use_link LIKE '/drug/%' ;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field NOT IN ('title', 'summary') 
AND str.alias = 'studysummaries'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

ALTER TABLE aliquot_masters
 ADD COLUMN qc_ldov_aliquot_label VARCHAR(60) NOT NULL DEFAULT '' AFTER barcode;
ALTER TABLE aliquot_masters_revs
 ADD COLUMN qc_ldov_aliquot_label VARCHAR(60) NOT NULL DEFAULT '' AFTER barcode;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'qc_ldov_aliquot_label', 'qc ldov aliquot label', '', 'input', '', '',  NULL , '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'ViewAliquot', '', 'qc_ldov_aliquot_label', 'qc ldov aliquot label', '', 'input', '', '',  NULL , '');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='qc_ldov_aliquot_label' ), 'notEmpty', '', 'value is required');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('qc ldov aliquot label', 'Label', 'Étiquette');

SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'qc_ldov_aliquot_label');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
SELECT 
sf.structure_id, @structure_field_id, sf.display_column, (sf.display_order -1), sf.language_heading, sf.flag_override_label, sf.language_label, sf.flag_override_tag, sf.language_tag, sf.flag_override_help, sf.language_help, sf.flag_override_type, sf.type, sf.flag_override_setting, sf.setting, sf.flag_override_default, sf.default, 
sf.flag_add, sf.flag_add_readonly, sf.flag_edit, sf.flag_edit_readonly, sf.flag_search, sf.flag_search_readonly, sf.flag_addgrid, sf.flag_addgrid_readonly, sf.flag_editgrid, sf.flag_editgrid_readonly, sf.flag_batchedit, sf.flag_batchedit_readonly, sf.flag_index, sf.flag_detail, sf.flag_summary
FROM structure_formats AS sf INNER JOIN structure_fields AS bc_field ON bc_field.id = sf.structure_field_id 
WHERE  bc_field.model = 'AliquotMaster' AND bc_field.field = 'barcode';

SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewAliquot' AND field = 'qc_ldov_aliquot_label');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT 
sf.structure_id, @structure_field_id, sf.display_column, (sf.display_order -1), sf.language_heading, sf.flag_override_label, sf.language_label, sf.flag_override_tag, sf.language_tag, sf.flag_override_help, sf.language_help, sf.flag_override_type, sf.type, sf.flag_override_setting, sf.setting, sf.flag_override_default, sf.default, 
sf.flag_add, sf.flag_add_readonly, sf.flag_edit, sf.flag_edit_readonly, sf.flag_search, sf.flag_search_readonly, sf.flag_addgrid, sf.flag_addgrid_readonly, sf.flag_editgrid, sf.flag_editgrid_readonly, sf.flag_batchedit, sf.flag_batchedit_readonly, sf.flag_index, sf.flag_detail, sf.flag_summary
FROM structure_formats AS sf INNER JOIN structure_fields AS bc_field ON bc_field.id = sf.structure_field_id 
WHERE  bc_field.model = 'ViewAliquot' AND bc_field.field = 'barcode');

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

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.qc_ldov_aliquot_label,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

DROP VIEW IF EXISTS view_aliquot_uses;
CREATE VIEW view_aliquot_uses AS 

SELECT 
CONCAT(source.id, 1) AS id,
aliq.id AS aliquot_master_id,
'sample derivative creation' AS use_definition, 
samp.sample_code AS use_code,
'' AS use_details,
source.used_volume,
aliq.aliquot_volume_unit,
der.creation_datetime AS use_datetime,
der.creation_by AS used_by,
source.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllSourceAliquots|',samp.collection_id ,'|',samp.id) AS detail_url,
samp2.id AS sample_master_id,
samp2.collection_id AS collection_id
FROM source_aliquots AS source
INNER JOIN sample_masters AS samp ON samp.id = source.sample_master_id  AND samp.deleted != 1
INNER JOIN derivative_details AS der ON samp.id = der.sample_master_id  AND der.deleted != 1
INNER JOIN aliquot_masters AS aliq ON aliq.id = source.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp2 ON samp2.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE source.deleted != 1

UNION ALL

SELECT 
CONCAT(realiq.id, 2) AS id,
aliq.id AS aliquot_master_id,
'realiquoted to' AS use_definition, 
CONCAT(child.qc_ldov_aliquot_label, ' - ', child.barcode) AS use_code,
'' AS use_details,
realiq.parent_used_volume AS used_volume,
aliq.aliquot_volume_unit,
realiq.realiquoting_datetime AS use_datetime,
realiq.realiquoted_by AS used_by,
realiq.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllRealiquotedParents|',child.collection_id,'|',child.sample_master_id,'|',child.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM realiquotings AS realiq
INNER JOIN aliquot_masters AS aliq ON aliq.id = realiq.parent_aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_masters AS child ON child.id = realiq.child_aliquot_master_id AND child.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE realiq.deleted != 1

UNION ALL

SELECT 
CONCAT(tested.id, 3) AS id,
aliq.id AS aliquot_master_id,
'quality control' AS use_definition, 
qc.qc_code AS use_code,
'' AS use_details,
tested.used_volume,
aliq.aliquot_volume_unit,
qc.date AS use_datetime,
qc.run_by AS used_by,
tested.created,
CONCAT('|inventorymanagement|quality_ctrls|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',qc.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM quality_ctrl_tested_aliquots AS tested
INNER JOIN aliquot_masters AS aliq ON aliq.id = tested.aliquot_master_id AND aliq.deleted != 1
INNER JOIN quality_ctrls AS qc ON qc.id = tested.quality_ctrl_id AND qc.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE tested.deleted != 1

UNION ALL

SELECT 
CONCAT(item.id, 4) AS id,
aliq.id AS aliquot_master_id,
'aliquot shipment' AS use_definition, 
sh.shipment_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
sh.datetime_shipped AS use_datetime,
sh.shipped_by AS used_by,
sh.created,
CONCAT('|order|shipments|detail|',sh.order_id,'|',sh.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM order_items AS item
INNER JOIN aliquot_masters AS aliq ON aliq.id = item.aliquot_master_id AND aliq.deleted != 1
INNER JOIN shipments AS sh ON sh.id = item.shipment_id AND sh.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE item.deleted != 1

UNION ALL

SELECT 
CONCAT(alr.id, 5) AS id,
aliq.id AS aliquot_master_id,
'specimen review' AS use_definition, 
spr.review_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
spr.review_date AS use_datetime,
'' AS used_by,
alr.created,
CONCAT('|inventorymanagement|specimen_reviews|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',spr.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_review_masters AS alr
INNER JOIN aliquot_masters AS aliq ON aliq.id = alr.aliquot_master_id AND aliq.deleted != 1
INNER JOIN specimen_review_masters AS spr ON spr.id = alr.specimen_review_master_id AND spr.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE alr.deleted != 1

UNION ALL

SELECT 
CONCAT(aluse.id, 6) AS id,
aliq.id AS aliquot_master_id,
'internal use' AS use_definition, 
aluse.use_code,
aluse.use_details,
aluse.used_volume,
aliq.aliquot_volume_unit,
aluse.use_datetime,
aluse.used_by,
aluse.created,
CONCAT('|inventorymanagement|aliquot_masters|detailAliquotInternalUse|',aliq.id,'|',aluse.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_internal_uses AS aluse
INNER JOIN aliquot_masters AS aliq ON aliq.id = aluse.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE aluse.deleted != 1;

SET @display_order = (SELECT display_order FROM structure_formats 
WHERE structure_id = (SELECT id FROM structures WHERE  alias='aliquot_masters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'barcode' AND model IN('AliquotMaster')));

UPDATE structure_formats
SET display_order = (@display_order + 1)
WHERE structure_id IN (SELECT id FROM structures WHERE  alias LIKE 'ad_%')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'created' AND model IN('AliquotMaster'));

UPDATE structure_formats
SET language_heading = 'system data'
WHERE structure_id IN (SELECT id FROM structures WHERE  alias = 'aliquot_masters')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'barcode' AND model IN('AliquotMaster'));

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('clot','Clot','Caillot');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(144);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(23, 2, 3, 8);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(17, 7, 5);

UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(1, 31, 30);

UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );

UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE specimen_review_controls SET flag_active = 0;

UPDATE structure_formats SET `flag_add`='1', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
