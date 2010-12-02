UPDATE participants 
SET first_name = concat('fn',id),
middle_name = concat('mn',id),
last_name = concat('ln',id),
date_of_birth = NULL,
date_of_death = NULL,
sardo_medical_record_number = 'cccc';

UPDATE participant_contacts
SET contact_name  = concat('cn-', id),
notes  = '',
street  = '',
locality  = '',
region  = '',
country  = '',
mail_code  = '',
phone  = '',
phone_secondary  = '';

UPDATE misc_identifiers
SET identifier_value = concat(identifier_abrv, '---', id)
WHERE identifier_name NOT LIKE '%bank no lab';



