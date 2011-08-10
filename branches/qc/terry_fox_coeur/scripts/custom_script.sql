ALTER TABLE `participants` CHANGE `qc_tf_sdod_accuracy` `qc_tf_suspected_date_of_death_accuracy` CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE `participants` CHANGE `qc_tf_last_contact_acc` `qc_tf_last_contact_accuracy` CHAR(1) NOT NULL DEFAULT '';
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'qc_tf_last_contact_acc');
DELETE FROM structure_fields WHERE field = 'qc_tf_last_contact_acc';

DELETE FROM structure_fields WHERE field = 'date_of_ca125_progression_accu' AND tablename = 'qc_tf_dxd_eocs';

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET lab_book_control_id = null;

UPDATE structure_formats 
SET flag_add='0',flag_add_readonly='0',flag_edit='0',flag_edit_readonly='0',flag_search='0',flag_search_readonly='0',flag_addgrid='0',flag_addgrid_readonly='0',flag_editgrid='0',flag_editgrid_readonly='0',flag_summary='0',flag_batchedit='0',flag_batchedit_readonly='0',flag_index='0',flag_detail='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model IN ('AliquotMaster','ViewAliquot') AND field IN ('sop_master_id','aliquot_label'));

UPDATE aliquot_controls SET form_alias = 'aliquot_masters,qc_tf_ad_spec_tiss_tubes' WHERE form_alias = 'aliquot_masters,ad_spec_tubes_vol';

UPDATE structures SET alias = 'qc_tf_ad_spec_tiss_tubes' WHERE alias = 'ad_spec_tubes_vol';

ALTER TABLE ad_blocks
 DROP COLUMN qc_tf_flash_frozen_volume;
ALTER TABLE ad_blocks
 DROP COLUMN qc_tf_flash_frozen_volume_unit; 
 
ALTER TABLE ad_blocks_revs
 DROP COLUMN qc_tf_flash_frozen_volume;
ALTER TABLE ad_blocks_revs
 DROP COLUMN qc_tf_flash_frozen_volume_unit; 

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('initial_volume', 'aliquot_volume_unit'));

DELETE FROM structure_fields WHERE field = 'aliquot_volume_unit' AND language_label = 'mm³';

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_tf_ad_spec_tiss_tubes');

DELETE FROM structure_fields WHERE field = 'initial_volume' AND setting = 'size=3';
DELETE FROM structure_fields WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_flash_frozen_volume_unit');
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_flash_frozen_volume_unit");
DELETE FROM  structure_value_domains WHERE domain_name="qc_tf_flash_frozen_volume_unit";

SET @source_id = (SELECT id FROM structures WHERE alias = 'ad_spec_tubes_incl_ml_vol');
SET @dest_id = (SELECT id FROM structures WHERE alias = 'qc_tf_ad_spec_tiss_tubes');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
(SELECT @dest_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats WHERE structure_id = @source_id);

ALTER TABLE ad_tubes
 ADD COLUMN qc_tf_weight_mg decimal(10,5) DEFAULT NULL AFTER hemolysis_signs,
 ADD COLUMN qc_tf_size_mm3 decimal(10,5) DEFAULT NULL AFTER qc_tf_weight_mg;
ALTER TABLE ad_tubes_revs
 ADD COLUMN qc_tf_weight_mg decimal(10,5) DEFAULT NULL AFTER hemolysis_signs,
 ADD COLUMN qc_tf_size_mm3 decimal(10,5) DEFAULT NULL AFTER qc_tf_weight_mg;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_tf_weight_mg', 'float',  NULL , '0', 'size=3', '', '', 'qc tf weight mg', ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_tf_size_mm3', 'float',  NULL , '0', 'size=3', '', '', 'qc tf size mm3', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_tf_weight_mg' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='qc tf weight mg' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_tf_size_mm3' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='qc tf size mm3' AND `language_tag`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0');

