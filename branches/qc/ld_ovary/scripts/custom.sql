INSERT INTO i18n (id, en, fr) VALUES
('core_installname', 'Lady Davis - Ovary', 'Lady Davis - Ovaire');

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

