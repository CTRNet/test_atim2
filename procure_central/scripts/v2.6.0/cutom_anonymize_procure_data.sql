UPDATE participants SET first_name = 'confid.', last_name = 'confid.';
UPDATE participants SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01');
UPDATE participants SET date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');

UPDATE misc_identifiers SET identifier_value = CONCAT('confid.',id)
WHERE misc_identifier_control_id NOT IN (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name IN ('participant study number', 'prostate bank no lab'));

DELETE FROM participant_contacts;

UPDATE procure_ed_lab_pathologies SET path_number = 'confid.';
UPDATE sd_spe_tissues SET procure_report_number = 'confid.';

-- ------------------------------------------------------------------------------------------------------

UPDATE participants_revs SET first_name = 'confid.', last_name = 'confid.';
UPDATE participants_revs SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01');
UPDATE participants_revs SET date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');

UPDATE misc_identifiers_revs SET identifier_value = CONCAT('confid.',id) 
WHERE misc_identifier_control_id NOT IN (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name IN ('participant study number', 'prostate bank no lab'));

DELETE FROM participant_contacts_revs;

UPDATE procure_ed_lab_pathologies_revs SET path_number = 'confid.';
UPDATE sd_spe_tissues_revs SET procure_report_number = 'confid.';