ALTER TABLE ad_tubes
  ADD `qc_tf_storage_solution` varchar(30) DEFAULT NULL AFTER `qc_tf_size_mm3`,
  ADD `qc_tf_storage_method` varchar(30) DEFAULT NULL AFTER `qc_tf_storage_solution`;
 ALTER TABLE ad_tubes_revs
  ADD `qc_tf_storage_solution` varchar(30) DEFAULT NULL AFTER `qc_tf_size_mm3`,
  ADD `qc_tf_storage_method` varchar(30) DEFAULT NULL AFTER `qc_tf_storage_solution`;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('qc_tf_tissue_storage_solution', '', '', NULL),('qc_tf_tissue_storage_method', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("OCT", "OCT"),("flash frozen","flash frozen");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_storage_method"),  (SELECT id FROM structure_permissible_values WHERE value="flash frozen" AND language_alias="flash frozen"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_storage_solution"),  (SELECT id FROM structure_permissible_values WHERE value="OCT" AND language_alias="OCT"), "0", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_tf_storage_solution', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_storage_solution") , '0', 'size=3', '', '', 'storage solution', ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_tf_storage_method', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_storage_method") , '0', 'size=3', '', '', 'storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_tf_storage_solution'), '1', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_tf_storage_method'), '1', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET setting = '' WHERE field in ('qc_tf_storage_method','qc_tf_storage_solution');

INSERT IGNORE INTO i18n (id,en) VALUES
('qc tf weight mg', 'Weight (mg)'),('qc tf size mm3','Size (mm³)'),
('storage solution','Storage Solution'),('storage method','Storage Method'),('flash frozen','Flash Frozen'); 

UPDATE aliquot_controls SET volume_unit = 'ml' WHERE form_alias LIKE '%qc_tf_ad_spec_tiss_tubes%'; 

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(3);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(119, 16);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(1);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(8);

ALTER TABLE ad_tubes
 ADD COLUMN qc_tf_weight_ug decimal(10,5) DEFAULT NULL AFTER qc_tf_weight_mg;
ALTER TABLE ad_tubes_revs
 ADD COLUMN qc_tf_weight_ug decimal(10,5) DEFAULT NULL AFTER qc_tf_weight_mg;

UPDATE aliquot_controls SET form_alias = 'aliquot_masters,qc_tf_ad_dna_tubes' WHERE id = 28 AND sample_control_id = 12;
INSERT INTO structures (`alias`) VALUES ('qc_tf_ad_dna_tubes');

SET @source_id = (SELECT id FROM structures WHERE alias = 'ad_der_tubes_incl_ul_vol_and_conc');
SET @dest_id = (SELECT id FROM structures WHERE alias = 'qc_tf_ad_dna_tubes');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
(SELECT @dest_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats WHERE structure_id = @source_id);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_tf_weight_ug', 'float',  NULL , '0', 'size=3', '', '', 'qc tf weight ug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ad_dna_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_tf_weight_ug'), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0');
INSERT IGNORE INTO i18n (id,en) VALUES
('qc tf weight ug', 'Weight (ug)');

ALTER TABLE `participants_revs` CHANGE `qc_tf_sdod_accuracy` `qc_tf_suspected_date_of_death_accuracy` CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE `participants_revs` CHANGE `qc_tf_last_contact_acc` `qc_tf_last_contact_accuracy` CHAR(1) NOT NULL DEFAULT '';

ALTER TABLE qc_tf_dxd_eocs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_dxd_eocs_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_dxd_other_primary_cancers DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_dxd_other_primary_cancers_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_dxd_progression_and_recurrences DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_dxd_progression_and_recurrences_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_ed_ca125s DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_ed_ca125s_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_ed_ct_scans DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_ed_ct_scans_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_ed_no_details DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_ed_no_details_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_tx_empty DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
ALTER TABLE qc_tf_tx_empty_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted_date;
 
ALTER TABLE qc_tf_dxd_eocs_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_other_primary_cancers_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_progression_and_recurrences_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_ca125s_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_ct_scans_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_no_details_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_tx_empty_revs DROP COLUMN deleted;

DELETE FROM structure_value_domains_permissible_values
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tumor_site")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable");

