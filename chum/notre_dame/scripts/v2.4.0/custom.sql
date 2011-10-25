-- run after upgrade to 2.4.0
UPDATE participant_messages SET expiry_date=NULL WHERE expiry_date='0000-00-00';
UPDATE participant_messages SET date_requested=NULL WHERE date_requested='0000-00-00';
UPDATE participant_messages SET due_date=NULL WHERE due_date='0000-00-00 00:00:00';

UPDATE menus SET use_link='/clinicalannotation/misc_identifiers/search/' WHERE id='clin_CAN_1';

UPDATE collections SET collection_datetime=NULL WHERE collection_datetime='0000-00-00 00:00:00';

ALTER TABLE participants
 CHANGE lvd_date_accuracy last_visit_date_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
 CHANGE lvd_date_accuracy last_visit_date_accuracy CHAR(1) NOT NULL DEFAULT '';
 
REPLACE INTO i18n (id, en, fr) VALUES
("banking activity", "Banking activity", "Activité de mise en banque"),
("generic", "Generic", "Générique"),
("no aliquot", "No aliquot", "Pas d'aliquot"),
("no data for [%s.%s]", "No data for [%s.%s]", "Pas de données pour [%s.%s]");

ALTER TABLE cd_icm_generics
 MODIFY created DATETIME NOT NULL;
ALTER TABLE cd_icm_generics_revs
 MODIFY created DATETIME NOT NULL;
ALTER TABLE lab_type_laterality_match
 MODIFY created DATETIME NOT NULL;
ALTER TABLE qc_nd_ed_all_procure_lifestyles
 MODIFY created DATETIME NOT NULL,
 MODIFY modified DATETIME NOT NULL;
ALTER TABLE qc_nd_ed_all_procure_lifestyles_revs
 MODIFY created DATETIME NOT NULL,
 MODIFY modified DATETIME NOT NULL;
ALTER TABLE sd_der_of_cells
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_der_of_cells_revs
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_der_of_sups
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_der_of_sups_revs
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_spe_other_fluids
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_spe_other_fluids_revs
 MODIFY created DATETIME NOT NULL;
 
TRUNCATE missing_translations;