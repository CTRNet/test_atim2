-- CCBR Customization Script
-- Version: v0.6
-- ATiM Version: v2.4.1

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.6', '');

-- Fix for v2.4.1 upgrade
-- You need to alter your existing treatment details table. 
-- The field "tx_master_id" should now be renamed to "treatment_master_id".

ALTER TABLE `txd_ccbr_bone_marrow_transplants` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;
ALTER TABLE `txd_ccbr_bone_marrow_transplants_revs` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;
ALTER TABLE `txd_ccbr_other_treatments` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;
ALTER TABLE `txd_ccbr_other_treatments_revs` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;


-- =============================================================================== -- 
-- 								CORE
-- =============================================================================== --



