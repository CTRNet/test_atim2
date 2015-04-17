 

 
update atim_ccbr.structure_validations
SET rule = '/^[0-9]+$/'
WHERE structure_field_id = 521 and rule = '/^CCBR[0-9]+$/'

DELETE FROM atim_ccbr.structure_validations where structure_field_id = 521;

