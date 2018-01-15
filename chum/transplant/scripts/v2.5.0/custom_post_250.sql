-- MiscIdentifier CleanUp

SELECT 'DUPLICATED MISCIDENTIFIER CHECK' AS msg;

SELECT 'identifier to check' AS msg;

SELECT id.identifier_value, mic.misc_identifier_name, part.first_name, part.last_name, part.id
FROM misc_identifiers id
INNER JOIN (
  SELECT identifier_value 
  FROM misc_identifiers AS mi 
  INNER JOIN misc_identifier_controls AS mic ON mi.misc_identifier_control_id=mic.id 
  WHERE deleted=0 GROUP BY identifier_value, misc_identifier_control_id HAVING COUNT(*) > 1
) AS dup ON dup.identifier_value = id.identifier_value
INNER JOIN misc_identifier_controls AS mic ON id.misc_identifier_control_id=mic.id 
INNER JOIN participants AS part ON part.id = id.participant_id
WHERE id.deleted=0 ORDER BY id.identifier_value;

UPDATE misc_identifiers AS ident
INNER JOIN (
  SELECT identifier_value 
  FROM misc_identifiers AS mi 
  INNER JOIN misc_identifier_controls AS mic ON mi.misc_identifier_control_id=mic.id 
  WHERE deleted=0 GROUP BY identifier_value, misc_identifier_control_id HAVING COUNT(*) > 1
) AS dup ON dup.identifier_value = ident.identifier_value
SET ident.identifier_value = CONCAT(ident.identifier_value,' **DUP?**',ident.id)
WHERE ident.deleted=0;

SELECT 'identifiers changed to' AS msg;

SELECT id.identifier_value, mic.misc_identifier_name, part.first_name, part.last_name, part.id
FROM misc_identifiers id
INNER JOIN misc_identifier_controls AS mic ON id.misc_identifier_control_id=mic.id 
INNER JOIN participants AS part ON part.id = id.participant_id
WHERE id.deleted=0 AND id.identifier_value LIKE '%**DUP?**%' ORDER BY id.identifier_value;

SELECT 'END DUPLICATED MISCIDENTIFIER CHECK' AS msg;

-- End MiscIdentifier CleanUp

UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
UPDATE misc_identifiers mi INNER JOIN misc_identifiers_revs mi_r ON mi.id=mi_r.id SET mi_r.flag_unique=mi.flag_unique;

ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN years_quit_smoking;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN years_quit_smoking;

REPLACE INTO i18n(id, en, fr) VALUES
("naturally", "Naturally", "Naturellement"),
("by medication", "By medication", "Par médication"),
("by surgery", "By surgery", "Par chirurgie"),
('laboratory name', 'Laboratory name', 'Nom du laboratoire'),
("partially", "Partially", "Partiellement");

UPDATE misc_identifier_controls SET reg_exp_validation='^H[\\d]+$', user_readable_format='H#', misc_identifier_format='H' WHERE id=8;
UPDATE misc_identifier_controls SET reg_exp_validation='^N[\\d]+$', user_readable_format='N#', misc_identifier_format='N' WHERE id=9;
UPDATE misc_identifier_controls SET reg_exp_validation='^S[\\d]+$', user_readable_format='S#', misc_identifier_format='S' WHERE id=10;

UPDATE datamart_browsing_controls SET flag_active_1_to_2=1, flag_active_2_to_1=1 WHERE id1=11;

UPDATE structure_fields SET tablename='specimen_details' WHERE model='SpecimenDetail' AND field='sequence_number';
UPDATE structure_fields SET tablename='specimen_details' WHERE model='SpecimenDetail' AND field='type_code';

UPDATE structure_formats SET `display_order`='29' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='28' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='has_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_shipping_cie", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'qc_nd_shipping_cie\')");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_shipping_cie')  WHERE model='Shipment' AND tablename='shipments' AND field='shipping_company' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc_nd_shipping_cie', 1, 255);

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted)
(SELECT 16, shipping_company, shipping_company, shipping_company, 0, 1, NOW(), 1, NOW(), 1, 0 FROM shipments WHERE shipping_company NOT IN('NULL', '') GROUP BY shipping_company);

UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_shipping_cie') ,  `setting`='' WHERE model='Shipment' AND tablename='shipments' AND field='shipping_company' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_shipping_cie');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  WHERE model='Order' AND tablename='orders' AND field='contact' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') ,  `language_label`='laboratory name' WHERE model='Order' AND tablename='orders' AND field='institution' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution');

