UPDATE `structure_validations`
SET `flag_empty` = '0'
WHERE `rule` LIKE 'notEmpty'
AND `flag_empty` LIKE '1';

UPDATE `i18n` SET fr='Décembre' WHERE id='December';
update `i18n` set fr='Déc' WHERE id='dec';
update `i18n` set fr='Février' WHERE id='February';
update `i18n` set fr='Fév' WHERE id='feb';