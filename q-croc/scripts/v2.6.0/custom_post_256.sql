-- -- --------------------------------------------------------------------------------------------------------
-- SPENT TIME FIELDS REVIEW
-- -- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='collection to storage spent time (min)'
WHERE type = 'integer_positive'
AND structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='', `language_label`=''
WHERE type = ''
AND structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats 
SET `flag_search`='0', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_spec%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` LIKE '%_spent_time_msg')
AND  type = '';
UPDATE structure_formats 
SET `flag_search`='1', `flag_index`='0', `flag_detail`='0'  
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_spec%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` LIKE '%_spent_time_msg')
AND type = 'integer_positive';
UPDATE structure_formats 
SET `flag_search`='0', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_der%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` LIKE '%_spent_time_msg')
AND  type = '';
UPDATE structure_formats 
SET `flag_search`='1', `flag_index`='0', `flag_detail`='0'  
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_der%') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` LIKE '%_spent_time_msg')
AND type = 'integer_positive';
UPDATE structure_formats 
SET `flag_search`='0', `flag_index`='1', `flag_detail`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('derivatives','specimens')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field` LIKE '%_spent_time_msg')
AND  type = '';
UPDATE structure_formats 
SET `flag_search`='1', `flag_index`='0', `flag_detail`='0'  
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('derivatives','specimens')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field` LIKE '%_spent_time_msg')
AND type = 'integer_positive';

-- -- --------------------------------------------------------------------------------------------------------
-- drop table txe_radiations
-- -- --------------------------------------------------------------------------------------------------------

DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

-- --------------------------------------------------------------------------------------------------------
-- PARTICIPANT IDENTIFIER REPORT
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

-- --------------------------------------------------------------------------------------------------------
-- datamart_browsing_controls & datamart_structure_functions
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'));
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'));

-- --------------------------------------------------------------------------------------------------------
-- structure_permissible_values_custom_controls
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls set category = 'sop' WHERE name = 'SOP : Versions';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Biopsy : Liver segments';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Biopsy : Types';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Biopsy : Radiologists';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Biopsy : Coordinators';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Collection: Protocol';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Aliquot Transfer: Conditions';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Aliquot Transfer: Dispatch methods';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Aliquot Transfer: Types';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Staff : Sites';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Staff : HDQ';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Staff : JGH';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'DNA & RNA: Elution buffer';
UPDATE structure_permissible_values_custom_controls set category = 'inventory - quality control' WHERE name = 'Quality Control: Type';
UPDATE structure_permissible_values_custom_controls set category = 'inventory - quality control' WHERE name = 'Quality Control: Unit';
UPDATE structure_permissible_values_custom_controls set category = 'inventory' WHERE name = 'Biopsy : Tissue storage solution';

-- --------------------------------------------------------------------------------------------------------
-- drug...
-- --------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Drug/Drugs%';

-- --------------------------------------------------------------------------------------------------------
-- collection_property -> hidde
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `language_heading`='', `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other data' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- copy collection options
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='2', `display_order`='1000' WHERE structure_id=(SELECT id FROM structures WHERE alias='col_copy_binding_opt') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_binding_opt' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt') AND `flag_confidential`='0');
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='col_copy_binding_opt' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="6" AND language_alias="all (participant, consent, diagnosis and treatment/annotation)");

-- --------------------------------------------------------------------------------------------------------
-- disable saliva and csf
-- --------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(188, 190, 189, 192);

-- --------------------------------------------------------------------------------------------------------
-- Collection to Reception Spent Time, ...
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET flag_add=0, flag_add_readonly=0, flag_edit=0, flag_edit_readonly=0, flag_search=0, flag_search_readonly=0, flag_addgrid=0, flag_addgrid_readonly=0, 
flag_editgrid=0, flag_editgrid_readonly=0, flag_summary=0, flag_batchedit=0, flag_batchedit_readonly=0, flag_index=0, flag_detail=0, flag_float=0 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('coll_to_rec_spent_time_msg', 'coll_to_stor_spent_time_msg', 'creat_to_stor_spent_time_msg', 'rec_to_stor_spent_time_msg'));

-- --------------------------------------------------------------------------------------------------------
-- SpecimenReview
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- SampleView & AliquotView
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='1', `display_order`='1202' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- structure_permissible_values_custom_controls
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name IN ('consent form versions','laboratory staff','laboratory sites','spcimen supplier departments');

-- --------------------------------------------------------------------------------------------------------
-- QC form review
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='24', `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- Report
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'list all related diagnosis';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = '/ClinicalAnnotation/Participants/batchEdit/';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'list all related diagnosis';

-- --------------------------------------------------------------------------------------------------------
-- I18n
-- --------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en) VALUES ('qcroc tissue slide review','Tissue Slide Review');
REPLACE INTO i18n (id,en,fr) VALUES ('collection datetime','Visit Date','Date de visite');

