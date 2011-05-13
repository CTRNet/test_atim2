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

UPDATE structure_formats SET  `display_order`='1', `flag_add`='1', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='0', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_column`='0', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='1', `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='1', `flag_add`='0', `flag_edit_readonly`='0', `flag_addgrid`='1', `flag_batchedit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='marital_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status'));

INSERT INTO misc_identifier_controls(misc_identifier_name, misc_identifier_name_abbrev, flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant) VALUES
("régime d'assurance maladie du québec", 'RAMQ', 1, 4, '', '', 1),
("hospital number", "hospital #", 1, 4, '', '', 1);
REPLACE INTO i18n (id, en, fr) VALUES
("régime d'assurance maladie du québec", "Régime d'Assurance Maladie du Québec", "Régime d'Assurance Maladie du Québec");
UPDATE misc_identifier_controls SET misc_identifier_name = misc_identifier_name_abbrev WHERE misc_identifier_name_abbrev = 'RAMQ';

REPLACE INTO i18n (id, en, fr) VALUES
('participant identifier','Participant Initial','initial du participant'); 

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection' AND tablename='' AND field='collection_property' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property'));
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection' AND tablename='' AND field='collection_datetime_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_search_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='acquisition_label' AND type='input' AND structure_value_domain  IS NULL );

UPDATE structure_fields SET flag_confidential =1
WHERE model = 'Participant' AND field IN ('fist_name', 'laste_name', 'date_of_birth');






-- ============================================================================================================================
-- CLICNICAL FORMS FROM - TRFI.Coeur
-- ============================================================================================================================

-- Profile

ALTER TABLE participants
 ADD qc_tf_brca_status VARCHAR(50) NOT NULL DEFAULT '';

ALTER TABLE participants_revs
 ADD qc_tf_brca_status VARCHAR(50) NOT NULL DEFAULT '';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('wild type', 'wild type'),
('BRCA mutation known but not identified', 'BRCA mutation known but not identified'),
('BRCA1 mutated', 'BRCA1 mutated'),
('BRCA2 mutated', 'BRCA2 mutated'),
('BRCA1/2 mutated', 'BRCA1/2 mutated'),
('unknown ', 'unknown');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_brca', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_brca"),  id, "", "1" FROM structure_permissible_values WHERE
(value='wild type' AND language_alias='wild type') OR
(value='BRCA mutation known but not identified' AND language_alias='BRCA mutation known but not identified') OR
(value='BRCA1 mutated' AND language_alias='BRCA1 mutated') OR
(value='BRCA2 mutated' AND language_alias='BRCA2 mutated') OR
(value='BRCA1/2 mutated' AND language_alias='BRCA1/2 mutated') OR
(value='unknown' AND language_alias='unknown'));

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'Participant', 'participants', 'qc_tf_brca_status', 'brca status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_brca') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_brca_status' AND `language_label`='brca status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_brca')  AND `language_help`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '1');

INSERT INTO i18n (id, en, fr) VALUES
("brca status", "BRCA status", "BRCA status");

-- Diagnosis

UPDATE `diagnosis_controls` SET flag_active=0;
INSERT INTO `diagnosis_controls` (`controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
 ('EOC', 1, 'qc_tf_dx_eoc', 'qc_tf_dxd_eocs', 1),
 ('other primary cancer', 1, 'qc_tf_dxd_other_primary_cancer', 'qc_tf_dxd_other_primary_cancers', 2);  

