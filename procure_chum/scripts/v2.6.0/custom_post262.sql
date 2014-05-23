REPLACE INTO i18n (id,en,fr) VALUES ('other diseases','Other Diseases','Autres maladies');

UPDATE event_controls SET use_addgrid = '1' WHERE event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');
UPDATE event_controls SET use_detail_form_for_index = '1' WHERE event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');

UPDATE event_controls SET disease_site = '' WHERE flag_active = 1;
UPDATE treatment_controls SET disease_site = '' WHERE flag_active = 1;

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%';

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 IN (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 IN (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 IN (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster');

UPDATE datamart_structure_functions fct SET fct.flag_active = 0 WHERE fct.label IN ('print barcodes', 'list all related diagnosis');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'RAMQ', 'input',  NULL , '0', 'size=20', '', '', 'RAMQ', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='RAMQ' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ' AND `language_tag`=''), '0', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='BR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='PR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs DROP FOREIGN KEY procure_ed_clinical_followup_worksheet_aps_ibfk_1;
ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs DROP FOREIGN KEY procure_ed_clinical_followup_worksheet_aps_ibfk_2;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs DROP FOREIGN KEY procure_ed_clinical_followup_worksheet_clinical_events_ibfk_1;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs DROP FOREIGN KEY procure_ed_clinical_followup_worksheet_clinical_events_ibfk_2;

ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs DROP KEY procure_ed_clinical_followup_worksheet_aps_ibfk_1;
ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs DROP KEY procure_ed_clinical_followup_worksheet_aps_ibfk_2;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs DROP KEY procure_ed_clinical_followup_worksheet_clinical_events_ibfk_1;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs DROP KEY procure_ed_clinical_followup_worksheet_clinical_events_ibfk_2;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'patient_identity_verified', 'checkbox',  NULL , '0', '', '', '', 'confirm that the identity of the patient has been verified', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='patient_identity_verified' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(188, 192);

UPDATE versions SET branch_build_number = '???' WHERE version_number = '2.6.2';
