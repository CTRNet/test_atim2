REPLACE INTO i18n (id, en, fr) VALUES
('core_appname', 'ATiM - Advanced Tissue Management', 'ATiM - Application de gestion avancée des tissus'),
('core_installname', 'OHRI', 'IRHO');

INSERT INTO datamart_reports (name, description, form_alias_for_search, form_alias_for_results, function, flag_active) VALUES
('terry fox export', 'terry fox export', 'report_date_range_definition', 'foo', 'terryFox', '1');

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
(4, 'Terry Fox Report', '/datamart/reports/manageReport/7', 1);
