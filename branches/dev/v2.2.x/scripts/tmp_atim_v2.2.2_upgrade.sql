-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.2 beta', NOW(), '> 2923');

DELETE FROM i18n WHERE id='Details' AND page_id='global';
DELETE FROM i18n WHERE id='inv_collection_type_defintion' AND page_id='';
DELETE FROM i18n WHERE id='may' AND page_id='';
DELETE FROM i18n WHERE id='Next' AND page_id='global';
DELETE FROM i18n WHERE id='Prev' AND page_id='global';
DELETE FROM i18n WHERE id='received tissue weight' AND page_id='global';

ALTER TABLE participant_contacts
 MODIFY phone_secondary VARCHAR(30) NOT NULL DEFAULT '';
ALTER TABLE participant_contacts_revs
 MODIFY phone_secondary VARCHAR(30) NOT NULL DEFAULT '';