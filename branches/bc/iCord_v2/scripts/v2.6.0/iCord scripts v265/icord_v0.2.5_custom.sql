REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.5', '');


REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('CSF Analysis', 'CSF Analysis', ''),
('admission - location of injury', 'Admission - Location of Injury', ''),
('postmortum interval', 'Postmortum Interval (Hours)', '');

-- 580

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks')
AND 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_biobanks' AND `field` = 'neuro_diagnosis' AND `type` = 'textarea');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_campers')
AND 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_campers' AND `field` = 'neuro_diagnosis' AND `type` = 'textarea');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_csfs')
AND 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_csfs' AND `field` = 'neuro_diagnosis' AND `type` = 'textarea');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_drainages')
AND 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_drainages' AND `field` = 'neuro_diagnosis' AND `type` = 'textarea');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_pressures')
AND 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_pressures' AND `field` = 'neuro_diagnosis' AND `type` = 'textarea');

-- 581

UPDATE structure_formats
SET `display_order` = 18
WHERE 
`structure_id` IN (SELECT `id` FROM structures WHERE `alias` IN ('cd_pressures', 'cd_drainages', 'cd_csfs', 'cd_campers', 'cd_biobanks'))
AND 
`structure_field_id` IN (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `field` = 'clinical_diagnosis' AND `type` = 'select');

-- 582

ALTER TABLE cd_biobanks CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_campers CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_csfs CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_drainages CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_pressures CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;

ALTER TABLE cd_biobanks_revs CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_campers_revs CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_csfs_revs CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_drainages_revs CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;
ALTER TABLE cd_pressures_revs CHANGE `admission_anatomical_lvl` `admission_location_of_injury` TEXT;

UPDATE structure_fields 
SET `field` = 'admission_location_of_injury', `language_label` = 'admission - location of injury'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `field` = 'admission_anatomical_lvl';




-- 583 

ALTER TABLE cd_biobanks 
    ADD COLUMN `death_datetime` DATETIME DEFAULT NULL AFTER `death_cause`;

ALTER TABLE cd_biobanks_revs 
    ADD COLUMN `death_datetime` DATETIME DEFAULT NULL AFTER `death_cause`;

INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES 
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'death_datetime', 'Death Datetime', '', 'datetime', '', '', NULL, '', 'open', 'open', 'open', 0);

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='death_datetime' AND `type`='datetime'), 
2, 34, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

-- 584 CSF Consent rename to csf analysis

UPDATE consent_controls
SET `controls_type` = 'CSF Analysis', `databrowser_label` = 'CSF Analysis'
WHERE `controls_type` = 'CSF Consent' AND `detail_tablename` = 'cd_csfs';





-- 501 Rename Body Weight to Body Weight at Surgery
-- 496
-- 497



ALTER TABLE participants CHANGE `icord_pig_body_weight` `icord_pig_body_weight_surgery` DECIMAL(5,2);
ALTER TABLE participants CHANGE `icord_pig_injury_height` `icord_pig_injury_height` DECIMAL(5,2);
ALTER TABLE participants_revs CHANGE `icord_pig_body_weight` `icord_pig_body_weight_surgery` DECIMAL(5,2);
ALTER TABLE participants_revs CHANGE `icord_pig_injury_height` `icord_pig_injury_height` DECIMAL(5,2);

UPDATE structure_fields 
SET `field` = 'icord_pig_body_weight_surgery', `language_label` = 'body weight at surgery (kg)'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `field` = 'icord_pig_body_weight';

UPDATE structure_fields 
SET `field` = 'icord_pig_injury_height', `language_label` = 'injury height (cm)', `type` = 'float_positive'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `field` = 'icord_pig_injury_height';

UPDATE structure_fields 
SET `language_label` = 'injury force (kdynes)'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `field` = 'icord_pig_injury_force';

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('body weight at surgery (kg)', 'Body Weight at Surgery (kg)', ''),
('injury force (kdynes)', 'Injury Force (kdynes)', ''),
('injury height (cm)', 'Injury Height (cm)', '');


-- Hide Date of Death Field in Participant form


UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_batchedit` = 0, `flag_detail`=0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'date_of_death');

-- 585
-- Need hooks for this
-- Change Postmortum Interval to Decimal

ALTER TABLE cd_biobanks MODIFY `postmortum_interval` DECIMAL(11,2);
ALTER TABLE cd_biobanks_revs MODIFY `postmortum_interval` DECIMAL(11,2);

UPDATE structure_formats
SET `flag_add_readonly` = 1, `flag_edit_readonly` = 1, `flag_summary` = 0
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks')
AND
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_biobanks' AND `field` = 'postmortum_interval');

UPDATE structure_fields
SET `type` = 'float_positive'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_biobanks' AND `field` = 'postmortum_interval';


