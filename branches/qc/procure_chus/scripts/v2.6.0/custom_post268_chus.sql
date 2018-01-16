-- End of script custom post 267

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('finish date (if applicable)','Finish Date (if applicable)','Date de fin (si applicable)'),
('last completed drug treatment', 'Last Completed Drug/Medication (Defined as finished)', 'Derniere prise de médicament complétée (définie comme terminé)'),
('ongoing drug treatment', 'Ongoing Drug/Medication (Defined as unfinished)', 'Médicament en cours (défini comme non-terminé)');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_next_followup_finish_date', 'date',  NULL , '0', '', '', '', 'finish date (if applicable)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_next_followup_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_next_followup_finish_date'), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_fields 
SET  sortable = '1'
WHERE plugin = 'Datamart' 
AND model='0' 
AND tablename=''
AND id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('procure_next_followup_report_result')));

-- Ask correction on TreatmentDetail.treatment_type

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Sites (PROCURE values only)');
SELECT "Please change the site of the following treatments with updated list values" AS MSG;
SELECT Participant.participant_identifier, TreatmentMaster.start_date, TreatmentDetail.treatment_type, TreatmentDetail.treatment_site
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.participant_id = Participant.id
INNER JOIN procure_txd_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_site NOT IN (SELECT value FROM structure_permissible_values_customs WHERE control_id = @control_id)
AND TreatmentDetail.treatment_site IS NOT NULL AND TreatmentDetail.treatment_site NOT LIKE '';

UPDATE procure_ed_prostate_cancer_diagnosis SET histologic_grade_gleason_total = REPLACE(histologic_grade_gleason_total, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis SET histologic_grade_primary_pattern =REPLACE(histologic_grade_primary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis SET histologic_grade_secondary_pattern =REPLACE(histologic_grade_secondary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis SET highest_gleason_score_observed =REPLACE(highest_gleason_score_observed, '.', '');

UPDATE procure_ed_prostate_cancer_diagnosis_revs SET histologic_grade_gleason_total = REPLACE(histologic_grade_gleason_total, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis_revs SET histologic_grade_primary_pattern =REPLACE(histologic_grade_primary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis_revs SET histologic_grade_secondary_pattern =REPLACE(histologic_grade_secondary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis_revs SET highest_gleason_score_observed =REPLACE(highest_gleason_score_observed, '.', '');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
UPDATE structure_permissible_values_customs SET use_as_input = 0 WHERE control_id = @control_id AND value IN ('sent to chus', 'received from chus');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id');

-- Version

UPDATE versions SET site_branch_build_number = '6663' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

UPDATE versions SET site_branch_build_number = '6668' WHERE version_number = '2.6.8';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6746' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6985' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;