insert INTO i18n (id,en) VALUES
('bank is required','Bank is required!'),
('BRCA mutation known but not identified','BRCA mutation known but not identified'),
('BRCA1 mutated','BRCA1 mutated'),
('BRCA1/2 mutated','BRCA1/2 mutated'),
('BRCA2 mutated','BRCA2 mutated'),
('breast cancer','Breast Cancer'),
('Breast-Breast','Breast-Breast'),
('CBCF-COEUR','CBCF-COEUR'),
('Central Nervous System-Brain','Central Nervous System-Brain'),
('Central Nervous System-Other Central Nervous Syste...','Central Nervous System-Other Central Nervous Syste...'),
('Central Nervous System-Spinal Cord','Central Nervous System-Spinal Cord'),
('CHUM-COEUR','CHUM-COEUR'),
('CHUQ-COEUR','CHUQ-COEUR'),
('CHUS-COEUR','CHUS-COEUR'),
('clear cells','Clear Cells'),
('colon and breast cancer','Colon and Breast Cancer'),
('colon and endometrial cancer','Colon and Endometrial Cancer'),
('colon cancer','Colon Cancer'),
('Consent status field is required.','Consent status field is required.'),
('Digestive-Anal','Digestive-Anal'),
('Digestive-Appendix','Digestive-Appendix'),
('Digestive-Bile Ducts','Digestive-Bile Ducts'),
('Digestive-Colonic','Digestive-Colonic'),
('Digestive-Esophageal','Digestive-Esophageal'),
('Digestive-Gallbladder','Digestive-Gallbladder'),
('Digestive-Liver','Digestive-Liver'),
('Digestive-Other Digestive','Digestive-Other Digestive'),
('Digestive-Pancreas','Digestive-Pancreas'),
('Digestive-Rectal','Digestive-Rectal'),
('Digestive-Small Intestine','Digestive-Small Intestine'),
('Digestive-Stomach','Digestive-Stomach'),
('endometrial cancer','Endometrial Cancer'),
('EOC','EOC'),
('Female Genital-Cervical','Female Genital-Cervical'),
('Female Genital-Endometrium','Female Genital-Endometrium'),
('Female Genital-Fallopian Tube','Female Genital-Fallopian Tube'),
('Female Genital-Gestational Trophoblastic Neoplasia','Female Genital-Gestational Trophoblastic Neoplasia'),
('Female Genital-Other Female Genital','Female Genital-Other Female Genital'),
('Female Genital-Ovary','Female Genital-Ovary'),
('Female Genital-Peritoneal','Female Genital-Peritoneal'),
('Female Genital-Peritoneal Pelvis Abdomen','Female Genital-Peritoneal Pelvis Abdomen'),
('Female Genital-Uterine','Female Genital-Uterine'),
('Female Genital-Vagina','Female Genital-Vagina'),
('Female Genital-Vulva','Female Genital-Vulva'),
("Haematological-Hodgkin's Disease","Haematological-Hodgkin's Disease"),
('Haematological-Leukemia','Haematological-Leukemia'),
('Haematological-Lymphoma','Haematological-Lymphoma'),
("Haematological-Non-Hodgkin's Lymphomas","Haematological-Non-Hodgkin's Lymphomas"),
('Haematological-Other Haematological','Haematological-Other Haematological'),
('Head & Neck-Larynx','Head & Neck-Larynx'),
('Head & Neck-Lip and Oral Cavity','Head & Neck-Lip and Oral Cavity'),
('Head & Neck-Nasal Cavity and Sinuses','Head & Neck-Nasal Cavity and Sinuses'),
('Head & Neck-Other Head & Neck','Head & Neck-Other Head & Neck'),
('Head & Neck-Pharynx','Head & Neck-Pharynx'),
('Head & Neck-Salivary Glands','Head & Neck-Salivary Glands'),
('Head & Neck-Thyroid','Head & Neck-Thyroid'),
('high grade serous','High Grade Serous'),
('Ia','Ia'),
('Ib','Ib'),
('Ic','Ic'),
('IIa','IIa'),
('IIb','IIb'),
('IIc','IIc'),
('III','III'),
('IIIa','IIIa'),
('IIIb','IIIb'),
('IIIc','IIIc'),
('IV','IV'),
('low grade serous','Low Grade Serous'),
('McGill-COEUR','McGill-COEUR'),
('Musculoskeletal Sites-Bone','Musculoskeletal Sites-Bone'),
('Musculoskeletal Sites-Other Bone','Musculoskeletal Sites-Other Bone'),
('Musculoskeletal Sites-Soft Tissue Sarcoma','Musculoskeletal Sites-Soft Tissue Sarcoma'),
('non applicable','Non Applicable'),
('OHRI-COEUR','OHRI-COEUR'),
('Ophthalmic-Eye','Ophthalmic-Eye'),
('Ophthalmic-Other Eye','Ophthalmic-Other Eye'),
('Other-Gross Metastatic Disease','Other-Gross Metastatic Disease'),
('Other-Primary Unknown','Other-Primary Unknown'),
('ovarian and breast cancer','Ovarian and Breast Cancer'),
('ovarian and colon cancer','Cvarian and Colon Cancer'),
('ovarian and endometrial cancer','Ovarian and Endometrial Cancer'),
('ovarian cancer','Ovarian Cancer'),
('ovarian, endometrial and colon cancer','Ovarian, Endometrial and Colon Cancer'),
('OVCare','OVCare'),
('precursor of benign ovarian lesions','Precursor of Benign Ovarian Lesions'),
('site detection','Site Detection'),
('Skin-Melanoma','Skin-Melanoma'),
('Skin-Non Melanomas','Skin-Non Melanomas'),
('Skin-Other Skin','Skin-Other Skin'),
('supported value','Supported Value'),
('Thoracic-Lung','Thoracic-Lung'),
('Thoracic-Mesothelioma','Thoracic-Mesothelioma'),
('Thoracic-Other Thoracic','Thoracic-Other Thoracic'),
('TTR-COEUR','TTR-COEUR'),
('unmatched value','Unmatched Value'),
('Urinary Tract-Bladder','Urinary Tract-Bladder'),
('Urinary Tract-Kidney','Urinary Tract-Kidney'),
('Urinary Tract-Other Urinary Tract','Urinary Tract-Other Urinary Tract'),
('Urinary Tract-Renal Pelvis and Ureter','Urinary Tract-Renal Pelvis and Ureter'),
('Urinary Tract-Urethra','Urinary Tract-Urethra'),
('Central Nervous System-Other Central Nervous System', 'Central Nervous System-Other Central Nervous System'),
('histopathology','Histopathology'),
('wild type','Wild Type');

