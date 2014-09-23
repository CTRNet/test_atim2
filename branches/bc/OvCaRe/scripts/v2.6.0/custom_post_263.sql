-- Tx --

UPDATE treatment_controls SET disease_site = '', databrowser_label = tx_method WHERE flag_active = 1;

-- EVENT --

UPDATE event_controls SET disease_site = '', databrowser_label = event_type, flag_use_for_ccl = '0' WHERE flag_active = 1;
UPDATE event_controls SET use_addgrid = 1 WHERE flag_active = 1 AND event_type != 'brca';
UPDATE event_controls SET use_detail_form_for_index = 1 WHERE flag_active = 1;
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_vital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ca125s') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_ca125s' AND `field`='ca125' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '1', 'test date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
REPLACE INTO i18n (id,en) VALUES ('follow-up date can not be empty','Follow-up date can not be empty');
ALTER TABLE ovcare_ed_brcas_revs DROP INDEX event_master_id;
ALTER TABLE ovcare_ed_ca125s_revs DROP INDEX event_master_id;
ALTER TABLE ovcare_ed_study_inclusions_revs DROP INDEX event_master_id;

-- Dx --

ALTER TABLE ovcare_dxd_others MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ovcare_dxd_ovaries MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ovcare_dxd_ovaries DROP COLUMN deleted;
ALTER TABLE ovcare_dxd_others_revs MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ovcare_dxd_ovaries_revs MODIFY diagnosis_master_id int(11) NOT NULL;

-- COLLECTION --

ALTER TABLE collections_revs DROP INDEX collection_voa_nbr;

-- SAMPLE --

ALTER TABLE sd_spe_salivas_revs DROP INDEX sample_master_id;
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(190); -- Saliva

-- OTHER.... --

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';





















TO REVIEW



UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Collection Types' WHERE name = 'ovcare collection types';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Tissue Sources' WHERE name = 'ovcare tissue sources';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'DNA/RNA Extraction Methods' WHERE name = 'dna rna extraction methods';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'DNA/RNA Enzyme Treatments' WHERE name = 'dna rna enzyme txs';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Tissue Tube Storage Methods' WHERE name = 'ovcare tissue tube storage methods';

UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Surgery type';
UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Tissue Types';
UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Biopsy Type';
UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Study Status';
UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Sample Test Status';
UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Sample Test Types';
UPDATE structure_permissible_values_custom_controls SET category = '' WHERE name = 'Vital Status';



| inventory                   |
| inventory - quality control |
| sop                         |
| clinical - consent          |
| undefined                   |
| order                       |
| storages                    |







PARTICIPANT IDENTIFIER REPORT
----------------------------------------------------------------------------------------------------------
Queries to desactivate 'Participant Identifiers' demo report
----------------------------------------------------------------------------------------------------------
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');



structure_permissible_values_custom_controls category to set (nothing to do if empty)
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------




