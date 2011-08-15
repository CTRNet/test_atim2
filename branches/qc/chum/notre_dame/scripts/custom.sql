ALTER TABLE ad_blocks
 DROP COLUMN path_report_code;
ALTER TABLE ad_blocks_revs
 DROP COLUMN path_report_code;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'path_report_code');
DELETE FROM structure_fields WHERE field = 'path_report_code' ;
