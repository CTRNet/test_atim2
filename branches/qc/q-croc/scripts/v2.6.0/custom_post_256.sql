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


















-- --------------------------------------------------------------------------------------------------------
-- SampleView & AliquotView
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='1', `display_order`='1202' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');











TODO: SET structure_permissible_values_custom_controls flag_active = 0 if required
TODO: Removed all fields of specimen review detail forms already included in specimen review detail form. Please review all your specimen review forms. (qcroc_spr_tissues)
TODO: Created aliquot_review_masters form and removed all fields of aliquot review detail forms already included in it. Please review all your aliquot review forms. (qcroc_ar_tissue_slides)
TODO: Compare all froms (2.5.3 <=> 2.6.0)
TODO: Test each custom code
TODO: Add new qcroc requests
TODO: Désactiver les rapports pas utilisés
TODO: Revoire le SampleView et SampleAliquot... faut il cacher/afficher qq champ de collection

