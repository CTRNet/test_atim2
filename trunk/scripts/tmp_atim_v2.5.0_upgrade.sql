INSERT INTO `versions` (version_number, date_installed, build_number, created, created_by, modified, modified_by) 
VALUES('2.5.0', NOW(), '> 3857', NOW(), 1, NOW(), 1);

REPLACE INTO i18n (id, en, fr) VALUES
('reserved for study', 'Reserved For Study/Project', 'Réservé pour une Étude/Projet');