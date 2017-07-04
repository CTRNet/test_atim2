-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');

UPDATE datamart_structure_functions SET flag_active = 0 
WHERE label IN ('add to order', 'create tma slide', 'edit', 'create participant message (applied to all)', 'defined as returned', 'edit', 'add to order');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6473' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE procure_ed_lab_pathologies MODIFY histology_other_precision varchar(250) DEFAULT NULL;
ALTER TABLE procure_ed_lab_pathologies_revs MODIFY histology_other_precision varchar(250) DEFAULT NULL;

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('no data', 'No Data', 'Aucune données'),
('report limited to', 'Report limited to', 'Rapport limité à');

UPDATE structure_fields SET language_label = "encountered patients with no collection"  WHERE language_label = "encountered patients with collection with no collection";
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('encountered patients with no collection', 'Encountered patients with no collection', "Patients recontrés sans collection");

REPLACE INTO i18n (id,en,fr) 
VALUES
('patients whose clinical data have been updated', 'Patients with at least one clinical event (recorded into ATiM)', "Patients ayant au moins un événement clinique (enregistré dans ATiM)");

UPDATE versions SET site_branch_build_number = '6748' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------







L'onglet contact ne sert à rien pour nous
L'onglet message ne sert à rien

TODO procure_banks_data_merge_messages



TODO:
  - Faut il supprimer les dates de chirurgie.
  - HTTPS sur les serveur central.
  - EXporter le résumé de la migration en csv et non html
  - Faire un truncate dans le processus de merge pour ne pas avoir des ids trop grand.