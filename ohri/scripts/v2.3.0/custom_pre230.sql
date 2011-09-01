-- Run pre 2.3.0.

REPLACE INTO i18n (id, en, fr) VALUES
('core_appname', 'ATiM - Advanced Tissue Management', 'ATiM - Application de gestion avancée des tissus'),
('core_installname', 'OHRI', 'IRHO');

INSERT INTO datamart_reports (name, description, form_alias_for_search, form_alias_for_results, function, flag_active) VALUES
('terry fox export', 'terry_fox_export_description', 'report_date_range_definition', 'foo', 'terryFox', '1');

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
(4, 'Terry Fox Report', '/datamart/reports/manageReport/7', 1);

REPLACE INTO i18n (id, en, fr) VALUES
("terry_fox_export_description",
 "To generate the Terry Fox report, you need to build a participant using either the databrowser or a batch set. Then you can select \"Terry Fox Report\" in \"Batch Actions\".",
 "Pour générer le rapport Terry Fox, vous devez construire une liste de participants soit à partir du navigateur de données ou d'un lot de données. Puis vous sélectionnez l'option \"Rapport Terry Fox\" dans \"Traitement par lot\"."); 