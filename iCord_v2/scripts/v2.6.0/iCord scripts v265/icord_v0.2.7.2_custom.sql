-- Increase allowable range for Injury Force (kdynes) #620
ALTER TABLE `dxd_animals` CHANGE COLUMN `pig_injury_force` `pig_injury_force` varchar(5) NULL DEFAULT NULL AFTER `pig_injury_height`;