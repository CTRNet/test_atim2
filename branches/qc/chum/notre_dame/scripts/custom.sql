ALTER TABLE ad_blocks
 DROP COLUMN path_report_code;
ALTER TABLE ad_blocks_revs
 DROP COLUMN path_report_code;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'path_report_code');
DELETE FROM structure_fields WHERE field = 'path_report_code' ;

ALTER TABLE quality_ctrls
 ADD COLUMN qc_nd_is_irrelevant BOOLEAN NOT NULL DEFAULT false AFTER used_volume;
ALTER TABLE quality_ctrls_revs
 ADD COLUMN qc_nd_is_irrelevant BOOLEAN NOT NULL DEFAULT false AFTER used_volume;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'QualityCtrl', 'quality_ctrls', 'qc_nd_is_irrelevant', 'checkbox',  NULL , '0', '', '', '', 'is irrelevant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_nd_is_irrelevant' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='is irrelevant' AND `language_tag`=''), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

INSERT INTO i18n (id, en, fr) VALUES
('is irrelevant', 'Is irrelevant', 'Est inutile'),
('immunofluorescence', 'Immunofluorescence', 'Immunofluorescence');

UPDATE structure_fields SET  `type`='yes_no' WHERE model='AliquotDetail' AND tablename='ad_tubes' AND field='mycoplasma_free' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
ALTER TABLE ad_tubes
 MODIFY mycoplasma_free CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE ad_tubes_revs
 MODIFY mycoplasma_free CHAR(1) NOT NULL DEFAULT '';
UPDATE ad_tubes SET mycoplasma_free='y' WHERE mycoplasma_free='1';
UPDATE ad_tubes SET mycoplasma_free='n' WHERE mycoplasma_free='0';
UPDATE ad_tubes_revs SET mycoplasma_free='y' WHERE mycoplasma_free='1';
UPDATE ad_tubes_revs SET mycoplasma_free='n' WHERE mycoplasma_free='0';
