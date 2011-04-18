-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.2 beta', NOW(), '> 2923');

DELETE FROM i18n WHERE id=BINARY('Details') AND page_id='global';
DELETE FROM i18n WHERE id=BINARY('inv_collection_type_defintion') AND page_id='';
DELETE FROM i18n WHERE id=BINARY('May') AND page_id='global';
DELETE FROM i18n WHERE id=BINARY('Next') AND page_id='global';
DELETE FROM i18n WHERE id=BINARY('Prev') AND page_id='global';
