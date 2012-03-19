INSERT INTO `participants` (`participant_identifier`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `race`, `sex`, `marital_status`, `language_preferred`, `last_chart_checked_date`, `notes`, `vital_status`, `date_of_death`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `date_of_birth_accuracy`, `date_of_death_accuracy`, `last_chart_checked_date_accuracy`, `modified`, `created`, `created_by`, `modified_by`, `last_modification`, `last_modification_ds_id`) VALUES 
('db_filter_normal', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_day1', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_day2', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_day3', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_month1', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_month2', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_month3', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_month4', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_month5', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year1', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year2', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year3', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year4', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year5', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year6', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4),
('db_filter_year7', '', '', '', '', NULL, '', '', '', '', NULL, '', '', NULL, NULL, NULL, '', '', '', '', '2012-02-23 10:05:48', '2012-02-23 10:05:48', 1, 1, '2012-02-23 10:05:48', 4);

INSERT INTO collections (collection_datetime, collection_datetime_accuracy, participant_id, `created`, `created_by`, `modified`, `modified_by`) VALUES
('2011-12-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_normal'), NOW(), 1, NOW(), 1),
('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_normal'), NOW(), 1, NOW(), 1),
('2012-01-02', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_normal'), NOW(), 1, NOW(), 1),

('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_day1'), NOW(), 1, NOW(), 1),
('2012-01-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_day1'), NOW(), 1, NOW(), 1),

('2012-01-31', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_day2'), NOW(), 1, NOW(), 1),
('2012-01-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_day2'), NOW(), 1, NOW(), 1),

('2011-12-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_day3'), NOW(), 1, NOW(), 1),
('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_day3'), NOW(), 1, NOW(), 1),
('2012-02-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_day3'), NOW(), 1, NOW(), 1),

('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_month1'), NOW(), 1, NOW(), 1),
('2012-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month1'), NOW(), 1, NOW(), 1),

('2011-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month2'), NOW(), 1, NOW(), 1),
('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_month2'), NOW(), 1, NOW(), 1),
('2013-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month2'), NOW(), 1, NOW(), 1),

('2012-01-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_month3'), NOW(), 1, NOW(), 1),
('2012-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month3'), NOW(), 1, NOW(), 1),

('2011-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month4'), NOW(), 1, NOW(), 1),
('2012-01-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_month4'), NOW(), 1, NOW(), 1),
('2013-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month4'), NOW(), 1, NOW(), 1),

('2011-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month5'), NOW(), 1, NOW(), 1),
('2012-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month5'), NOW(), 1, NOW(), 1),
('2013-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_month5'), NOW(), 1, NOW(), 1),

('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_year1'), NOW(), 1, NOW(), 1),
('2012-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year1'), NOW(), 1, NOW(), 1),

('2012-01-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_year2'), NOW(), 1, NOW(), 1),
('2012-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year2'), NOW(), 1, NOW(), 1),

('2012-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_year3'), NOW(), 1, NOW(), 1),
('2012-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year3'), NOW(), 1, NOW(), 1),

('2011-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year4'), NOW(), 1, NOW(), 1),
('2012-01-01', 'c', (SELECT id FROM participants WHERE participant_identifier='db_filter_year4'), NOW(), 1, NOW(), 1),
('2013-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year4'), NOW(), 1, NOW(), 1),

('2011-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year5'), NOW(), 1, NOW(), 1),
('2012-01-01', 'd', (SELECT id FROM participants WHERE participant_identifier='db_filter_year5'), NOW(), 1, NOW(), 1),
('2013-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year5'), NOW(), 1, NOW(), 1),

('2011-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year6'), NOW(), 1, NOW(), 1),
('2012-01-01', 'm', (SELECT id FROM participants WHERE participant_identifier='db_filter_year6'), NOW(), 1, NOW(), 1),
('2013-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year6'), NOW(), 1, NOW(), 1),

('2011-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year7'), NOW(), 1, NOW(), 1),
('2012-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year7'), NOW(), 1, NOW(), 1),
('2013-01-01', 'y', (SELECT id FROM participants WHERE participant_identifier='db_filter_year7'), NOW(), 1, NOW(), 1);





