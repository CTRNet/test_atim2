-- install 2.1.1
-- run this custom script

-- Under Consent, remove Date of Referral, Process Status, and Facility.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='facility' AND type='select' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='process_status' AND type='select' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='date_of_referral' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='facility_other' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='route_of_referral' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='recruit_route'));

-- Under Diagnosis > Tissue, remove Survival Time in Months, Information Source, Previous Disease Code System.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='information_source' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='information_source'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='previous_primary_code_system' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='survival_time_months' AND type='integer_positive' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='previous_primary_code' AND type='input' AND structure_value_domain  IS NULL );

-- Under Annotation, delete Follow-up.
UPDATE event_controls SET flag_active=false WHERE id=20;

-- Under Treatment > Chemotherapy, remove Treatment Facility and Surgery Without Extend.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='facility' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='facility'));

-- Under Treatment > Radiation, remove Treatment Facility and Surgery Without Extend.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='facility' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='facility'));

-- Under Treatment > Surgery, remove Treatment Facility and Surgery Without Extend.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='facility' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='facility'));

-- Delete Contacts.
-- Delete Message.
UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_25', 'clin_CAN_26');

-- Under Inventory, rename Participant Identifier to “RAMQ”.
UPDATE structure_fields SET language_label='ramq#' WHERE id IN(925, 955);
UPDATE structure_formats SET flag_override_label='0', language_label='' WHERE id=2531;

-- Under Inventory, rename Acquisition Label to “Biobank ID”.
UPDATE structure_fields SET language_label='biobank id' WHERE id IN(152, 910);

-- Under Inventory, remove Bank, Collection Site, and Collection SOP.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='bank_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='banks'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='collection_site' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));

-- Under Inventory > Blood, remove Sample SOP and list Supplier Department and Taken Delivery By.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='supplier_dept' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));

-- Under Inventory > Blood > Aliquot > Tube, remove Aliquot SOP and add a field, “Tube ID” (which will be formatted in a similar fashion to “Y-10-001-ser1”, hence a text field).
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list'));

-- Under Inventory > Tissue > Aliquot > Block, remove PathoCode
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotDetail' AND tablename='' AND field='patho_dpt_block_code' AND type='input' AND structure_value_domain  IS NULL );

-- Under Inventory > Tissue > Aliquot > Block, add new searchable field, “Mold ID” (which will be formatted in a similar fashion to “Y-10-001-m2”, hence a text field).
ALTER TABLE ad_blocks 
 ADD qc_gastro_mold_id VARCHAR(50) NOT NULL DEFAULT '' AFTER patho_dpt_block_code;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_gastro_mold_id', 'mold id', '', 'input', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qc_gastro_mold_id' AND `language_label`='mold id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotDetail' AND tablename='' AND field='patho_dpt_block_code' AND type='input' AND structure_value_domain  IS NULL );

-- For each aliquot, under Add Uses > Add Internal Uses, add the text field “Number of Slices”
ALTER TABLE aliquot_uses
 ADD qc_gastro_nb_slices SMALLINT DEFAULT NULL AFTER study_summary_id;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotUse', 'aliquot_uses', 'qc_gastro_nb_slices', 'number of slices', '', 'integer', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotuses'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='qc_gastro_nb_slices' AND `language_label`='number of slices' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');


INSERT INTO misc_identifier_controls(misc_identifier_name, misc_identifier_name_abbrev, flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant) VALUES
("régime d'assurance maladie du québec", 'RAMQ', 1, 4, '', '', 1);

DROP VIEW view_collections;
CREATE VIEW `view_collections` AS SELECT `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
 `link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
 `identifier`.`identifier_value` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
 `col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
 `col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,
 `banks`.`name` AS `bank_name`,`col`.`created` AS `created` 
FROM `collections` `col` LEFT JOIN `clinical_collection_links` `link` ON `col`.`id` = `link`.`collection_id` AND `link`.`deleted` <> 1 
 LEFT JOIN `misc_identifiers` `identifier` ON `link`.`participant_id` = `identifier`.`participant_id` AND `identifier`.`deleted` <> 1 AND identifier.misc_identifier_control_id=4 
 LEFT JOIN `banks` ON `col`.`bank_id` = `banks`.`id` AND `banks`.`deleted` <> 1 WHERE `col`.`deleted` <> 1;

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc_gastro_tissue_source_list', 1, 20);
UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown('qc_gastro tissue source list')" WHERE domain_name='tissue_source_list'; 

REPLACE INTO i18n (id, en, fr) VALUES
('biobank id', 'Biobank ID', 'Biobank ID'),
('ramq#', 'RAMQ #', '# RAMQ'),
('mold id', 'Mold ID', 'Mold ID'),
("régime d'assurance maladie du québec", "Régime d'Assurance Maladie du Québec", "Régime d'Assurance Maladie du Québec"); 
