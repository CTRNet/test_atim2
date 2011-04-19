-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.0 alpha', NOW(), '> 2840');

ALTER TABLE structure_permissible_values_customs
 ADD COLUMN display_order TINYINT UNSIGNED DEFAULT 0 AFTER fr;
ALTER TABLE structure_permissible_values_customs_revs
 ADD COLUMN display_order TINYINT UNSIGNED DEFAULT 0 AFTER fr;
 
REPLACE INTO i18n (id, en, fr) VALUES
("you cannot configure an empty list", "You cannot configure an empty list", "Vous ne pouvez pas configurer une liste vide"),
("alphabetical ordering", "Alphabetical ordering", "Ordonnancement alphabétique"),
("dropdown_config_desc", 
 "To have the list ordered alphabetically with the displayed values, check the \"Alphabetcical ordering\" option. Otherwise, uncheck it and use the cursor to drag the lines in the order you want the options to be displayed.",
 "Pour que la liste soit ordinnée alphabétiquement par les valeurs affichées, cochez l'option \"Ordonnancement alphabétique\". Sinon, décochez la et utilisez le curseur pour déplacer les lignes dans l'ordre d'affichage que vous voulez."),
("configure", "Configure", "Configurer");

DROP TABLE datamart_batch_processes;