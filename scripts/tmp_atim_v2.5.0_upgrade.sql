INSERT INTO `versions` (version_number, date_installed, build_number) 
VALUES('2.5.0', NOW(), '> 3857');

REPLACE INTO i18n (id, en, fr) VALUES
('reserved for study', 'Reserved For Study/Project', 'Réservé pour une Étude/Projet'),
('identifier name', 'Identifier Name', "Nom d'identifiant");