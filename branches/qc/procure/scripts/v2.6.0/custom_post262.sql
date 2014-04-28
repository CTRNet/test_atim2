REPLACE INTO i18n (id,en,fr) VALUES ('other diseases','Other Diseases','Autres maladies');

UPDATE event_controls SET use_addgrid = '1' WHERE event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');
UPDATE event_controls SET use_detail_form_for_index = '1' WHERE event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');

UPDATE event_controls SET disease_site = '' WHERE flag_active = 1;
UPDATE treatment_controls SET disease_site = '' WHERE flag_active = 1;

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%';
















PARTICIPANT IDENTIFIER REPORT
----------------------------------------------------------------------------------------------------------
Queries to desactivate 'Participant Identifiers' demo report
----------------------------------------------------------------------------------------------------------
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');








TODO
----------------------------------------------------------------------------------------------------------
Added new relationsips into databrowser
Please flag inactive relationsips if required (see queries below). Don't forget Collection to Annotation, Treatment,Consent, etc if not requried.
SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_t
o_2 = 1 OR ctrl.flag_active_2_to_1 = 1);
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');
Please flag inactive datamart structure functions if required (see queries below).
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_structu
res WHERE model IN ('Model1', 'Model2', 'Model...'));
Please change datamart_structures_relationships_en(and fr).png in appwebrootimgdataBrowser
----------------------------------------------------------------------------------------------------------
