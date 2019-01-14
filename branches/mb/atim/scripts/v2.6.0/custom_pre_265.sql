ALTER TABLE `structure_validations`
  DROP `old_id`,
  DROP `structure_field_old_id`;
  
UPDATE consent_masters SET date_of_referral = null WHERE CAST(date_of_referral AS CHAR(10)) = '0000-00-00';
UPDATE consent_masters_revs SET date_of_referral = null WHERE CAST(date_of_referral AS CHAR(10)) = '0000-00-00';
UPDATE consent_masters SET modified = null WHERE CAST(modified AS CHAR(19)) = '0000-00-00 00:00:00';
UPDATE consent_masters SET created = null WHERE CAST(created AS CHAR(19)) = '0000-00-00 00:00:00';

UPDATE treatment_extend_masters SET modified = null WHERE CAST(modified AS CHAR(19)) = '0000-00-00 00:00:00';
UPDATE treatment_extend_masters SET created = null WHERE CAST(created AS CHAR(19)) = '0000-00-00 00:00:00';

ALTER TABLE aliquot_controls
  MODIFY comment varchar(255) DEFAULT NULL;
  
UPDATE templates SET owning_entity_id = 1 WHERE owning_entity_id = 0;
UPDATE templates SET visible_entity_id = 1 WHERE visible_entity_id = 0;
UPDATE templates SET created_by = 1 WHERE created_by = 0;
