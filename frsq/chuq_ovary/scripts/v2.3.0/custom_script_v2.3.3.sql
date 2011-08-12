UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id');

UPDATE structure_formats as sf_new, structure_formats as sf_old, structure_fields as sfi_old, structure_fields as sfi_new
SET sf_new.`display_column` = sf_old.`display_column`,
sf_new.`display_order` = sf_old.`display_order`,
sf_new.`flag_override_label` = sf_old.`flag_override_label`,
sf_new.`language_label` = sf_old.`language_label`,
sf_new.`flag_override_tag` = sf_old.`flag_override_tag`,
sf_new.`language_tag` = sf_old.`language_tag`,
sf_new.`flag_override_help` = sf_old.`flag_override_help`,
sf_new.`language_help` = sf_old.`language_help`,
sf_new.`flag_override_type` = sf_old.`flag_override_type`,
sf_new.`type` = sf_old.`type`,
sf_new.`flag_override_setting` = sf_old.`flag_override_setting`,
sf_new.`setting` = sf_old.`setting`,
sf_new.`flag_override_default` = sf_old.`flag_override_default`,
sf_new.`default` = sf_old.`default`,
sf_new.`flag_add` = sf_old.`flag_add`,
sf_new.`flag_add_readonly` = sf_old.`flag_add_readonly`,
sf_new.`flag_edit` = sf_old.`flag_edit`,
sf_new.`flag_edit_readonly` = sf_old.`flag_edit_readonly`,
sf_new.`flag_search` = sf_old.`flag_search`,
sf_new.`flag_search_readonly` = sf_old.`flag_search_readonly`,
sf_new.`flag_addgrid` = sf_old.`flag_addgrid`,
sf_new.`flag_addgrid_readonly` = sf_old.`flag_addgrid_readonly`,
sf_new.`flag_editgrid` = sf_old.`flag_editgrid`,
sf_new.`flag_editgrid_readonly` = sf_old.`flag_editgrid_readonly`,
sf_new.`flag_summary` = sf_old.`flag_summary`,
sf_new.`flag_batchedit` = sf_old.`flag_batchedit`,
sf_new.`flag_batchedit_readonly` = sf_old.`flag_batchedit_readonly`,
sf_new.`flag_index` = sf_old.`flag_index`,
sf_new.`flag_detail` = sf_old.`flag_detail`
WHERE sf_new.structure_id = sf_old.structure_id

AND sf_old.structure_field_id = sfi_old.id
AND sfi_old.field = 'aliquot_label_to_delete'

AND sf_new.structure_field_id = sfi_new.id
AND sfi_new.field = 'aliquot_label';

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'aliquot_label_to_delete');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'aliquot_label_to_delete');
DELETE FROM structure_fields WHERE field = 'aliquot_label_to_delete';

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='aliquot_label' ), 'notEmpty', '', 'value is required');

DELETE FROM i18n WHERE id IN ("sample system code","aliquot system code");
INSERT INTO i18n (id, en, fr) VALUES
("sample system code", "Sample System Code", "Code système d'échantillon"),
("aliquot system code", "Aliquot system code", "Code système d'aliquot");

-- update sample code label to sample system code
UPDATE structure_fields SET language_label='sample system code' WHERE field='sample_code';

CREATE TABLE tmp
(SELECT sf1.id, MAX(sf2.display_column) AS display_column, MAX(sf2.display_order) AS display_order FROM structure_formats AS sf1 
INNER JOIN structure_formats AS sf2 ON sf1.structure_id=sf2.structure_id
WHERE sf1.structure_field_id IN (SELECT id FROM structure_fields WHERE field='sample_code')
GROUP BY sf1.structure_id);

UPDATE structure_formats AS sf1 
INNER JOIN tmp AS sf2 USING(id)
SET sf1.display_column=sf2.display_column, sf1.display_order=sf2.display_order + 1;

DROP TABLE tmp;

UPDATE structure_formats SET `language_heading`='system data' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field='sample_code');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('system data', 'System Data', 'Données système');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='study_summary_id');
UPDATE structure_formats SET `flag_search`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='current_volume');

UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='study_summary_id');
UPDATE structure_formats SET `flag_search`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='current_volume');

UPDATE structure_formats SET `flag_search`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='parent_sample_type');
UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('creation_by','creation_site'));
UPDATE structure_formats SET `flag_search`='0' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='current_volume');
UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='study_summary_id');	
UPDATE structure_formats SET `flag_search`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_hemolysis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='hemolysis_signs');
UPDATE structure_formats SET `flag_search`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='tissue_nature');
 	
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' );
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode');

UPDATE menus SET flag_active = 0 WHERE use_link like '/labbook%';

