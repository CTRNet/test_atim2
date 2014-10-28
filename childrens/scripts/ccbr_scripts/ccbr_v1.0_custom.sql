-- CCBR Customization Script
-- Version: v1.00
-- ATiM Version: v2.5.1
-- Notes: Run against an upgraded v2.5.1 CCBR installation.

UPDATE 
	`structure_validations`
SET 
	`rule` = '/^[0-9]+$/'
WHERE 
	`structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `field` = 'participant_identifier' AND `tablename` = 'participants')
AND 
	`rule` = '/^CCBR[0-9]+$/';