-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.6', NOW(), '3556');

UPDATE structure_fields SET structure_value_domain = NULL WHERE type = 'yes_no';

UPDATE structures, structure_formats, structure_fields
SET structure_formats.flag_search = '1',
structure_formats.flag_index = '1',
structure_formats.flag_summary = '0'
WHERE structure_formats.structure_id = structures.id
AND structure_fields.id = structure_formats.structure_field_id
AND structures.alias LIKE 'dx_cap_report_%' 
AND structure_formats.flag_detail = '1'
AND structure_fields.field != 'notes';

UPDATE structure_formats 
SET structure_field_id = (SELECT id FROM structure_fields WHERE language_tag LIKE '' AND field = 'major_hepatectomy_3_segments_or_more') 
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE language_label  LIKE '' AND field = 'major_hepatectomy_3_segments_or_more');
DELETE FROM structure_fields WHERE language_label  LIKE '' AND field = 'major_hepatectomy_3_segments_or_more';

UPDATE structure_formats 
SET structure_field_id = (SELECT id FROM structure_fields WHERE language_tag LIKE '' AND field = 'minor_hepatectomy_less_than_3_segments') 
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE language_label  LIKE '' AND field = 'minor_hepatectomy_less_than_3_segments');
DELETE FROM structure_fields WHERE language_label  LIKE '' AND field = 'minor_hepatectomy_less_than_3_segments';