-- --------------------------------------------------------------------------------------------------------
-- Sample View
-- --------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'qcroc_protocol', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') , '0', '', '', '', 'qcroc protocol', ''), 
('InventoryManagement', 'ViewSample', '', 'collection_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') , '0', '', '', '', 'collection site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qcroc_protocol' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qcroc protocol' AND `language_tag`=''), '0', '-1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='collection_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection site' AND `language_tag`=''), '0', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'collection_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') , '0', '', '', '', 'collection site', ''), 
('InventoryManagement', 'ViewAliquot', '', 'qcroc_protocol', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') , '0', '', '', '', 'qcroc protocol', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='collection_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection site' AND `language_tag`=''), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qcroc_protocol' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qcroc protocol' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-4' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-5' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qcroc_protocol' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- SOP
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='activated_date');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopControl' AND `tablename`='sop_controls' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sop_types') AND `flag_confidential`='0');
UPDATE structure_fields SET `language_label`='sop_version',  `language_tag`='' WHERE model='SopMaster' AND tablename='sop_masters' AND field='version' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_sop_verisons');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- Volume
-- --------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_internal_uses MODIFY used_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE aliquot_internal_uses_revs MODIFY used_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE aliquot_masters MODIFY initial_volume decimal(10,2) DEFAULT NULL, MODIFY current_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY initial_volume decimal(10,2) DEFAULT NULL, MODIFY current_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE quality_ctrls MODIFY used_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE quality_ctrls_revs MODIFY used_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE realiquotings MODIFY parent_used_volume decimal(10,2) DEFAULT NULL;  
ALTER TABLE realiquotings_revs MODIFY parent_used_volume decimal(10,2) DEFAULT NULL; 
ALTER TABLE sd_spe_bloods MODIFY   collected_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE sd_spe_bloods_revs MODIFY   collected_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE source_aliquots MODIFY used_volume decimal(10,2) DEFAULT NULL;
ALTER TABLE source_aliquots_revs MODIFY used_volume decimal(10,2) DEFAULT NULL;

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE field='qcroc_consent_date' ), 'notEmpty', '', '');

ALTER TABLE sd_spe_tissues
	CHANGE qcroc_placed_in_stor_sol_within_5mn qcroc_placed_in_storrage_solution_and_frozen_within_5mn char(1) DEFAULT '',
	CHANGE qcroc_placed_in_stor_sol_within_5mn_reason qcroc_placed_in_storrage_solution_and_frozen_within_5mn_reason varchar(250) DEFAULT '';	
ALTER TABLE sd_spe_tissues_revs
	CHANGE qcroc_placed_in_stor_sol_within_5mn qcroc_placed_in_storrage_solution_and_frozen_within_5mn char(1) DEFAULT '',
	CHANGE qcroc_placed_in_stor_sol_within_5mn_reason qcroc_placed_in_storrage_solution_and_frozen_within_5mn_reason varchar(250) DEFAULT '';			
UPDATE structure_fields 
SET `language_label`='qcroc placed in storage solution and frozen within 5mn', field='qcroc_placed_in_storrage_solution_and_frozen_within_5mn'
WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='qcroc_placed_in_stor_sol_within_5mn';
UPDATE structure_fields 
SET `language_label`='qcroc placed in storage solution and frozen within 5mn reason', field='qcroc_placed_in_storrage_solution_and_frozen_within_5mn_reason'
WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='qcroc_placed_in_stor_sol_within_5mn_reason';
INSERT INTO i18n (id,en)
VALUES 
('qcroc placed in storage solution and frozen within 5mn','Was tissue placed in solution and frozen within 5min'),
('qcroc placed in storage solution and frozen within 5mn reason','If >5min, provide a reason');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qcroc_tissue_storage_method", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Tissue storage method\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Biopsy : Tissue storage method', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy : Tissue storage method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('snap frozen', 'Snap Frozen', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_tissue_storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_storage_method') , '0', '', '', '', 'storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_tissue_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '440', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_spe_tissues ADD COLUMN qcroc_tissue_storage_method VARCHAR(100) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN qcroc_tissue_storage_method VARCHAR(100) DEFAULT NULL;
UPDATE structure_fields SET language_label = 'storage method' WHERE field = 'qcroc_tissue_storage_method';
INSERT INTO i18n (id,en) VALUES ('storage method','Storage Method');

REPLACE INTO i18n (id,en)
VALUES
('qcroc placed in stor sol within 5mn','Was tissue placed in solution within 5min');

