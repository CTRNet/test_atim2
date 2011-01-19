-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM for CUSM Bank
--	NOTE: 
--		- See 2.atim_v2.0.1_cusm_upgrade.sql for instruction
-- -------------------------------------------------------------------

-- Drop old id fields from Structure tables
ALTER TABLE `structures` DROP `old_id`;

ALTER TABLE `structure_fields` DROP `old_id` ;
ALTER TABLE `structure_formats`
  DROP `old_id`,
  DROP `structure_old_id`,
  DROP `structure_field_old_id`;

-- Unique constraint for fields, move to end of script
ALTER TABLE `structure_fields`
	ADD UNIQUE `unique_fields` (`plugin`, `model`, `tablename`, `field`);
	
-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.1', `date_installed` = '2010-04-12 12:13:43', `build_number` = '1180'
WHERE `versions`.`id` =1;
