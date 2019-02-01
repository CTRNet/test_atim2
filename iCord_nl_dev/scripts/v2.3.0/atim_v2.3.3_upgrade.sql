-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.3', NOW(), '3370');

ALTER TABLE diagnosis_masters
 CHANGE age_at_dx_accuracy age_at_dx_precision VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 CHANGE age_at_dx_accuracy age_at_dx_precision VARCHAR(50) NOT NULL DEFAULT '';
UPDATE structure_fields SET field='age_at_dx_precision' WHERE field='age_at_dx_accuracy';

ALTER TABLE family_histories
 CHANGE age_at_dx_accuracy age_at_dx_precision VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE family_histories_revs
 CHANGE age_at_dx_accuracy age_at_dx_precision VARCHAR(50) NOT NULL DEFAULT '';

ALTER TABLE reproductive_histories
 CHANGE menopause_age_accuracy age_at_menopause_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE age_at_menarche_accuracy age_at_menarche_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE hysterectomy_age_accuracy hysterectomy_age_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE first_parturition_accuracy age_at_first_parturition_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE last_parturition_accuracy age_at_last_parturition_precision VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE reproductive_histories_revs
 CHANGE menopause_age_accuracy age_at_menopause_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE age_at_menarche_accuracy age_at_menarche_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE hysterectomy_age_accuracy hysterectomy_age_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE first_parturition_accuracy age_at_first_parturition_precision VARCHAR(50) NOT NULL DEFAULT '',
 CHANGE last_parturition_accuracy age_at_last_parturition_precision VARCHAR(50) NOT NULL DEFAULT '';

UPDATE structure_fields SET field='age_at_menopause_precision' WHERE field='menopause_age_accuracy';
UPDATE structure_fields SET field='age_at_menarche_precision' WHERE field='age_at_menarche_accuracy';
UPDATE structure_fields SET field='hysterectomy_age_precision' WHERE field='hysterectomy_age_accuracy';
UPDATE structure_fields SET field='age_at_first_parturition_precision' WHERE field='first_parturition_accuracy';
UPDATE structure_fields SET field='age_at_last_parturition_precision' WHERE field='last_parturition_accuracy';