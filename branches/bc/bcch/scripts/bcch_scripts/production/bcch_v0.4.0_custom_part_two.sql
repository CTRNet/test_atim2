-- BCCH Customization Script
-- Version 0.4
-- ATiM Version: 2.6.5

--  =========================================================================
--	Eventum ID: #XXXX - Disable the shelf in storage
--  BB-103
--	=========================================================================


-- Only run the following after completing the 2.6.5 upgrade

UPDATE misc_identifier_controls
SET `flag_link_to_study`= 1 
WHERE `misc_identifier_name` = 'GREID ID'
OR `misc_identifier_name` = 'LBRWN ID'
OR `misc_identifier_name` = 'NEURO ID'
OR `misc_identifier_name` = 'EPGEN ID'
OR `misc_identifier_name` = 'SLED1 ID'
OR `misc_identifier_name` = 'UST1D ID'
OR `misc_identifier_name` = 'CAUSES ID';

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='LBRWN' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'LBRWN ID' AND `flag_active`=1);

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='NEURO' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'NEURO ID' AND `flag_active`=1);

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='EPGEN' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'EPGEN ID' AND `flag_active`=1);

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='SLED' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'SLED1 ID' AND `flag_active`=1);

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='UST1D' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'UST1D ID' AND `flag_active`=1);

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='CAUSES' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'CAUSES ID' AND `flag_active`=1);


UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='LBRWN' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'LBRWN ID' AND `flag_active`=1);

UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='NEURO' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'NEURO ID' AND `flag_active`=1);

UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='EPGEN' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'EPGEN ID' AND `flag_active`=1);

UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='SLED' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'SLED1 ID' AND `flag_active`=1);

UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='UST1D' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'UST1D ID' AND `flag_active`=1);

UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title`='CAUSES' AND `deleted`=0)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'CAUSES ID' AND `flag_active`=1);

--  =========================================================================
--	BB-113: Temporary Solution
--	=========================================================================

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid`= 0, `flag_editgrid` = 0, `flag_summary` = 0, `flag_index` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'familyhistories')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'FamilyHistory' AND `tablename` = 'family_histories' AND `field` = 'ccbr_disease_site');