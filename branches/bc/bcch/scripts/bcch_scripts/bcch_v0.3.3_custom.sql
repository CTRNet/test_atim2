-- BCCH Customization Script
-- Version 0.3.2
-- ATiM Version: 2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.3.3", '');
	
--  =========================================================================
--	Eventum ID: #XXXX- Enable realiquoting for certain aliquot type
--  BB-29
--	=========================================================================

-- Enable Urine realiquoting

DELETE FROM `realiquoting_controls`
WHERE `parent_aliquot_control_id`=(SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='urine|tube' AND `flag_active`=0 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol')
AND `child_aliquot_control_id`=(SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='urine|tube' AND `flag_active`=0 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol');

DELETE FROM `aliquot_controls` 
WHERE `databrowser_label`='urine|tube' AND `flag_active`=0;

INSERT INTO `realiquoting_controls`
(`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`)
VALUES 
((SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='urine|tube' AND `flag_active`=1 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol'), (SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='urine|tube' AND `flag_active`=1 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol'), 1, NULL);

-- Fixes old bone marrow's forms, 

UPDATE `aliquot_masters`
SET `aliquot_control_id`=(SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='bone marrow|tube' AND `flag_active`=1 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol')
WHERE `aliquot_control_id`=(SELECT `id` FROm `aliquot_controls` WHERE `databrowser_label`='bone marrow|tube' AND `flag_active`=0 AND `detail_form_alias`='ad_ccbr_spec_tubes_incl_cell_count');

-- Disable Bone Marrow realiquoting

UPDATE `realiquoting_controls`
SET `flag_active` = 0
WHERE `parent_aliquot_control_id`=(SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='bone marrow|tube' AND `flag_active`=1 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol')
AND `child_aliquot_control_id`=(SELECT `id` FROM `aliquot_controls` WHERE `databrowser_label`='bone marrow|tube' AND `flag_active`=1 AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol'); 