CREATE TABLE qc_tf_dxd_eocs(
 `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `diagnosis_master_id` INTEGER NOT NULL,
 `presence_of_precursor_of_benign_lesions` VARCHAR(50) NOT NULL DEFAULT '',
 `fallopian_tube_lesion` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `tumor_grade` TINYINT UNSIGNED DEFAULT NULL,
 `figo` VARCHAR(50) NOT NULL DEFAULT '',
 `residual_disease` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_ca125_progression` DATE DEFAULT NULL,
 `date_of_ca125_progression_accu` VARCHAR(1) DEFAULT '',
 `ca125_progression_time_in_months` FLOAT UNSIGNED,
 `site_1_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `site_2_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `progression_time_in_months` FLOAT UNSIGNED,
 `follow_up_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `survival_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `progression_status` VARCHAR(50) NOT NULL DEFAULT '',
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;
CREATE TABLE qc_tf_dxd_eocs_revs(
 `id` INTEGER UNSIGNED NOT NULL,
 `diagnosis_master_id` INTEGER NOT NULL,
 `presence_of_precursor_of_benign_lesions` VARCHAR(50) NOT NULL DEFAULT '',
 `fallopian_tube_lesion` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `tumor_grade` TINYINT UNSIGNED DEFAULT NULL,
 `figo` VARCHAR(50) NOT NULL DEFAULT '',
 `residual_disease` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `site_1_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `site_2_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `progression_time_in_months` FLOAT UNSIGNED,
 `follow_up_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `survival_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `progression_status` VARCHAR(50) NOT NULL DEFAULT '',
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;

CREATE TABLE `qc_tf_dxd_other_primary_cancers`(
 `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `diagnosis_master_id` INTEGER NOT NULL,
 `tumor_site` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `site_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `survival_in_months` FLOAT UNSIGNED,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;

CREATE TABLE `qc_tf_dxd_other_primary_cancers_revs`(
 `id` INTEGER UNSIGNED NOT NULL,
 `diagnosis_master_id` INTEGER NOT NULL,
 `tumor_site` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `site_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `survival_in_months` FLOAT UNSIGNED,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_tumor_site', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Digestive-Anal', 'Digestive-Anal'),
('Digestive-Appendix', 'Digestive-Appendix'),
('Digestive-Bile Ducts', 'Digestive-Bile Ducts'),
('Digestive-Colonic', 'Digestive-Colonic'),
('Digestive-Esophageal', 'Digestive-Esophageal'),
('Digestive-Gallbladder', 'Digestive-Gallbladder'),
('Digestive-Liver', 'Digestive-Liver'),
('Digestive-Pancreas', 'Digestive-Pancreas'),
('Digestive-Rectal', 'Digestive-Rectal'),
('Digestive-Small Intestine', 'Digestive-Small Intestine'),
('Digestive-Stomach', 'Digestive-Stomach'),
('Digestive-Other Digestive', 'Digestive-Other Digestive'),
('Thoracic-Lung', 'Thoracic-Lung'),
('Thoracic-Mesothelioma', 'Thoracic-Mesothelioma'),
('Thoracic-Other Thoracic', 'Thoracic-Other Thoracic'),
('Ophthalmic-Eye', 'Ophthalmic-Eye'),
('Ophthalmic-Other Eye', 'Ophthalmic-Other Eye'),
('Breast-Breast', 'Breast-Breast'),
('Female Genital-Cervical', 'Female Genital-Cervical'),
('Female Genital-Endometrium', 'Female Genital-Endometrium'),
('Female Genital-Fallopian Tube', 'Female Genital-Fallopian Tube'),
('Female Genital-Gestational Trophoblastic Neoplasia', 'Female Genital-Gestational Trophoblastic Neoplasia'),
('Female Genital-Ovary', 'Female Genital-Ovary'),
('Female Genital-Peritoneal', 'Female Genital-Peritoneal'),
('Female Genital-Uterine', 'Female Genital-Uterine'),
('Female Genital-Vulva', 'Female Genital-Vulva'),
('Female Genital-Vagina', 'Female Genital-Vagina'),
('Female Genital-Other Female Genital', 'Female Genital-Other Female Genital'),
('Head & Neck-Larynx', 'Head & Neck-Larynx'),
('Head & Neck-Nasal Cavity and Sinuses', 'Head & Neck-Nasal Cavity and Sinuses'),
('Head & Neck-Lip and Oral Cavity', 'Head & Neck-Lip and Oral Cavity'),
('Head & Neck-Pharynx', 'Head & Neck-Pharynx'),
('Head & Neck-Thyroid', 'Head & Neck-Thyroid'),
('Head & Neck-Salivary Glands', 'Head & Neck-Salivary Glands'),
('Head & Neck-Other Head & Neck', 'Head & Neck-Other Head & Neck'),
('Haematological-Leukemia', 'Haematological-Leukemia'),
('Haematological-Lymphoma', 'Haematological-Lymphoma'),
("Haematological-Hodgkin's Disease", "Haematological-Hodgkin's Disease"),
("Haematological-Non-Hodgkin's Lymphomas", "Haematological-Non-Hodgkin's Lymphomas"),
('Haematological-Other Haematological', 'Haematological-Other Haematological'),
('Skin-Melanoma', 'Skin-Melanoma'),
('Skin-Non Melanomas', 'Skin-Non Melanomas'),
('Skin-Other Skin', 'Skin-Other Skin'),
('Urinary Tract-Bladder', 'Urinary Tract-Bladder'),
('Urinary Tract-Renal Pelvis and Ureter', 'Urinary Tract-Renal Pelvis and Ureter'),
('Urinary Tract-Kidney', 'Urinary Tract-Kidney'),
('Urinary Tract-Urethra', 'Urinary Tract-Urethra'),
('Urinary Tract-Other Urinary Tract', 'Urinary Tract-Other Urinary Tract'),
('Central Nervous System-Brain', 'Central Nervous System-Brain'),
('Central Nervous System-Spinal Cord', 'Central Nervous System-Spinal Cord'),
('Central Nervous System-Other Central Nervous System', 'Central Nervous System-Other Central Nervous System'),
('Musculoskeletal Sites-Soft Tissue Sarcoma', 'Musculoskeletal Sites-Soft Tissue Sarcoma'),
('Musculoskeletal Sites-Bone', 'Musculoskeletal Sites-Bone'),
('Musculoskeletal Sites-Other Bone', 'Musculoskeletal Sites-Other Bone'),
('Other-Primary Unknown', 'Other-Primary Unknown'),
('Other-Gross Metastatic Disease', 'Other-Gross Metastatic Disease');
INSERT IGNORE INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tumor_site"),  id, "", "1" FROM structure_permissible_values WHERE
(value='Digestive-Anal' AND language_alias='Digestive-Anal') OR
(value='Digestive-Appendix' AND language_alias='Digestive-Appendix') OR
(value='Digestive-Bile Ducts' AND language_alias='Digestive-Bile Ducts') OR
(value='Digestive-Colonic' AND language_alias='Digestive-Colonic') OR
(value='Digestive-Esophageal' AND language_alias='Digestive-Esophageal') OR
(value='Digestive-Gallbladder' AND language_alias='Digestive-Gallbladder') OR
(value='Digestive-Liver' AND language_alias='Digestive-Liver') OR
(value='Digestive-Pancreas' AND language_alias='Digestive-Pancreas') OR
(value='Digestive-Rectal' AND language_alias='Digestive-Rectal') OR
(value='Digestive-Small Intestine' AND language_alias='Digestive-Small Intestine') OR
(value='Digestive-Stomach' AND language_alias='Digestive-Stomach') OR
(value='Digestive-Other Digestive' AND language_alias='Digestive-Other Digestive') OR
(value='Thoracic-Lung' AND language_alias='Thoracic-Lung') OR
(value='Thoracic-Mesothelioma' AND language_alias='Thoracic-Mesothelioma') OR
(value='Thoracic-Other Thoracic' AND language_alias='Thoracic-Other Thoracic') OR
(value='Ophthalmic-Eye' AND language_alias='Ophthalmic-Eye') OR
(value='Ophthalmic-Other Eye' AND language_alias='Ophthalmic-Other Eye') OR
(value='Breast-Breast' AND language_alias='Breast-Breast') OR
(value='Female Genital-Cervical' AND language_alias='Female Genital-Cervical') OR
(value='Female Genital-Endometrium' AND language_alias='Female Genital-Endometrium') OR
(value='Female Genital-Fallopian Tube' AND language_alias='Female Genital-Fallopian Tube') OR
(value='Female Genital-Gestational Trophoblastic Neoplasia' AND language_alias='Female Genital-Gestational Trophoblastic Neoplasia') OR
(value='Female Genital-Ovary' AND language_alias='Female Genital-Ovary') OR
(value='Female Genital-Peritoneal' AND language_alias='Female Genital-Peritoneal') OR
(value='Female Genital-Uterine' AND language_alias='Female Genital-Uterine') OR
(value='Female Genital-Vulva' AND language_alias='Female Genital-Vulva') OR
(value='Female Genital-Vagina' AND language_alias='Female Genital-Vagina') OR
(value='Female Genital-Other Female Genital' AND language_alias='Female Genital-Other Female Genital') OR
(value='Head & Neck-Larynx' AND language_alias='Head & Neck-Larynx') OR
(value='Head & Neck-Nasal Cavity and Sinuses' AND language_alias='Head & Neck-Nasal Cavity and Sinuses') OR
(value='Head & Neck-Lip and Oral Cavity' AND language_alias='Head & Neck-Lip and Oral Cavity') OR
(value='Head & Neck-Pharynx' AND language_alias='Head & Neck-Pharynx') OR
(value='Head & Neck-Thyroid' AND language_alias='Head & Neck-Thyroid') OR
(value='Head & Neck-Salivary Glands' AND language_alias='Head & Neck-Salivary Glands') OR
(value='Head & Neck-Other Head & Neck' AND language_alias='Head & Neck-Other Head & Neck') OR
(value='Haematological-Leukemia' AND language_alias='Haematological-Leukemia') OR
(value='Haematological-Lymphoma' AND language_alias='Haematological-Lymphoma') OR
(value="Haematological-Hodgkin's Disease" AND language_alias="Haematological-Hodgkin's Disease") OR
(value="Haematological-Non-Hodgkin's Lymphomas" AND language_alias="Haematological-Non-Hodgkin's Lymphomas") OR
(value='Haematological-Other Haematological' AND language_alias='Haematological-Other Haematological') OR
(value='Skin-Melanoma' AND language_alias='Skin-Melanoma') OR
(value='Skin-Non Melanomas' AND language_alias='Skin-Non Melanomas') OR
(value='Skin-Other Skin' AND language_alias='Skin-Other Skin') OR
(value='Urinary Tract-Bladder' AND language_alias='Urinary Tract-Bladder') OR
(value='Urinary Tract-Renal Pelvis and Ureter' AND language_alias='Urinary Tract-Renal Pelvis and Ureter') OR
(value='Urinary Tract-Kidney' AND language_alias='Urinary Tract-Kidney') OR
(value='Urinary Tract-Urethra' AND language_alias='Urinary Tract-Urethra') OR
(value='Urinary Tract-Other Urinary Tract' AND language_alias='Urinary Tract-Other Urinary Tract') OR
(value='Central Nervous System-Brain' AND language_alias='Central Nervous System-Brain') OR
(value='Central Nervous System-Spinal Cord' AND language_alias='Central Nervous System-Spinal Cord') OR
(value='Central Nervous System-Other Central Nervous System' AND language_alias='Central Nervous System-Other Central Nervous System') OR
(value='Musculoskeletal Sites-Soft Tissue Sarcoma' AND language_alias='Musculoskeletal Sites-Soft Tissue Sarcoma') OR
(value='Musculoskeletal Sites-Bone' AND language_alias='Musculoskeletal Sites-Bone') OR
(value='Musculoskeletal Sites-Other Bone' AND language_alias='Musculoskeletal Sites-Other Bone') OR
(value='Other-Primary Unknown' AND language_alias='Other-Primary Unknown') OR
(value='Other-Gross Metastatic Disease' AND language_alias='Other-Gross Metastatic Disease'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_histopathology_opc', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('unknown', 'unknown'),
('non applicable', 'non applicable'),
('high grade serous', 'high grade serous'),
('low grade serous', 'low grade serous'),
('mucinous', 'mucinous'),
('endometrioid', 'endometrioid'),
('clear cells', 'clear cells');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology_opc"),  id, "", "1" FROM structure_permissible_values WHERE
(value='unknown' AND language_alias='unknown') OR
(value='non applicable' AND language_alias='non applicable') OR
(value='high grade serous' AND language_alias='high grade serous') OR
(value='low grade serous' AND language_alias='low grade serous') OR
(value='mucinous' AND language_alias='mucinous') OR
(value='endometrioid' AND language_alias='endometrioid') OR
(value='clear cells' AND language_alias='clear cells'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('0_to_3', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
(0, 0),
(1, 1),
(2, 2),
(3, 3);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="0_to_3"),  id, "", "1" FROM structure_permissible_values WHERE
(value='0' AND language_alias='0') OR
(value='1' AND language_alias='1') OR
(value='2' AND language_alias='2') OR
(value='3' AND language_alias='3'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_stage', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Ia', 'Ia'),
('Ib', 'Ib'),
('Ic', 'Ic'),
('IIa', 'IIa'),
('IIb', 'IIb'),
('IIc', 'IIc'),
('IIIa', 'IIIa'),
('IIIb', 'IIIb'),
('IIIc', 'IIIc'),
('IV', 'IV'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_stage"),  id, "", "1" FROM structure_permissible_values WHERE
(value='Ia' AND language_alias='Ia') OR
(value='Ib' AND language_alias='Ib') OR
(value='Ic' AND language_alias='Ic') OR
(value='IIa' AND language_alias='IIa') OR
(value='IIb' AND language_alias='IIb') OR
(value='IIc' AND language_alias='IIc') OR
(value='IIIa' AND language_alias='IIIa') OR
(value='IIIb' AND language_alias='IIIb') OR
(value='IIIc' AND language_alias='IIIc') OR
(value='IV' AND language_alias='IV') OR
(value='unknown' AND language_alias='unknown'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_presence_of_precursor_of_benign_lesions', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('no', 'no'),
('unknown', 'unknown'),
('ovarian cysts', 'ovarian cysts'),
('endometriosis', 'endometriosis'),
('endosalpingiosis', 'endosalpingiosis'),
('benign  or borderline tumours', 'benign  or borderline tumours');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_presence_of_precursor_of_benign_lesions"),  id, "", "1" FROM structure_permissible_values WHERE
(value='no' AND language_alias='no') OR
(value='unknown' AND language_alias='unknown') OR
(value='ovarian cysts' AND language_alias='ovarian cysts') OR
(value='endometriosis' AND language_alias='endometriosis') OR
(value='endosalpingiosis' AND language_alias='endosalpingiosis') OR
(value='benign  or borderline tumours' AND language_alias='benign  or borderline tumours'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_fallopian_tube_lesion', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('no', 'no'),
('yes', 'yes'),
('unknown', 'unknown'),
('salpingitis', 'salpingitis'),
('benign tumors', 'benign tumors'),
('malignant tumors', 'malignant tumors');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_fallopian_tube_lesion"),  id, "", "1" FROM structure_permissible_values WHERE
(value='no' AND language_alias='no') OR
(value='yes' AND language_alias='yes') OR
(value='unknown' AND language_alias='unknown') OR
(value='salpingitis' AND language_alias='salpingitis') OR
(value='benign tumors' AND language_alias='benign tumors') OR
(value='malignant tumors' AND language_alias='malignant tumors'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_histopathology', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('high grade serous', 'high grade serous'),
('low grade serous', 'low grade serous'),
('mucinous', 'mucinous'),
('clear cells', 'clear cells'),
('endometrioid', 'endometrioid'),
('mixed', 'mixed'),
('undifferentiated', 'undifferentiated');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology"),  id, "", "1" FROM structure_permissible_values WHERE
(value='high grade serous' AND language_alias='high grade serous') OR
(value='low grade serous' AND language_alias='low grade serous') OR
(value='mucinous' AND language_alias='mucinous') OR
(value='clear cells' AND language_alias='clear cells') OR
(value='endometrioid' AND language_alias='endometrioid') OR
(value='mixed' AND language_alias='mixed') OR
(value='undifferentiated' AND language_alias='undifferentiated'));


INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_figo', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Ia', 'Ia'),
('Ib', 'Ib'),
('Ic', 'Ic'),
('IIa', 'IIa'),
('IIb', 'IIb'),
('IIc', 'IIc'),
('IIIa', 'IIIa'),
('IIIb', 'IIIb'),
('IIIc', 'IIIc'),
('IV', 'IV');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_figo"),  id, "", "1" FROM structure_permissible_values WHERE
(value='Ia' AND language_alias='Ia') OR
(value='Ib' AND language_alias='Ib') OR
(value='Ic' AND language_alias='Ic') OR
(value='IIa' AND language_alias='IIa') OR
(value='IIb' AND language_alias='IIb') OR
(value='IIc' AND language_alias='IIc') OR
(value='IIIa' AND language_alias='IIIa') OR
(value='IIIb' AND language_alias='IIIb') OR
(value='IIIc' AND language_alias='IIIc') OR
(value='IV' AND language_alias='IV'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_residual_disease', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('none', 'none'),
('miliary', 'miliary'),
('<1cm', '<1cm'),
('1-2cm', '1-2cm'),
('>2cm', '>2cm'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_residual_disease"),  id, "", "1" FROM structure_permissible_values WHERE
(value='none' AND language_alias='none') OR
(value='miliary' AND language_alias='miliary') OR
(value='<1cm' AND language_alias='<1cm') OR
(value='1-2cm' AND language_alias='1-2cm') OR
(value='>2cm' AND language_alias='>2cm') OR
(value='unknown' AND language_alias='unknown'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_laterality', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('bilateral', 'bilateral');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_laterality"),  id, "", "1" FROM structure_permissible_values WHERE
(value='left' AND language_alias='left') OR
(value='right' AND language_alias='right') OR
(value='bilateral' AND language_alias='bilateral') OR
(value='unknown' AND language_alias='unknown'));


INSERT INTO structures(`alias`) VALUES ('qc_tf_dx_eoc');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'fallopian_tube_lesion', 'fallopian tube lesion', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fallopian_tube_lesion') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'presence_of_precursor_of_benign_lesions', 'presence of precursor of benign lesions', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_presence_of_precursor_of_benign_lesions') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'age_at_dx', 'age at diagnosis', '', 'integer', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'laterality', 'laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'histopathology', 'histopathology', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'tumour grade', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='0_to_3') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'figo', 'figo', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_figo') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'residual_disease', 'residual disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_residual_disease') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'date_of_progression_recurrence', 'date of progession/recurrence', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'date_of_progression_recurrence_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'site_1_of_tumor_progression', 'site 1 of tumor progression (metastasis) if applicable', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'site_2_of_tumor_progression', 'site 2 of tumor progression (metastasis) if applicable', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'survival_from_ovarectomy_in_months', 'survival from ovarectomy (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'progression_time_in_months', 'progression time (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'follow_up_from_ovarectomy_in_months', 'follow up from ovarectomy (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_tf_dx_eoc');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  ), 
'1', '1', '', '1', 'date of diagnosis', '0', '', '1', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  ), '1', '2', '', '0', '', '1', 'accuracy', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='fallopian_tube_lesion' AND `language_label`='fallopian tube lesion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fallopian_tube_lesion')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='presence_of_precursor_of_benign_lesions' AND `language_label`='presence of precursor of benign lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_presence_of_precursor_of_benign_lesions')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `language_label`='age at diagnosis' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='laterality' ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology')  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='0_to_3')  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_figo')  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='residual_disease' AND `language_label`='residual disease' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_residual_disease')  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_progression_recurrence' AND `language_label`='date of progession/recurrence' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_progression_recurrence_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='site_1_of_tumor_progression' AND `language_label`='site 1 of tumor progression (metastasis) if applicable' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='site_2_of_tumor_progression' AND `language_label`='site 2 of tumor progression (metastasis) if applicable' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='survival_from_ovarectomy_in_months' AND `language_label`='survival from ovarectomy (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='progression_time_in_months' AND `language_label`='progression time (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='follow_up_from_ovarectomy_in_months' AND `language_label`='follow up from ovarectomy (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_laterality')  WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_eocs' AND field='laterality' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='laterality'); 

INSERT INTO structures(`alias`) VALUES ('qc_tf_dxd_other_primary_cancer');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'age_at_dx', 'age at dx', '', 'integer', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'tumor_site', 'tumor site', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'laterality', 'laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'histopathology', 'histopathology', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology_opc') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'stage', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_stage') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'date_of_progression_recurrence', 'date of progression recurrence', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'date_of_progression_recurrence_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'site_of_tumor_progression', 'site of tumor progression', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'survival_in_months', 'survival (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'diagnosis date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  ), '1', '2', '', '0', '', '1', 'accuracy', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `language_label`='age at dx' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='tumor_site' AND `language_label`='tumor site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='laterality' AND `language_label`='laterality' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology_opc')  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='0_to_3')  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `language_label`='stage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_stage')  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='date_of_progression_recurrence' AND `language_label`='date of progression recurrence' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='date_of_progression_recurrence_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='site_of_tumor_progression' AND `language_label`='site of tumor progression' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='survival_in_months' AND `language_label`='survival (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '1');

ALTER TABLE qc_tf_dxd_eocs_revs
 ADD date_of_ca125_progression DATE DEFAULT NULL,
 ADD date_of_ca125_progression_accu VARCHAR(1) DEFAULT '',
 ADD ca125_progression_time_in_months FLOAT UNSIGNED DEFAULT NULL;
 
-- end of dx --

-- ============================================================================================================================
-- END CLICNICAL FORMS FROM - TRFI.Coeur
-- ============================================================================================================================






