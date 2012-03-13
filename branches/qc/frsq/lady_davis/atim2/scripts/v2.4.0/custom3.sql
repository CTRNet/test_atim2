-- ran on 2012-03-13
REPLACE INTO i18n (id, page_id, en, fr) VALUES
('rack 1-12', 'global', 'Rack 1-12', 'Étagère 1-12'),
('rack 4x4', 'global', 'Rack 4x4', 'Étagère 4x4'),
('freezer 4x5', 'global', 'Freezer 4x5', 'Congélateur 4x5'),
('freezer 6x5', 'global', 'Freezer 6x5', 'Congélateur 6x5'),
('freezer vertical 4x3', 'global', 'Vertical freezer 4x3', 'Congélateur vertical 4x3'),
('box100 1-100', '', 'Box100 1-100', 'Boîte100 1-100'),
('label', 'Label', 'Étiquette');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="1" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="OCT" AND language_alias="oct solution");

UPDATE structure_formats SET `flag_override_default`='1', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(8, 9);

UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=216;
UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

