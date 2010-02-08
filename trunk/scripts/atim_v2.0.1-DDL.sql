-- All DDL related updates go here

/*
	Module: Core
	Description:
*/




/*
	Module: Clinical Annotation
	Description:
*/

-- Diagnosis - Laterality field was not present. Added to both detail and revision table.
ALTER TABLE `dxd_tissues` CHANGE `text_field` `laterality` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
ALTER TABLE `dxd_tissues_revs` CHANGE `text_field` `laterality` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';


/*
	Module: Inventory Management
	Description:
*/