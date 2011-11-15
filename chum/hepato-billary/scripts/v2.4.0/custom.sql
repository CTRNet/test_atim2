-- run after 2.4.0

ALTER TABLE users 
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);

DROP TABLE tmp_bogus_primary_dx;

ALTER TABLE datamart_batch_sets
 DROP COLUMN form_alias_for_results,
 DROP COLUMN sql_query_for_results,
 DROP COLUMN form_links_for_results,
 DROP COLUMN flag_use_query_results,
 DROP COLUMN plugin,
 DROP COLUMN model;

UPDATE lab_book_controls SET flag_active = 0;
UPDATE realiquoting_controls SET lab_book_control_id = NULL;
UPDATE parent_to_derivative_sample_controls SET lab_book_control_id = NULL; 
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='lab_book_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lab_book_code_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET FLAG_ACTIVE = 0 WHERE use_link like '/labbook%';


ALTER TABLE diagnosis_masters 
 DROP COLUMN dx_identifier,
 DROP COLUMN primary_number,
 DROP COLUMN dx_origin;
ALTER TABLE diagnosis_masters_revs
 DROP COLUMN dx_identifier,
 DROP COLUMN primary_number,
 DROP COLUMN dx_origin; 
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier'));
DELETE FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier');


DELETE FROM diagnosis_controls WHERE form_alias LIKE 'dx_cap_%';

UPDATE structure_formats SET flag_summary = 0 WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters');
UPDATE structure_formats sf_sm, structure_formats sf_old
SET sf_sm.flag_summary = 1 
WHERE sf_sm.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters')
AND sf_sm.structure_field_id = sf_old.structure_field_id 
AND sf_old.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result') 
AND sf_old.flag_summary = '1';
DELETE from structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result');
DELETE from structures WHERE alias = 'sample_masters_for_search_result';
