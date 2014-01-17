-- ----------------------------------------------------------------------------------------------------------
-- SPENT TIME FIELDS REVIEW
-- ----------------------------------------------------------------------------------------------------------

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

-- ----------------------------------------------------------------------------------------------------------
-- drop table txe_radiations
-- ----------------------------------------------------------------------------------------------------------

DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

----------------------------------------------------------------------------------------------------------
-- PARTICIPANT IDENTIFIER REPORT
----------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

----------------------------------------------------------------------------------------------------------
-- datamart_browsing_controls & datamart_structure_functions
----------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'));
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','DiagnosisMaster','TreatmentMaster','FamilyHistory','EventMaster','ParticipantContact','ReproductiveHistory','TreatmentExtendMaster'));

----------------------------------------------------------------------------------------------------------
-- structure_permissible_values_custom_controls
----------------------------------------------------------------------------------------------------------
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






















TODO: SET structure_permissible_values_custom_controls flag_active = 0 if required
TODO: Removed all fields of specimen review detail forms already included in specimen review detail form. Please review all your specimen review forms. (qcroc_spr_tissues)
TODO: Created aliquot_review_masters form and removed all fields of aliquot review detail forms already included in it. Please review all your aliquot review forms. (qcroc_ar_tissue_slides)
TODO: Compare all froms (2.5.3 <=> 2.6.0)
TODO: Test each custom code
TODO: Add new qcroc requests

