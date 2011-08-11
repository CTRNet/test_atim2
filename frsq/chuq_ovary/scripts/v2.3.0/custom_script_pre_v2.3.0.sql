ALTER TABLE aliquot_masters
	DROP COLUMN aliquot_label;
ALTER TABLE aliquot_masters_revs
	DROP COLUMN aliquot_label;

UPDATE structure_fields SET field = 'aliquot_label_to_delete' WHERE field like 'aliquot_label';
	