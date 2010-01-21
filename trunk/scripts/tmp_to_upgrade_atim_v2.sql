UPDATE `structure_validations`
SET `flag_empty` = '0'
WHERE `rule` LIKE 'notEmpty'
AND `flag_empty` LIKE '1';

UPDATE `i18n` SET fr='Décembre' WHERE id='December';
update `i18n` set fr='Déc' WHERE id='dec';
update `i18n` set fr='Février' WHERE id='February';
update `i18n` set fr='Fév' WHERE id='feb';

UPDATE `structure_fields` 
SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'custom_laboratory_staff'),
type = 'select',
setting = null
WHERE old_id = 'CAN-999-999-000-999-499';

DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'available_bank_participants_aliquots');
DELETE FROM `structures` WHERE `alias` = 'available_bank_participants_aliquots';

DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'aliquot_masters_for_search_result');
DELETE FROM `structures` WHERE `alias` = 'aliquot_masters_for_search_result';
