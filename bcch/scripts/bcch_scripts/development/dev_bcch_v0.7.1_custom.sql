-- BCCH Customization Script
-- Version 0.7.1
-- ATiM Version: 2.6.7

use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.7.1 - Development Version", '');