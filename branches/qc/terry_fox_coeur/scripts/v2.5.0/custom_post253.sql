UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs/%';

UPDATE structure_formats SET structure_field_id = (SELECT id FROM structure_fields WHERE field = 'volume_unit' AND model = 'AliquotControl') WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'aliquot_volume_unit' AND model = 'AliquotMaster');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(164, 16, 118, 8, 187, 9);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(10);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11);

UPDATE event_controls SET flag_active = 0 WHERE detail_form_alias like 'ed_cap_report%';

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages%';

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_cell_tubes' AND `field`='concentration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_concentration_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cell_viability' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- New request: 2012-11-22 add aliquot label
-- ---------------------------------------------------------------------------------------------------------------------------------------

-- Done 20121122

ALTER TABLE qc_tf_ed_ca125s MODIFY precision_u decimal(10,2) DEFAULT NULL;
ALTER TABLE qc_tf_ed_ca125s_revs MODIFY precision_u decimal(10,2) DEFAULT NULL;

-- TODO 20121122

SELECT participant_id as id_of_part_having_more_than_one_ident, nbr_of_ids FROM (SELECT COUNT(*) as nbr_of_ids, participant_id FROM misc_identifiers GROUP BY participant_id) AS res WHERE res.nbr_of_ids > 1;

SELECT distinct bk.name, idc.misc_identifier_name 
FROM misc_identifier_controls idc 
INNER JOIN misc_identifiers AS idm ON idm.misc_identifier_control_id = idc.id
INNER JOIN participants AS par ON par.id = idm.participant_id
INNER JOIN banks as bk ON bk.id = par.qc_tf_bank_id;

ALTER TABLE participants ADD qc_tf_bank_identifier varchar(40) DEFAULT null;
ALTER TABLE participants_revs ADD qc_tf_bank_identifier varchar(40) DEFAULT null;

UPDATE participants par,misc_identifiers mid
SET par.qc_tf_bank_identifier = mid.identifier_value
WHERE par.deleted <> 1 AND mid.deleted <> 1 AND mid.participant_id = par.id;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_bank_identifier', 'input',  NULL , '1', 'size=20', '', '', 'participant bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='participant bank identifier' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE misc_identifiers SET deleted = 1;
UPDATE misc_identifier_controls SET flag_active = 0;
INSERT INTO i18n(id,en) VALUES ('participant bank identifier','Bank#');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', '', 'qc_tf_bank_identifier', 'input',  NULL , '1', 'size=20', '', '', 'participant bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='' AND `field`='qc_tf_bank_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='participant bank identifier' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='' AND `field`='qc_tf_bank_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ViewCollection', '', 'qc_tf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '1', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_fields SET  `model`='ViewCollection' WHERE model='Participant' AND tablename='' AND field='qc_tf_bank_identifier' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');
UPDATE collections SET bank_id = null;
UPDATE collections_revs SET bank_id = null;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ViewSample', '', 'qc_tf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '1', '', '', '', 'bank', ''), 
('ClinicalAnnotation', 'ViewSample', '', 'qc_tf_bank_identifier', 'input', NULL , '1', 'size=20', '', '', 'participant bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_bank_identifier' AND `type`='input' AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='participant bank identifier' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ViewAliquot', '', 'qc_tf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '1', '', '', '', 'bank', ''), 
('ClinicalAnnotation', 'ViewAliquot', '', 'qc_tf_bank_identifier', 'input',  NULL , '1', 'size=20', '', '', 'participant bank identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_bank_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='participant bank identifier' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');

REPLACE INTO i18n(id,en) VALUES ('participant bank identifier','Participant Bank#'),('participant identifier', 'Participant TFRI#');

UPDATE structure_fields SET language_label = 'aliquot barcode' WHERE language_label = 'barcode' AND model LIKE '%aliquot%' AND field = 'barcode';
REPLACE INTO i18n(id,en) VALUES ('aliquot barcode', 'Aliquot TFRI#');
UPDATE aliquot_masters SET barcode = id;
UPDATE aliquot_masters_revs SET barcode = id;
UPDATE structure_formats SET `flag_add`='0', flag_addgrid = '0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET flag_confidential = 1 WHERE  `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label';
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_bank_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_bank_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE structure_fields SET flag_confidential = 1 WHERE `field`='aliquot_label';
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

REPLACE INTO i18n (id,en) VALUES ('aliquot label','Aliquot TFRI Label');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'aliquot_label'), 'notEmpty', "");

SELECT 'next section should be done after view rebuild' as MSG;
exit

UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('FFPE', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'tissue'
AND va.aliquot_type = 'block';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('FT', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'tissue'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('PLA', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'plasma'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('DNA', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'dna'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('ASC', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'ascite'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('BC', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'blood cell'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('SER', ' ', va.qc_tf_bank_identifier, '[', banks.name, ']')
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'serum'
AND va.aliquot_type = 'tube';

UPDATE versions SET permissions_regenerated = 0;

SELECT al.id as aliquot_master_id_with_no_aliquot_label, col.id as collection_id, col.participant_id, col.deleted as col_deleted, al.deleted AS aliquot_deleted
FROM aliquot_masters al 
INNER JOIN collections col ON al.collection_id = col.id
WHERE (al.aliquot_label = '' OR al.aliquot_label IS NULL) AND al.deleted <> 1;

UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_id');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'Participant' AND field = 'qc_tf_bank_identifier'), 'notEmpty', "");


DROP VIEW IF EXISTS view_aliquot_uses;
DROP TABLE IF EXISTS view_aliquot_uses;

CREATE VIEW `view_aliquot_uses` AS 

SELECT concat(`source`.`id`,1) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'sample derivative creation' AS `use_definition`,
	CONCAT(sampc.sample_type, ' [', samp.sample_code,']') AS `use_code`,
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
FROM `source_aliquots` `source` 
JOIN `sample_masters` `samp` ON `samp`.`id` = `source`.`sample_master_id` AND `samp`.`deleted` <> 1
JOIN `sample_controls` `sampc` ON `sampc`.`id` = `samp`.`sample_control_id`
JOIN `derivative_details` `der` ON `samp`.`id` = `der`.`sample_master_id` 
JOIN `aliquot_masters` `aliq` ON `aliq`.`id` = `source`.`aliquot_master_id` AND `aliq`.`deleted` <> 1
JOIN `aliquot_controls` `aliqc` ON `aliq`.`aliquot_control_id` = `aliqc`.`id`
JOIN `sample_masters` `samp2` ON `samp2`.`id` = `aliq`.`sample_master_id` AND `samp`.`deleted` <> 1 WHERE `source`.`deleted` <> 1
			
UNION ALL
 
SELECT concat(`realiq`.`id`,2) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'realiquoted to' AS `use_definition`,
CONCAT(child.aliquot_label,' [',child.barcode,']')  AS `use_code`,
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

-- TODO 20121130

ALTER TABLE qc_tf_tx_empty DROP COLUMN id;
ALTER TABLE qc_tf_tx_empty_revs DROP COLUMN id;

ALTER TABLE qc_tf_ed_ca125s DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_ca125s_revs DROP COLUMN id;
ALTER TABLE qc_tf_ed_ct_scans DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_ct_scans_revs DROP COLUMN id;  
ALTER TABLE qc_tf_ed_no_details DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_no_details_revs DROP COLUMN id;  

ALTER TABLE qc_tf_dxd_eocs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_eocs_revs DROP COLUMN id;  
ALTER TABLE qc_tf_dxd_other_primary_cancers DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_other_primary_cancers_revs DROP COLUMN id;  
ALTER TABLE qc_tf_dxd_progression_and_recurrences DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_progression_and_recurrences_revs DROP COLUMN id;  

SELECT id as participant_id_with_missing_identifier FROM participants WHERE (qc_tf_bank_id IS NULL OR qc_tf_bank_id LIKE '' OR qc_tf_bank_identifier IS NULL OR qc_tf_bank_identifier LIKE '') AND deleted <> 1;

SELECT res.* FROM (select count(*) as part_duplicated_identifier, qc_tf_bank_id, qc_tf_bank_identifier FROM participants where deleted <> 1 GROUP BY qc_tf_bank_id, qc_tf_bank_identifier ) res WHERE res.part_duplicated_identifier > 1;

INSERT INTO i18n (id,en) VALUES ('this bank identifier has already been recorded for this bank','This bank identifier has already been recorded for this bank');

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- New request: 2012-12-10 add aliquot label
-- ---------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr) VALUES 
('at least one collection is linked to that bank', 'At least one collection is linked to that bank', 'Au moins une collection est attachée à cette banque'),
('at least one group is linked to that bank', 'At least one group is linked to that bank', 'Au moins un groupe est attaché à cette banque');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('confidential data','Confidential Data','Données confidentielles');

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';

UPDATE structure_formats SET `language_heading`='', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='quality control' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE aliquot_masters am SET am.aliquot_label = 'xxx' where deleted <> 1;

UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('FFPE', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'tissue'
AND va.aliquot_type = 'block';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('FT', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'tissue'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('PLA', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'plasma'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('DNA', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'dna'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('ASC', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'ascite'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('BC', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'blood cell'
AND va.aliquot_type = 'tube';
UPDATE aliquot_masters am, view_aliquots va, banks
SET am.aliquot_label = CONCAT('SER', ' ', va.participant_identifier)
WHERE am.id = va.aliquot_master_id AND banks.id = va.qc_tf_bank_id
AND va.sample_type = 'serum'
AND va.aliquot_type = 'tube';

UPDATE versions SET permissions_regenerated = 0;

SET @pwd = (select password from users WHERE username = 'NicoEn');
UPDATE users SET flag_active = 0, username = CONCAT('TMP',id), password = @pwd WHERE group_id = 3;

UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='acquisition_label');

UPDATE structure_fields SET  `flag_confidential`='0' WHERE field IN ('qc_tf_bank_identifier','qc_tf_bank_id', 'aliquot_label');

INSERT INTO i18n (id,en) VALUES ('your search will be limited to your bank', 'Your search will be limited to your bank'),('unlinked collection','Unlinked Collection');

UPDATE versions SET build_number = '5037' , permissions_regenerated = 0 WHERE version_number = '2.5.3';



