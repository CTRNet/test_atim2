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


TODO:
  - Faut il supprimer les dates de chirurgie.
  - HTTPS sur les serveur central.
  - EXporter le résumé de la migration en csv et non html
  - Faire un truncate dans le processus de merge pour ne pas avoir des ids trop grand.