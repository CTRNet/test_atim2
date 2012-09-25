SELECT participant_id, identifier_value, misc_identifier_name FROM misc_identifiers AS mi INNER JOIN misc_identifier_controls AS mic ON mi.misc_identifier_control_id=mic.id 
WHERE deleted=0 GROUP BY identifier_value, misc_identifier_control_id HAVING COUNT(*) > 1;

UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
