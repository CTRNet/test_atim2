UPDATE participants SET first_name = null, last_name = null;
UPDATE participants SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01'), date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');
DELETE FROM misc_identifiers WHERE misc_identifier_control_id != (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'participant study number');
UPDATE procure_ed_lab_pathologies SET path_number = null, pathologist_name = null;
UPDATE sd_spe_tissues SET procure_report_number = null;
CREATE TABLE atim_procure_dump_information (created datetime NOT NULL);
INSERT INTO atim_procure_dump_information (created) (SELECT NOW() FROM aliquot_controls LIMIT 0 ,1);