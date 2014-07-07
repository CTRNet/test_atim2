
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageMaster', 'storage_masters', 'qc_tf_tma_label_site', 'input',  NULL , '0', 'size=20', '', '', 'TMA label site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='TMA label site' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='tma name central' WHERE structure_id=(SELECT id FROM structures WHERE alias='storagemasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
INSERT INTO i18n (id,en) VALUES ('TMA label site', 'TMA Label-Site'),('tma name central','TMA Name-Central');
ALTER TABLE storage_masters ADD COLUMN qc_tf_tma_label_site VARCHAR(100);
ALTER TABLE storage_masters_revs ADD COLUMN qc_tf_tma_label_site VARCHAR(100);

UPDATE storage_masters SET qc_tf_tma_label_site = 'TFN1A' WHERE id = 1;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFN1B' WHERE id = 2;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFN1C' WHERE id = 3;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFN1D' WHERE id = 4;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFN1E' WHERE id = 5;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFN1 Test' WHERE id = 6;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TMA Pca 5 CHUQ' WHERE id = 10;
UPDATE storage_masters SET qc_tf_tma_label_site = 'CHUQ 6' WHERE id = 11;
UPDATE storage_masters SET qc_tf_tma_label_site = 'Ext-P7' WHERE id = 12;
UPDATE storage_masters SET qc_tf_tma_label_site = 'Test TMA' WHERE id = 28;
UPDATE storage_masters SET qc_tf_tma_label_site = 'ExtP1' WHERE id = 7;
UPDATE storage_masters SET qc_tf_tma_label_site = 'ExtP2' WHERE id = 8;
UPDATE storage_masters SET qc_tf_tma_label_site = 'ExtP3' WHERE id = 9;
UPDATE storage_masters SET qc_tf_tma_label_site = 'McGill 1' WHERE id = 14;
UPDATE storage_masters SET qc_tf_tma_label_site = 'McGill 2' WHERE id = 15;
UPDATE storage_masters SET qc_tf_tma_label_site = '(A) (McGill 3)' WHERE id = 16;
UPDATE storage_masters SET qc_tf_tma_label_site = '(B) (McGil 4)' WHERE id = 17;
UPDATE storage_masters SET qc_tf_tma_label_site = 'McGill 6' WHERE id = 18;
UPDATE storage_masters SET qc_tf_tma_label_site = 'Test TMA' WHERE id = 19;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TMA 1' WHERE id = 20;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TMA 2' WHERE id = 21;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #1' WHERE id = 22;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #2' WHERE id = 23;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #3' WHERE id = 24;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #5' WHERE id = 25;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #6' WHERE id = 26;
UPDATE storage_masters SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #4 (Test)' WHERE id = 27;

UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFN1A' WHERE id = 1;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFN1B' WHERE id = 2;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFN1C' WHERE id = 3;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFN1D' WHERE id = 4;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFN1E' WHERE id = 5;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFN1 Test' WHERE id = 6;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TMA Pca 5 CHUQ' WHERE id = 10;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'CHUQ 6' WHERE id = 11;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'Ext-P7' WHERE id = 12;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'Test TMA' WHERE id = 28;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'ExtP1' WHERE id = 7;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'ExtP2' WHERE id = 8;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'ExtP3' WHERE id = 9;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'McGill 1' WHERE id = 14;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'McGill 2' WHERE id = 15;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = '(A) (McGill 3)' WHERE id = 16;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = '(B) (McGil 4)' WHERE id = 17;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'McGill 6' WHERE id = 18;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'Test TMA' WHERE id = 19;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TMA 1' WHERE id = 20;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TMA 2' WHERE id = 21;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #1' WHERE id = 22;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #2' WHERE id = 23;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #3' WHERE id = 24;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #5' WHERE id = 25;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #6' WHERE id = 26;
UPDATE storage_masters_revs SET qc_tf_tma_label_site = 'TFRI - CPCBN TMA #4 (Test)' WHERE id = 27;

ALTER TABLE storage_masters ADD COLUMN `qc_tf_bank_id` int(11) DEFAULT NULL;
ALTER TABLE storage_masters_revs ADD COLUMN `qc_tf_bank_id` int(11) DEFAULT NULL;
ALTER TABLE storage_masters ADD CONSTRAINT `FK_storage_masters_bank` FOREIGN KEY (`qc_tf_bank_id`) REFERENCES `banks` (`id`);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageMaster', 'storage_masters', 'qc_tf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='qc_tf_bank_id'), 'notEmpty');

UPDATE storage_masters SET qc_tf_bank_id = 1 WHERE qc_tf_tma_name LIKE 'CHUM%';
UPDATE storage_masters SET qc_tf_bank_id = 2 WHERE qc_tf_tma_name LIKE 'CHUQ%';
UPDATE storage_masters SET qc_tf_bank_id = 3 WHERE qc_tf_tma_name LIKE 'MUHC%';
UPDATE storage_masters SET qc_tf_bank_id = 5 WHERE qc_tf_tma_name LIKE 'VPC%';
UPDATE storage_masters SET qc_tf_bank_id = 6 WHERE qc_tf_tma_name LIKE 'UHN%';

UPDATE storage_masters_revs SET qc_tf_bank_id = 1 WHERE qc_tf_tma_name LIKE 'CHUM%';
UPDATE storage_masters_revs SET qc_tf_bank_id = 2 WHERE qc_tf_tma_name LIKE 'CHUQ%';
UPDATE storage_masters_revs SET qc_tf_bank_id = 3 WHERE qc_tf_tma_name LIKE 'MUHC%';
UPDATE storage_masters_revs SET qc_tf_bank_id = 5 WHERE qc_tf_tma_name LIKE 'VPC%';
UPDATE storage_masters_revs SET qc_tf_bank_id = 6 WHERE qc_tf_tma_name LIKE 'UHN%';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `language_label`='tma name' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_tma_name' AND `language_label`='tma name' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_tma_name' AND `language_label`='tma name' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_tma_name' AND `language_label`='tma name' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_fields SET flag_confidential = 0 WHERE field = 'qc_tf_tma_name';

update versions set permissions_regenerated = 0;

-- 20140707 ------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', '', 'is_suspected_date_of_death', 'yes_no',  NULL , '0', '', '', '', 'is suspected date of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='is_suspected_date_of_death'), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en) VALUES ('is suspected date of death', 'Suspected Date of Death');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', '', 'qc_tf_radiation_details', 'input',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_radiation_details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '451', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');















