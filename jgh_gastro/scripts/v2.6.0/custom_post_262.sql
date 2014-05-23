
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'participant identifiers report';

UPDATE versions SET branch_build_number = '5740' WHERE version_number = '2.6.2';

-- ----------------------------------------------------------------------------------------------------------------------------------
-- 20140523: Add Path Number to qc_gastro_ed_molecular_testing 
-- and add control to check number is unique both into qc_gastro_ed_molecular_testing and qc_gastro_ed_immunohistochemistry
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_molecular_testing', 'path_num', 'input',  NULL , '0', 'size=10', '', '', 'pathology number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_molecular_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_molecular_testing' AND `field`='path_num' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='pathology number' AND `language_tag`=''), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE qc_gastro_ed_molecular_testing ADD COLUMN `path_num` varchar(50) DEFAULT NULL;
ALTER TABLE qc_gastro_ed_molecular_testing_revs ADD COLUMN `path_num` varchar(50) DEFAULT NULL;
INSERT INTO i18n (id,en,fr) VALUES
('you can not record path number [%s] twice', 'You can not record Pathology Number [%s] twice!', 'Vous ne pouvez enregistrer le numéro de pathologie [%s] deux fois!'),
('the path_num [%s] has already been recorded', 'The Pathology Number [%s] has already been recorded!', 'Le numéro de pathologie [%s] a déjà été enregistré!');

UPDATE versions SET branch_build_number = '5747' WHERE version_number = '2.6.2';
