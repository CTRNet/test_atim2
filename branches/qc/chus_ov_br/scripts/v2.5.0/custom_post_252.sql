
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');




