UPDATE structure_fields SET  `setting`='',  `language_label`='detail' WHERE model='Order' AND tablename='' AND field='microarray_chip' AND `type`='input' AND structure_value_domain  IS NULL ;

DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='order_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE sample_masters
 CHANGE sample_label qc_nd_sample_label VARCHAR(60) NOT NULL DEFAULT '';
ALTER TABLE sample_masters_revs
 CHANGE sample_label qc_nd_sample_label VARCHAR(60) NOT NULL DEFAULT '';
 
UPDATE structure_fields SET field='qc_nd_sample_label' WHERE field='sample_label';

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_pt') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ct') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("y_n_partially", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("y", "yes");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="y_n_partially"), (SELECT id FROM structure_permissible_values WHERE value="y" AND language_alias="yes"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("p", "partially");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="y_n_partially"), (SELECT id FROM structure_permissible_values WHERE value="p" AND language_alias="partially"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("n", "no");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="y_n_partially"), (SELECT id FROM structure_permissible_values WHERE value="n" AND language_alias="no"), "3", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='y_n_partially')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='chemo_completed' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');


UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='facility')  WHERE model='TreatmentDetail' AND tablename='' AND field='location' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("naturally", "naturally");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_menopause_cause"), (SELECT id FROM structure_permissible_values WHERE value="naturally" AND language_alias="naturally"), "", "1");

UPDATE structure_formats SET `display_order`='2', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='' AND `field`='position_into_run' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='used aliquot type' WHERE model='AliquotControl' AND tablename='aliquot_controls' AND field='aliquot_type' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE quality_ctrls SET conclusion=LOWER(conclusion);
UPDATE structure_fields SET  `type`='integer_positive',  `setting`='' WHERE model='QualityCtrl' AND tablename='' AND field='position_into_run' AND `type`='input' AND structure_value_domain  IS NULL ;

ALTER TABLE quality_ctrls
 MODIFY position_into_run TINYINT UNSIGNED DEFAULT NULL;
ALTER TABLE quality_ctrls_revs
 MODIFY position_into_run TINYINT UNSIGNED DEFAULT NULL;

UPDATE structure_formats SET structure_field_id=202 WHERE structure_field_id=2071;
DELETE FROM structure_fields WHERE id=2071;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`=''), '2', '100', 'derivative data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0'), '2', '200', '', '1', 'created by', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '300', '', '1', 'creation date', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc_nd_tmp_extraction_method', 1, 30); 
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted)
(SELECT 20, value, language_alias, language_alias, 0, 1, NOW(), 1, NOW(), 1, 0 from structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id where structure_value_domain_id=232);
UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown(\'qc_nd_tmp_extraction_method\')" WHERE id=232;

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_pt') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='tnm_g' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='' AND `field`='chip_model' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_chip_model') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_addgrid`='1', `flag_addgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

TRUNCATE acos;

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster','TreatmentMaster','FamilyHistory')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster','TreatmentMaster','FamilyHistory'));

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/ProtocolMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters%';
UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/lifestyle/%%Participant.id%%' WHERE id = 'clin_CAN_4';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%' AND id NOT IN ('clin_CAN_4','clin_CAN_30');
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs%';

UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE participants SET sardo_medical_record_number = '', last_sardo_import_date = null;
UPDATE participants_revs SET sardo_medical_record_number = '', last_sardo_import_date = null;

UPDATE event_controls SET flag_active = 0;
UPDATE event_controls SET flag_active = 1 WHERE id = 11;

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sardo_participant_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='is_anonymous' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_followup' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_followup_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_questionnaire' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_questionnaire_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_additional_data' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_significant_discovery' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_frsq') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_discovery_on_other_disease' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND flag_search = '1';
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_general') AND flag_search = '1';
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_pre_frsq') AND flag_search = '1';

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND flag_search = '1';

-- Profile

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='anonymous_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_anonymous_reason') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_from_center' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE flag_add = '0' AND structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='is_anonymous' AND `language_label`='is anonymous' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Consent

-- Annotation

UPDATE event_controls SET disease_site = 'procure', event_type = 'questionnaire' WHERE event_type = 'procure (questionnaire)';
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_all_procure_lifestyle');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_ed_all_procure_lifestyle') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_all_procure_lifestyles' AND `field`='validated' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%' AND id NOT IN ('clin_CAN_4','clin_CAN_30');
UPDATE event_controls SET databrowser_label = CONCAT(event_group,'|',event_type,'|',disease_site) WHERE event_type = 'questionnaire' AND disease_site = 'procure';
UPDATE structure_fields SET plugin = 'ClinicalAnnotation' WHERE tablename = 'qc_nd_ed_all_procure_lifestyles';

-- reproductuve histo

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_cause' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_menopause_cause') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_aborta' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- participant contacts

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND `flag_index`='1';

-- Message

-- Collection

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('no labos [%s] matche old bank numbers', 'No Labos [%s] matche old bank numbers', 'Les No Labos [%s] correspondent à des anciens numéros de banque');

UPDATE structure_formats SET `display_column`='1', `display_order`='10000' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='10000' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='sample_code');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Sample

-- Aliquot

UPDATE structure_formats SET `display_order`='2001', `language_heading`='', `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1202', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';