ALTER TABLE diagnosis_masters
 DROP COLUMN qc_tf_tumor_site;
ALTER TABLE diagnosis_masters_revs
 DROP COLUMN qc_tf_tumor_site;

ALTER TABLE diagnosis_masters
 ADD COLUMN qc_tf_tumor_site VARCHAR(150) DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN qc_tf_tumor_site VARCHAR(150) DEFAULT '';

UPDATE structure_formats
SET structure_field_id = (SELECT id FROM structure_fields WHERE field = 'age_at_dx' AND language_label = 'age_at_dx')
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_tf_dx_eoc','qc_tf_dxd_other_primary_cancer'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'age_at_dx');

DELETE FROM structure_fields WHERE field = 'age_at_dx' AND setting = 'size=3';

insert INTO i18n (id,en) VALUES
('benign  or borderline tumours','Benign or Borderline Tumours'),
('benign tumors','Benign Tumors'),
('bouncer','Bouncer'),
('ca125 progression time in months','CA125 progression time in months'),
('endometriosis','Endometriosis'),
('endosalpingiosis','Endosalpingiosis'),
('fallopian tube lesion','Fallopian tube lesion'),
('figo','Figo'),
('follow up from ovarectomy (months)','Follow up from ovarectomy (months)'),
('malignant tumors','Malignant Tumors'),
('miliary','Miliary'),
('mixed','Mixed'),
('ovarian cysts','Ovarian Cysts'),
('progression status','Progression Status'),
('progression time (months)','Progression Time (months)'),
('salpingitis','Salpingitis'),
('suboptimal','Suboptimal'),
('survival from ovarectomy (months)','Survival from Ovarectomy (months)'),
('undifferentiated','Undifferentiated'),
('yes unknown','Yes Unknown');

UPDATE datamart_browsing_controls SET flag_active_2_to_1 = 0, flag_active_1_to_2 = 0
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ConsentMaster','FamilyHistory','ParticipantMessage','SpecimenReviewMaster'));
UPDATE datamart_browsing_controls SET flag_active_2_to_1 = 0, flag_active_1_to_2 = 0
WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ConsentMaster','FamilyHistory','ParticipantMessage','SpecimenReviewMaster'));

UPDATE diagnosis_controls SET databrowser_label = controls_type WHERE databrowser_label LIKE '';

