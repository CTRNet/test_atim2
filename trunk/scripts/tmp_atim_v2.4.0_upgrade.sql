-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.4.0', NOW(), '> 3250');

INSERT INTO i18n(id, en, fr) VALUES
('previous versions', 'Previous versions', 'Versions précédentes'),
('add to order', 'Add To Order', 'Ajouter aux commandes');