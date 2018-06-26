-- Aliquot
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Aliquot barcode
--    . Aliquot Barcode field should not let user to set or modify the vlaue (value generated by the system)
--         (SQL statements built using the ATiM Formbuilder tool [https://ctrnet.svn.cvsdude.com/tools/atimTools/form_builder/].)

UPDATE structure_formats SET `flag_add`='0',`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid_readonly`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Aliquot label
--    . Aliquot label should be comptled
--    . Aliquot label should always be visibale (on left side) for any data creation in batch (flag_float property)

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotMaster'  AND `field`='aliquot_label'), 'notBlank', '');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
