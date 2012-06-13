ALTER TABLE collections
 ADD COLUMN misc_identifier_id INT DEFAULT NULL AFTER collection_notes,
 ADD FOREIGN KEY (misc_identifier_id) REFERENCES misc_identifiers(id);
ALTER TABLE collections_revs
 ADD COLUMN misc_identifier_id INT DEFAULT NULL AFTER collection_notes;

UPDATE collections AS c INNER JOIN clinical_collection_links AS ccl ON c.id=ccl.collection_id SET c.misc_identifier_id=ccl.misc_identifier_id;
UPDATE collections AS c INNER JOIN collections_revs AS cr ON c.id=cr.id SET cr.misc_identifier_id=c.misc_identifier_id;
