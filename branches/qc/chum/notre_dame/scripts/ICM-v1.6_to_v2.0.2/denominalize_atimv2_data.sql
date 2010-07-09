UPDATE participants 
SET first_name = concat('fn',id),
middle_name = concat('mn',id),
last_name = concat('ln',id),
date_of_birth = NULL,
date_of_death = NULL;

TRUNCATE participant_contacts;

UPDATE misc_identifiers
SET identifier_value = concat(identifier_abrv, '---', id);




