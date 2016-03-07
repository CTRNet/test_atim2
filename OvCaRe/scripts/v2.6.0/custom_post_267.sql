


-- -------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6xxx' WHERE version_number = '2.6.7';















Is it possible to add these changes asap instead of waiting for the 3rd migration?  The ADVISE study is starting this week and we are already receiving multiple specimens that need to be entered into the database.

 



      3) Under Patient Profile:  Add a dropdown menu titled “Subject Type” and have two choices i) Cancer/Tumour  ii) Normal Control

 
 

-- -------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------


### TODO ###########################################################################################################

1- En attente des nouveaux champs pour le path report.....

2- Revoir comment on lie une étude aux aliquots....
Si on fait un changement.... sur les aliquot.study, étudier l'impact sur les rapports 'ovcare cases received'

-- -------------------------------------------------------------------------------------------------------------------------------------
-- AliquotMaster.study_summary_id update
-- -------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'migration');
ALTER TABLE participants ADD COLUMN tmp_link_aliquot_to_study_summary_id int(11) DEFAULT '0';

-- 'Endometriosis'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'Endometriosis'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'Endometriosis' and other study ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Endometriosis');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
	)
);

-- 'Intratumoural Heterogenity'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'Intratumoural Heterogenity'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'Intratumoural Heterogenity' and other study ('Endometriosis','ITH-Ovary','ITH-Endometrium') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Intratumoural Heterogenity');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
	)
);

-- 'ITH-Ovary'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'ITH-Ovary'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'ITH-Ovary' and other study ('Endometriosis','ITH-Endometrium') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'ITH-Ovary');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
	)
);

-- 'ITH-Endometrium'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'ITH-Endometrium'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'ITH-Endometrium' and other study ('Endometriosis','ITH-Ovary') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'ITH-Endometrium');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
	)
);

-- End of process

UPDATE participants Participant,
collections Collection, 
sample_masters SampleMaster, 
aliquot_masters AliquotMaster
SET AliquotMaster.study_summary_id = Participant.tmp_link_aliquot_to_study_summary_id, 
AliquotMaster.modified = @modified, 
AliquotMaster.modified_by = @modified_by
WHERE Participant.tmp_link_aliquot_to_study_summary_id != '0'
AND Participant.id = Collection.participant_id
AND SampleMaster.collection_id = Collection.id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotMaster.deleted <> 1 
AND AliquotMaster.study_summary_id IS NULL;

ALTER TABLE participants DROP COLUMN tmp_link_aliquot_to_study_summary_id;

INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy,
storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, ovcare_clinical_aliquot, 
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy,
storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, ovcare_clinical_aliquot, 
modified_by, modified FROM aliquot_masters WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, 
cell_viability, hemolysis_signs, ovcare_storage_method, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, 
cell_viability, hemolysis_signs, ovcare_storage_method, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_blocks_revs (aliquot_master_id, block_type, patho_dpt_block_code, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, block_type, patho_dpt_block_code, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tissue_slides_revs (aliquot_master_id, immunochemistry, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, immunochemistry, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_tissue_slides ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tissue_cores_revs (aliquot_master_id, version_created) 
(SELECT aliquot_master_id, modified FROM aliquot_masters INNER JOIN ad_tissue_cores ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_whatman_papers_revs (aliquot_master_id, used_blood_volume, used_blood_volume_unit, version_created) 
(SELECT aliquot_master_id, used_blood_volume, used_blood_volume_unit, modified FROM aliquot_masters INNER JOIN ad_whatman_papers ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_cell_slides_revs (aliquot_master_id, immunochemistry, version_created) 
(SELECT aliquot_master_id, immunochemistry, modified FROM aliquot_masters INNER JOIN ad_cell_slides ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);
