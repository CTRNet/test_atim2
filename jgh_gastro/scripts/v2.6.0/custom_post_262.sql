
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'participant identifiers report';

UPDATE versions SET branch_build_number = '5740' WHERE version_number = '2.6.2';
