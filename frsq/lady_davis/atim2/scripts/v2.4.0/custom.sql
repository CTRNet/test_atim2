DROP VIEW qc_lady_supplier_depts1;
CREATE VIEW qc_lady_supplier_depts1 AS
SELECT collection_id, supplier_dept AS supplier_dept 
FROM sample_masters AS sm
INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id 
LEFT JOIN specimen_details AS sd ON sm.id=sd.sample_master_id
WHERE sample_category='specimen' AND sm.deleted != 1
GROUP BY collection_id, supplier_dept;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='qc_lady_label');
DELETE FROM structure_fields WHERE field='qc_lady_label';