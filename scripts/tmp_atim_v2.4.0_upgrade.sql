-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.4.0', NOW(), '> 3250');

REPLACE INTO i18n(id, en, fr) VALUES
('previous versions', 'Previous versions', 'Versions précédentes'),
('add to order', 'Add To Order', 'Ajouter aux commandes'),
('temporary browsing', 'Temporary browsing', 'Navigation temporaire'),
('unsaved browsing trees that are automatically deleted when there are more than x', 
 'Unsaved browsing trees that are automatically deleted when there are more than 5.',
 "Arbres de navigation non enregistrés qui sont supprimés automatiquement lorsqu'il y en a plus de 5."),
('saved browsing', 'Saved browsing', 'Navigation enregistrée'),
('saved browsing trees', 'Saved browsing trees', 'Arbres de navigation enregistrés'),
('adding notes to a temporary browsing automatically moves it towards the saved browsing list',
 'Adding notes to a temporary browsing automatically moves it towards the saved browsing list.',
 "Ajouter des notes à une navigation temporaire la déplace automatiquement vers la liste des navigations enregistrées."),
("STR_NAVIGATE_UNSAVED_DATA",
 "You have unsaved modifications. Are you sure you want to leave this page?",
 "Vous avez des modifications non enregistrées. Êtes-vous certain de vouloir quitter cette page?"); 

UPDATE i18n SET id='the aliquot with barcode [%s] has reached a volume bellow 0', en='The aliquot with barcode [%s] has reached a volume below 0.' WHERE id='the aliquot with barcode [%s] has reached a volume bellow 0';

ALTER TABLE datamart_browsing_indexes
 ADD COLUMN temporary BOOLEAN NOT NULL DEFAULT true AFTER notes;
ALTER TABLE datamart_browsing_indexes_revs
 ADD COLUMN temporary BOOLEAN NOT NULL DEFAULT true AFTER notes;
 
UPDATE datamart_browsing_indexes SET temporary=false;
UPDATE datamart_browsing_indexes_revs SET temporary=false;