UPDATE storage_controls SET flag_active = '1' WHERE storage_type = 'shelf';
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'box100', 'position', 'integer', 100, NULL, NULL, NULL, 10, 10, 0, 0, 1, 0, 0, 1, '', 'std_boxs', 'custom#storage types#box100', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'storage types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('box100', 'Box100 1-100', 'Boîte100 1-100', '1', @control_id, NOW(), NOW(), 1, 1);

-- MOVE PROTOCOL AND PATIENT NO TO MISC IDENTIFIER

INSERT INTO misc_identifier_controls (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`) 
VALUES 
(NULL, 'Q-CROC-01', '1', '0', '', NULL, '1', '0', '1', '0', '^[0-9]{3}$', ''),
(NULL, 'Q-CROC-02', '1', '0', '', NULL, '1', '0', '1', '0', '^[0-9]{3}$', ''),
(NULL, 'Q-CROC-03', '1', '0', '', NULL, '1', '0', '1', '0', '^[0-9]{3}$', '');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers%';
UPDATE structure_formats SET `display_column`='3', `display_order`='98', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE collections ADD COLUMN `misc_identifier_id` int(11) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN `misc_identifier_id` int(11) DEFAULT NULL;
ALTER TABLE `collections` ADD CONSTRAINT `collections_misc_identifiers_fk` FOREIGN KEY (`misc_identifier_id`) REFERENCES `misc_identifiers` (`id`);
UPDATE structure_formats SET `display_column`='2', `display_order`='61' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qcroc_protocol_from_id','ClinicalAnnotation.MiscIdentifierControl::listProtocolFromId');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qcroc_protocol_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id') , '0', '', '', '', 'protocol', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_patient_no', 'input',  NULL , '0', 'size=10', '', '', 'patient no', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_protocol_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '0', '-1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_patient_no' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patient no' AND `language_tag`=''), '0', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='2', `display_order`='60', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`=' ' AND `field`='field1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'qcroc_protocol_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id') , '0', '', '', '', 'protocol', ''), 
('InventoryManagement', 'ViewSample', '', 'qcroc_patient_no', 'input',  NULL , '0', 'size=10', '', '', 'patient no', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qcroc_protocol_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '0', '-2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qcroc_patient_no' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patient no' AND `language_tag`=''), '0', '-1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='9999', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'qcroc_protocol_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id') , '0', '', '', '', 'protocol', ''), 
('InventoryManagement', 'ViewAliquot', '', 'qcroc_patient_no', 'input',  NULL , '0', 'size=10', '', '', 'patient no', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qcroc_protocol_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '0', '-6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qcroc_patient_no' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patient no' AND `language_tag`=''), '0', '-5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1200', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qcroc_protocol');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qcroc_protocol');
DELETE FROM structure_fields WHERE field = 'qcroc_protocol';
INSERT INTO i18n (id,en,fr) VALUES ('error_fk_frsq_number_linked_collection','Your data cannot be deleted! This Patient No is linked to a collection.','Vos données ne peuvent être supprimées! Cet identifiant est attaché à une collection.');
INSERT INTO i18n (id,en) VALUES ('the patient no has to be selected','Patient No has to be selected');
INSERT IGNORE INTO i18n (id,en) VALUES ('patient no','Patient No');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_initials' AND `language_label`='initials' AND `language_tag`='' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_initials' AND `language_label`='initials' AND `language_tag`='' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_initials' AND `language_label`='initials' AND `language_tag`='' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='59', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'MiscIdentifier', 'misc_identifiers', 'misc_identifier_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id') , '0', '', '', '', 'protocol', ''), 
('ClinicalAnnotation', 'MiscIdentifier', 'misc_identifiers', 'identifier_value', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id') , '0', 'size=10', '', '', 'patient no', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='misc_identifier_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patient no' AND `language_tag`=''), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='protocol' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/listall/%';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='misc_identifier_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol_from_id')  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patient no' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) 
VALUES 
('identifiers', 'Patient No', 'Patient No'),
('misc identifiers', 'Patient No', 'Patient No'),
('identifier name', 'Protocol', 'Protocol'),
('add identifier','Add Patient No', 'Céer Patient No');

-- LIVER SEGT & LESION : Move biopsy fields from Collection to sample

ALTER TABLE collections
   DROP COLUMN qcroc_liver_segment,
   DROP COLUMN qcroc_lesion_size_sup_2_cm,
   DROP COLUMN qcroc_lesion_size_cm;
