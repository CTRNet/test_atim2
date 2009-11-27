INSERT INTO `structure_formats` (
`old_id` ,
`structure_id` ,
`structure_old_id` ,
`structure_field_id` ,
`structure_field_old_id` ,
`display_column` ,
`display_order` ,
`language_heading` ,
`flag_override_label` ,
`language_label` ,
`flag_override_tag` ,
`language_tag` ,
`flag_override_help` ,
`language_help` ,
`flag_override_type` ,
`type` ,
`flag_override_setting` ,
`setting` ,
`flag_override_default` ,
`default` ,
`flag_add` ,
`flag_add_readonly` ,
`flag_edit` ,
`flag_edit_readonly` ,
`flag_search` ,
`flag_search_readonly` ,
`flag_datagrid` ,
`flag_datagrid_readonly` ,
`flag_index` ,
`flag_detail` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_spec_tubes'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT old_id FROM structures WHERE alias='ad_spec_tubes'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), (SELECT old_id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_undetailled_spec_aliquots'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_undetailled_spec_aliquots'), (SELECT old_id FROM structures WHERE alias='ad_undetailled_spec_aliquots'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_spec_tiss_blocks'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT old_id FROM structures WHERE alias='ad_spec_tiss_blocks'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_spec_tiss_slides'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT old_id FROM structures WHERE alias='ad_spec_tiss_slides'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_spec_whatman_papers'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT old_id FROM structures WHERE alias='ad_spec_whatman_papers'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_tubes'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_tubes'), (SELECT old_id FROM structures WHERE alias='ad_der_tubes'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT old_id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol_and_conc'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol_and_conc'), (SELECT old_id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol_and_conc'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_cell_slides'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_cell_slides'), (SELECT old_id FROM structures WHERE alias='ad_der_cell_slides'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT old_id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_spec_tiss_cores'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT old_id FROM structures WHERE alias='ad_spec_tiss_cores'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_cel_gel_matrices'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices'), (SELECT old_id FROM structures WHERE alias='ad_der_cel_gel_matrices'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_cell_cores'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_cell_cores'), (SELECT old_id FROM structures WHERE alias='ad_der_cell_cores'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(CONCAT((SELECT old_id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), '-1022_CAN-999-999-000-999-1119'), (SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), (SELECT old_id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), '235', 'CAN-999-999-000-999-1119', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

ALTER TABLE `consent_masters` CHANGE `diagnosis_master_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT '0';

#--Updating old_id
UPDATE structure_formats AS sfo
left outer join structure_fields AS sfi ON sfi.id=sfo.structure_field_id
SET sfo.structure_field_old_id=sfi.old_id
WHERE sfi.old_id != sfo.structure_field_old_id;

UPDATE structure_formats AS sfo
left outer join structures AS s ON s.id=sfo.structure_id
SET sfo.structure_old_id=s.old_id
WHERE s.old_id != sfo.structure_old_id;

UPDATE structure_formats AS sfo
SET old_id=CONCAT(sfo.structure_old_id, "_", sfo.structure_field_old_id)
WHERE sfo.structure_old_id!="" && sfo.structure_field_old_id!="";