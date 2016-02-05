-- -----------------------------------------------------------------------------------------------------------------------------------
-- Fix bug on sgbd with 
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_masters MODIFY storage_coord_x varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters MODIFY storage_coord_y varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY storage_coord_x varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY storage_coord_y varchar(11) DEFAULT NULL;


-- tma_blocks_for_slide_creation duplicated field in index view

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE `language_heading` = 'tma block' AND structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.6.7', NOW(),'????','n/a');