ALTER TABLE collections_revs
   DROP COLUMN qcroc_liver_segment,
   DROP COLUMN qcroc_lesion_size_sup_2_cm,
   DROP COLUMN qcroc_lesion_size_cm;
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('qcroc_liver_segment','qcroc_lesion_size_sup_2_cm','qcroc_lesion_size_cm') AND model LIKE '%Collection%');
DELETE FROM structure_fields WHERE field IN ('qcroc_liver_segment','qcroc_lesion_size_sup_2_cm','qcroc_lesion_size_cm') AND model LIKE '%Collection%';
ALTER TABLE sd_spe_tissues
   ADD COLUMN qcroc_liver_segment varchar(50) DEFAULT NULL,
   ADD COLUMN qcroc_lesion_size_sup_2_cm char(1) DEFAULT '',
   ADD COLUMN qcroc_lesion_size_cm decimal(8,2) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs
   ADD COLUMN qcroc_liver_segment varchar(50) DEFAULT NULL,
   ADD COLUMN qcroc_lesion_size_sup_2_cm char(1) DEFAULT '',
   ADD COLUMN qcroc_lesion_size_cm decimal(8,2) DEFAULT NULL;   
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_liver_segment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments') , '0', '', '', '', '', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_lesion_size_sup_2_cm', 'yes_no',  NULL , '0', '', '', '', 'lesion size > 2cm', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_lesion_size_cm', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'lesion size specify cm');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '437', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_lesion_size_sup_2_cm' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lesion size > 2cm' AND `language_tag`=''), '1', '438', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_lesion_size_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='lesion size specify cm'), '1', '439', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='liver segment' WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='qcroc_liver_segment' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments');
UPDATE structure_formats SET `language_heading`='blood collection' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model` IN ('Collection','ViewCollection') AND `field`='qcroc_banking_nbr');

-- Move biopsy fields from Collection to sample

ALTER TABLE collections
   DROP COLUMN `qcroc_prior_to_chemo`,
   DROP COLUMN `qcroc_prior_to_chemo_specify`,
   DROP COLUMN `qcroc_is_baseline`,
   DROP COLUMN `qcroc_cycle`;
ALTER TABLE collections_revs
   DROP COLUMN `qcroc_prior_to_chemo`,
   DROP COLUMN `qcroc_prior_to_chemo_specify`,
   DROP COLUMN `qcroc_is_baseline`,
   DROP COLUMN `qcroc_cycle`;
ALTER TABLE sd_spe_bloods
   ADD COLUMN `qcroc_prior_to_chemo` char(1) DEFAULT '',
   ADD COLUMN `qcroc_prior_to_chemo_specify` varchar(50) DEFAULT NULL,
   ADD COLUMN `qcroc_is_baseline` char(1) DEFAULT '',
   ADD COLUMN `qcroc_cycle` int(6) DEFAULT NULL;
ALTER TABLE sd_spe_bloods_revs
   ADD COLUMN `qcroc_prior_to_chemo` char(1) DEFAULT '',
   ADD COLUMN `qcroc_prior_to_chemo_specify` varchar(50) DEFAULT NULL,
   ADD COLUMN `qcroc_is_baseline` char(1) DEFAULT '',
   ADD COLUMN `qcroc_cycle` int(6) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('qcroc_cycle','qcroc_is_baseline','qcroc_prior_to_chemo_specify','qcroc_prior_to_chemo') AND model LIKE '%Collection%');
DELETE FROM structure_fields WHERE field IN ('qcroc_cycle','qcroc_is_baseline','qcroc_prior_to_chemo_specify','qcroc_prior_to_chemo') AND model LIKE '%Collection%';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'qcroc_prior_to_chemo', 'yes_no',  NULL , '0', '', '', '', 'prior to chemo', ''), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_prior_to_chemo_specify', 'input',  NULL , '0', 'size=30', '', '', '', 'specify'), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_cycle', 'integer_positive',  NULL , '0', 'size=3', '', '', 'cycle', ''), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_is_baseline', 'yes_no',  NULL , '0', '', '', '', 'baseline', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_prior_to_chemo' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prior to chemo' AND `language_tag`=''), '1', '338', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_prior_to_chemo_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify'), '1', '339', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_cycle' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='cycle' AND `language_tag`=''), '1', '340', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_is_baseline' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline' AND `language_tag`=''), '1', '341', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES
('either banking # or biopsy type fields has to be entered','Either banking # or biopsy type fields has to be entered'),
('you can not enter both blood collection fields and biopsy fields for the same collection','You can not enter both blood collection fields and biopsy fields for the same collection'),
('the entered collection fields does not match the collection samples','The entered collection fields does not match the collection samples');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_banking_nbr' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='banking #' AND `language_tag`=''), '0', '45', 'blood collection', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='biopsy' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_biopsy_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types') AND `flag_confidential`='0');

-- Picgreen for RNA and RIN for DNA 

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
((SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='tool' AND `type`='select'), 'notEmpty', '', '');
INSERT IGNORE INTO i18n (id,en) VALUES 
('you can only create quality control for dna and rna','You can only create quality control for dna and rna'),
('quality control score unit and sample type mismatch','quality control score unit and sample type mismatch'),
('quality control type and sample type mismatch','Quality control type and sample type mismatch');