DROP VIEW view_aliquot_uses;

CREATE VIEW `view_aliquot_uses` AS 

SELECT concat(`source`.`id`,1) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'sample derivative creation' AS `use_definition`,
CONCAT(samp.qc_nd_sample_label, ' [', samp.sample_code,']') AS `use_code`,
'' AS `use_details`,
`source`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`der`.`creation_datetime` AS `use_datetime`,
`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`der`.`creation_by` AS `used_by`,
`source`.`created` AS `created`,
concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,
`samp2`.`id` AS `sample_master_id`,
`samp2`.`collection_id` AS `collection_id` 
FROM (((((`source_aliquots` `source` 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `source`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
JOIN `derivative_details` `der` ON ((`samp`.`id` = `der`.`sample_master_id`))) 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `source`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp2` ON (((`samp2`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) WHERE (`source`.`deleted` <> 1) 

UNION ALL
 
SELECT concat(`realiq`.`id`,2) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'realiquoted to' AS `use_definition`,
CONCAT(child.aliquot_label,' [',child.barcode,']') AS `use_code`,
'' AS `use_details`,
`realiq`.`parent_used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`realiq`.`realiquoting_datetime` AS `use_datetime`,
`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`realiq`.`realiquoted_by` AS `used_by`,
`realiq`.`created` AS `created`,
concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM ((((`realiquotings` `realiq` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `aliquot_masters` `child` ON (((`child`.`id` = `realiq`.`child_aliquot_master_id`) AND (`child`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`realiq`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`qc`.`id`,3) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'quality control' AS `use_definition`,
`qc`.`qc_code` AS `use_code`,
'' AS `use_details`,
`qc`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`qc`.`date` AS `use_datetime`,
`qc`.`date_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`qc`.`run_by` AS `used_by`,
`qc`.`created` AS `created`,
concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`quality_ctrls` `qc` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `qc`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`qc`.`deleted` <> 1)

UNION ALL 

SELECT concat(`item`.`id`,4) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'aliquot shipment' AS `use_definition`,
CONCAT(sh.shipment_code, ' - ', sh.recipient) AS `use_code`,
'' AS `use_details`,
'' AS `used_volume`,
'' AS `aliquot_volume_unit`,
`sh`.`datetime_shipped` AS `use_datetime`,
`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`sh`.`shipped_by` AS `used_by`,
`sh`.`created` AS `created`,
concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`order_items` `item` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `item`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `shipments` `sh` ON (((`sh`.`id` = `item`.`shipment_id`) AND (`sh`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`item`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`alr`.`id`,5) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'specimen review' AS `use_definition`,
`spr`.`review_code` AS `use_code`,
'' AS `use_details`,
'' AS `used_volume`,
'' AS `aliquot_volume_unit`,
`spr`.`review_date` AS `use_datetime`,
`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
'' AS `used_by`,
`alr`.`created` AS `created`,
concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`aliquot_review_masters` `alr` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `alr`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `specimen_review_masters` `spr` ON (((`spr`.`id` = `alr`.`specimen_review_master_id`) AND (`spr`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`alr`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`aluse`.`id`,6) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
`aluse`.`type` AS `use_definition`,
`aluse`.`use_code` AS `use_code`,
`aluse`.`use_details` AS `use_details`,
`aluse`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`aluse`.`use_datetime` AS `use_datetime`,
`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,
`aluse`.`duration` AS `duration`,
`aluse`.`duration_unit` AS `duration_unit`,
`aluse`.`used_by` AS `used_by`,
`aluse`.`created` AS `created`,
concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`aliquot_internal_uses` `aluse` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `aluse`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`aluse`.`deleted` <> 1);

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';

